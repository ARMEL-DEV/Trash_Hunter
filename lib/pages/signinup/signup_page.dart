import 'dart:convert';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';

import '../../models/account_model.dart';
import '../../models/personne_model.dart';
import '../../models/zone_model.dart';
import '../tools/easy_loader.dart';

class SignUpPage extends StatelessWidget{
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const SignUp();
  }
}
class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUp> {
  bool _isLogin = false;

  bool _isLoading = false;
  List<Zones> listZones = [];
  String selectedAdresse = "";
  late Personne personConnected;
  late Account accountConnected;

  String _mobileNumber = '';

  TextEditingController controllerNom = TextEditingController();
  TextEditingController controllerPrenom = TextEditingController();
  TextEditingController controllerAdresse = TextEditingController();
  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerPass = TextEditingController();

  void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.0,)),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropDownZones {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var element in listZones) {
      menuItems.add(DropdownMenuItem(value: element.libelle, child: Text(element.libelle)));
    }
    return menuItems;
  }

  getAllZone() async {
    final urlGetAllZones = Uri.parse("https://trashhunter.dshcenter.com/api/application/listAllZones.php");
    final responseGetAllZones = await http.post(urlGetAllZones);

    if(responseGetAllZones.statusCode == 200) {
      final mapGetAllZones = json.decode(responseGetAllZones.body);
      final allDetailsTypeTrash = mapGetAllZones["result"];
      if(allDetailsTypeTrash != "false") {
        for(var detailsAllZones in allDetailsTypeTrash) {
          Zones z = Zones(
              detailsAllZones['id_zone'],
              detailsAllZones['libelle'],
              detailsAllZones['statut']
          );
          listZones.add(z);
        }
      }
    }
    setState(() {
      _isLoading = true;
    });
  }

  void signUpFunction(String nom, String prenom, String adresse, String number, String password) async {
    setState(() {
      _isLogin = true;
    });
    if (number.isEmpty) {
      error(context, "Veillez remplir le champ Numéro de téléphone");
    } else if (password.isEmpty) {
      error(context, "Veillez remplir le champ Mot de passe");
    } else if (nom.isEmpty) {
      error(context, "Veillez remplir le champ Nom");
    } else if (adresse.isEmpty) {
      error(context, "Veillez remplir le champ Adresse");
    } else {
      final urlAddAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/addAccount.php");
      final responseAddAccount = await http.post(urlAddAccount, body: {
        "nom": nom,
        "prenom": prenom,
        "contact": number,
        "adresse": adresse
      });

      String idPerson = "";

      if (responseAddAccount.statusCode == 200) {
        final findIdAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/findPersonneByNomPrenom.php");
        final responsePerson = await http.post(findIdAccount, body: {
          "nom": nom,
          "prenom": prenom
        });

        if(responsePerson.statusCode == 200) {
          final mapPerson = json.decode(responsePerson.body);
          final allPerson = mapPerson["result"];
          if(allPerson != "false") {
            for(var myPerson in allPerson) {
              idPerson = myPerson['idPersonne'];
            }
          }
          final urlAddCompte = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/account/addAccount.php");
          final responseAddCompte = await http.post(urlAddCompte, body: {
            "idPersonne": idPerson,
            "idApp": "1",
            "niveauAcces": "3",
            "login": number,
            "password": password
          });
          if (responseAddCompte.statusCode == 200) {
            final urlAddCoupon = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/coupon/addCoupon.php");
            final responseAddCoupon = await http.post(urlAddCoupon, body: {
              "idPersonne": idPerson,
              "idGain": '5',
              "reste": '1000'
            });

            if (responseAddCoupon.statusCode == 200) {
              error(context, "Inscription effectué avec succès.");
              Navigator.of(context).pushReplacementNamed('/signin');
            }
          }
        }
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _mobileNumber = (await MobileNumber.mobileNumber)!;
      //_simCard = (await MobileNumber.getSimCards)!;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;
    //print('MON NUMERO : ${_mobileNumber.substring(7)}');
    setState(() {
      controllerLogin.text = _mobileNumber.substring(7);
    });
  }

  @override
  void initState() {
    _isLogin = false;
    _isLoading = false;
    getAllZone();

    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ! _isLoading ? const EasyLoader() : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/images/home1.jpg'), fit: BoxFit.fill),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(160 , 161 , 157, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(37.5),
                topRight: Radius.circular(37.5),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Inscription sur Trash Hunter",
                    style: TextStyle(fontSize: 19, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(top: 15.5, right: 22.5, left: 22.5),
                    child: TextField(
                      controller: controllerNom,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1))),
                        icon: Icon(Icons.person_pin_outlined, color: Colors.white,),
                        contentPadding: EdgeInsets.all(11.25),
                        hintText: "Nom",
                        hintStyle: TextStyle(color: Colors.black,),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.5, right: 22.5, left: 22.5),
                    child: TextField(
                      controller: controllerPrenom,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1))),
                        icon: Icon(Icons.person_pin_outlined, color: Colors.white,),
                        contentPadding: EdgeInsets.all(11.25),
                        hintText: "Prénom",
                        hintStyle: TextStyle(color: Colors.black,),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  /*Container(
                    margin: const EdgeInsets.only(top: 15.5, right: 20.5, left: 22.5),
                    child: DropdownButtonFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Adresse",
                          hintStyle: TextStyle(color: Colors.white,),
                          //contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                          prefixIcon: Icon(Icons.maps_home_work_outlined, color: Colors.white,),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1))),
                          filled: false,
                          fillColor: Colors.red,
                        ),
                        validator: (value) => value == null ? "Adresse" : null,
                        dropdownColor: Colors.grey,
                        value: selectedAdresse,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedAdresse = newValue!;
                          });
                        },
                        items: dropDownZones
                    ),
                  ),*/
                  buildCustomComboBoxField("Adresse", listZones, 0),
                  Container(
                    margin: const EdgeInsets.only(top: 15.5, right: 22.5, left: 22.5),
                    child: TextField(
                      controller: controllerLogin,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1))),
                        icon: Icon(Icons.phone_iphone, color: Colors.white,),
                        contentPadding: EdgeInsets.all(11.25),
                        hintText: "Numéro de téléphone",
                        hintStyle: TextStyle(color: Colors.black,),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15.5, right: 22.5, left: 22.5),
                    child: TextField(
                      controller: controllerPass,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(90, 90, 90, 1),
                          ),
                        ),
                        icon: Icon(Icons.lock, color: Colors.white),
                        contentPadding: EdgeInsets.all(11.25),
                        hintText: "Mot de passe",
                        hintStyle: TextStyle(color: Colors.black,),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    margin: const EdgeInsets.only(top: 30, left: 30, right: 30),
                    child: TextButton.icon(
                      icon: _isLogin
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)
                          : const Icon(Icons.person_add_outlined, size: 20.0, color: Colors.white,),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(255, 87, 34, 1),
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: (){signUpFunction(controllerNom.text, controllerPrenom.text, controllerAdresse.text, controllerLogin.text, controllerPass.text);},
                      label: Text(
                        _isLogin ? 'Patientez...' : "S'inscrire",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    margin: const EdgeInsets.only(top: 10, right: 30, left: 30),
                    child: TextButton(
                      style: ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all<Color>(
                        //   Colors.transparent,
                        // ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: (){Navigator.of(context).pushReplacementNamed('/signin');},
                      child: const Text(
                        "J'ai déjà un compte, se connecter",
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 2 - 50,
              top: MediaQuery.of(context).size.height / 10.1,
            ),
            child: const CircleAvatar(
              radius: 50,backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/logo_trashhunter.png"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCustomComboBoxField(String label, List<Zones> list, int placholder) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.5, right: 22.5, left: 22.5),
      child: CustomSearchableDropDown(
        items: list,
        label: label,
        dropdownHintText: "Rechercher un quartier",
        decoration: const BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Colors.blueGrey),)),
        menuMode: false,
        prefixIcon: const Icon(Icons.maps_home_work_outlined, color: Colors.white,),
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
        labelStyle: const TextStyle(fontSize: 15, color: Colors.black,),
        dropDownMenuItems: list.map((item) {return item.libelle;}).toList() ?? [],
        showLabelInMenu: true,
        initialIndex: (placholder!=0) ? placholder : null,
        onChanged: (value){
          print("VALUE : ${value.libelle}");
          if(value!=null) {
            if(label == "Adresse"){
              setState(() {
                selectedAdresse = value.libelle;
              });
            }
          }else{
            /*setState(() {
              controllerPere = enfantConnected!.pere;
              controllerMere = enfantConnected!.mere;
              controllerConjoint = enfantConnected!.conjoint;
            });*/
          }
        },
      ),
    );
  }
}
