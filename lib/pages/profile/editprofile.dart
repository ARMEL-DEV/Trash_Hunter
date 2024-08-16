import 'dart:convert';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import '../../functions/UserFunctions.dart';
import '../../models/personne_model.dart';
import '../../models/zone_model.dart';

class EditProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EditProfileOnePage();
  }
}
class EditProfileOnePage extends StatefulWidget {

  @override
  _EditProfileOnePageState createState() => _EditProfileOnePageState();
}

class _EditProfileOnePageState extends State<EditProfileOnePage> {
  //String image = 'assets/images/profil.jpeg';
  bool _isLoading = false;
  bool _isUpdating = false;
  bool showPassword = false;
  List<Zones> listZones = [];

  String numberConnected = "";
  String? idPersonneConnected = "0";
  Personne? personneConnected;

  TextEditingController controllerNom = TextEditingController();
  TextEditingController controllerPrenom = TextEditingController();
  TextEditingController controllerAdresse = TextEditingController();
  TextEditingController controllerContact = TextEditingController();
  TextEditingController controllerEmails = TextEditingController();

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

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String idPersonne = prefs.getString('idPersonne').toString();

    Personne? p = await UserFunctions().getDetailsPersonne(number);

    setState(() {
      idPersonneConnected = idPersonne;
      numberConnected = number;
      personneConnected = p;

      controllerNom.text = "${personneConnected?.nom}";
      controllerPrenom.text = "${personneConnected?.prenom}";
      controllerAdresse.text = "${personneConnected?.adresse}";
      controllerContact.text = "${personneConnected?.contact}";
      controllerEmails.text = "${personneConnected?.email}";
    });
  }

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

  void signOut() async {
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('number');
    prefs.remove('level');
    prefs.remove('idAccount');
    prefs.remove('idPersonne');
    prefs.setBool('isLoggedIn', false);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacementNamed('/signin');
  }

  void editPersonneFunction(String id, String nom, String prenom, String adresse, String number, String email) async {
    setState(() {
      _isUpdating = true;
    });
    if (number.isEmpty) {
      error(context, "Veillez remplir le champ Numéro de téléphone");
    } else if (email.isEmpty) {
      error(context, "Veillez remplir le champ E-mail");
    } else if (nom.isEmpty) {
      error(context, "Veillez remplir le champ Nom");
    } else if (adresse.isEmpty) {
      error(context, "Veillez remplir le champ Adresse");
    } else {
      final urlUpdatePersonne = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/updatePersonne.php");
      final responseUpdatePersonne = await http.post(urlUpdatePersonne, body: {
        "idPersonne": id,
        "nom": nom,
        "prenom": prenom,
        "sexe": "${personneConnected?.sexe}",
        "contact": number,
        "adresse": adresse,
        "email": email
      });

      if (responseUpdatePersonne.statusCode == 200) {
        error(context, "Informations personnelles modifiées avec succès.");
        await Future.delayed(const Duration(seconds: 3));
        if(number.compareTo(numberConnected) != 0){
          error(context, "Vous allez être déconnecté ! Veillez-vous connecter avec votre nouveau numéro de téléphone.");
          await Future.delayed(const Duration(seconds: 3));
          signOut();
        }else{
          Navigator.pop(context, 'refresh');
        }
      }else{
        error(context, "Une erreur est survenue ! Vérifiez votre connexion Internet.");
      }
    }
  }

  @override
  void initState() {
    _isLoading = false;
    _isUpdating = false;
    initValue();
    getAllZone();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'refresh');
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 250,
                width: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/home1.jpg"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                child: Column(
                  children: <Widget>[
                    ! _isLoading
                    ? const Center(child: CircularProgressIndicator(color: primaryColor,),)
                    : Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          const ListTile(title: Text("Modifier vos informations personnelles",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold ),),),
                          const Divider(),
                          const SizedBox(height: 15,),
                          buildTextField("Nom", "${personneConnected?.nom}", controllerNom, false),
                          buildTextField("Prenom", "${personneConnected?.prenom}", controllerPrenom, false),
                          buildTextField("E-mail", "${personneConnected?.email}", controllerEmails, false),
                          buildTextField("Contact", "${personneConnected?.contact}", controllerContact, false),
                          buildCustomComboBoxField("${personneConnected?.adresse}", listZones, controllerAdresse, 0),
                          _isUpdating
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Center(child: CircularProgressIndicator(color: primaryColor,),),
                            ],
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: thirdColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),
                                onPressed: () { Navigator.pop(context, ); },
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text("Annuler", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                ),
                                onPressed: () {
                                  editPersonneFunction("${personneConnected?.idPersonne}", controllerNom.text, controllerPrenom.text, controllerAdresse.text, controllerContact.text, controllerEmails.text);
                                },
                                icon: const Icon(Icons.save_as),
                                label: const Text("Enregistrer", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildCustomComboBoxField(String label, List<Zones> list, TextEditingController controller, int placholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, right: 0.0, left: 0.0),
      child: CustomSearchableDropDown(
        items: list,
        label: 'Adresse actuelle : $label',
        dropdownHintText: "Rechercher un quartier",
        decoration: const BoxDecoration(color: Colors.transparent, border: Border(bottom: BorderSide(color: Colors.blueGrey),)),
        menuMode: false,
        prefixIcon: const Icon(Icons.maps_home_work_outlined, color: Colors.black,),
        suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.black,),
        labelStyle: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        dropDownMenuItems: list.map((item) {return item.libelle;}).toList() ?? [],
        showLabelInMenu: true,
        initialIndex: (placholder!=0) ? placholder : null,
        onChanged: (value){
          if(value!=null) {
            setState(() {
              controllerAdresse.text = value.libelle;
            });
          }
        },
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, TextEditingController controller, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 10, right: 10),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(showPassword ? Icons.remove_red_eye : Icons.password, color: Colors.grey,),
                )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black,)),
      ),
    );
  }
}
