import 'dart:convert';
import 'dart:io';
import 'dart:math';
import "package:async/async.dart";
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:trashhunters/models/typetrash_model.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:trashhunters/pages/tools/easy_loader.dart';

import '../../functions/UserFunctions.dart';
import '../../models/account_model.dart';
import '../../models/personne_model.dart';

class Trash extends StatefulWidget {
  const Trash({Key? key}) : super(key: key);
  @override
  _TrashPageState createState() => _TrashPageState();
}

class _TrashPageState extends State<Trash> {
  XFile _imageFile = XFile("");
  File imagefile = File("");
  final ImagePicker _picker = ImagePicker();
  String nomPhoto = "";

  String? levelConnected = "0";
  String? numberConnected = "0";
  String? idAccountConnected = "0";
  String idPersonneConnected = "0";
  Personne? personneConnected;
  Account? accountConnected;

  bool _isRunning = false;
  bool _isLoading = false;
  bool showPassword = false;
  List<TypeTrash> listTypeTrash = [];

  TextEditingController controllerDescription = TextEditingController();

  var _items;
  List<TypeTrash> _selectedTypeTrash = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  getAllTypeTrash() async {
    final urlListTypeTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/typetrash/listAllTypeTrash.php");
    final responseListTypeTrash = await http.post(urlListTypeTrash);

    if(responseListTypeTrash.statusCode == 200) {
      final mapTypeTrash = json.decode(responseListTypeTrash.body);
      final allTypeTrash = mapTypeTrash["result"];
      if(allTypeTrash != "false") {
        for(var myTypeTrash in allTypeTrash) {
          TypeTrash t = TypeTrash(
              myTypeTrash['idType'],
              myTypeTrash['libelle'],
              myTypeTrash['description']
          );
          listTypeTrash.add(t);
        }
      }
    }
    setState(() {
      _isLoading = true;
      _items = listTypeTrash
          .map((typeTrash) => MultiSelectItem<TypeTrash>(typeTrash, typeTrash.libelle))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _isRunning = false;
    initValue();
  }

  initValue() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = path.join(dir, 'assets/images/livre-blanc-tri.jpeg');
    setState(() {
      _imageFile = XFile(newPath);
      imagefile = File(_imageFile.path);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String level = prefs.getString('level').toString();
    String idAccount = prefs.getString('idAccount').toString();
    String idPersonne = prefs.getString('idPersonne').toString();

    Personne? p = await UserFunctions().getDetailsPersonne(number);
    Account? a = await UserFunctions().getDetailsAccount(idAccount);

    setState(() {
      numberConnected = number;
      levelConnected = level;
      idAccountConnected = idAccount;
      idPersonneConnected = idPersonne;
      personneConnected = p;
      accountConnected = a;
      _isLoading = true;
    });
    getAllTypeTrash();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addTrash(String idType, String gender, String photo) async {
    if (gender.isEmpty) {
      print("EMPTY GENDER");
      setState(() {
        error(context, "Veillez renseigner une description !");
        _isLoading = false;
      });
    } else {
      final urlAddTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/addTrash.php");

      DateTime dt = DateTime.now();
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
      print("idPersonne : $idPersonneConnected, idType : $idType, gender : $gender, image : $photo,  dateEnregistrement : $formattedDate");

      final responseAddTrash = await http.post(urlAddTrash, body: {
        "idPersonne": idPersonneConnected,
        "idType": idType,
        "gender": gender,
        "image": photo,
        "dateEnregistrement": formattedDate
      });
      if(responseAddTrash.statusCode == 200) {
        setState(() {
          _isRunning = false;
        });
        error(context, "Déclaration d'ordure enregistrée avec succès.");
        Navigator.of(context).pushReplacementNamed('/history');
      }
    }
  }

  void error(BuildContext context, String error) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(error,style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,)),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ! _isLoading ? const EasyLoader() : Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 5,
        titleSpacing: 5,
        title: const Text(
          "Signaler des Ordures",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),textAlign: TextAlign.center,),
        leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white,),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
        actions: const [
          // IconButton(
          //   icon: Icon(
          //     Icons.settings,
          //     color: Colors.green,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              const SizedBox(height: 15,),
              const Text(
                "Description",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87,),
              ),
              const SizedBox(height: 5,),
              buildTextField("", "Je suis à la maison vous pouvez vider mes ordures svp. J'ai plusieurs type d'ordure", 4, controllerDescription),
              const SizedBox(height: 5,),
              const Text("Selectionner le type de déchet",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87,),
              ),
              const SizedBox(height: 5,),
              MultiSelectBottomSheetField<TypeTrash>(
                key: _multiSelectKey,
                initialChildSize: 0.7,
                maxChildSize: 0.95,
                selectedColor: primaryColor,
                buttonIcon: const Icon(Icons.restore_from_trash, color: thirdColor,),
                title: const Text("Types d'ordures"),
                buttonText: const Text("Cliquer pour choisir..."),
                items: _items,
                searchable: true,
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return "Obligatoire";
                  }
                  List names = values.map((e) => e.libelle).toList();
                  if (names.contains("Frog")) {
                    return "Frogs are weird!";
                  }
                  return null;
                },
                onConfirm: (values) {
                  setState(() {
                    _selectedTypeTrash = values;
                  });
                  _multiSelectKey.currentState?.validate();
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (item) {
                    setState(() {
                      _selectedTypeTrash.remove(item);
                    });
                    _multiSelectKey.currentState?.validate();
                  },
                ),
              ),
              const SizedBox(height: 30,),
              const Text(
                "Image descriptive",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black87,),
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (imagefile != "")
                                  ? FileImage(File(imagefile.path)) as ImageProvider
                                  : AssetImage("assets/images/livre-blanc-tri.jpeg")
                              //image: AssetImage("assets/images/livre-blanc-tri.jpeg")
                          )
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor,),
                            color: primaryColor,
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => bottomSheet()),
                              );
                            },
                            child: const Icon(Icons.edit, color: Colors.white,),
                          ),
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.cancel_outlined, size: 24.0, color: Colors.white,),
                    label: const Text("Annuler",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(secondaryYellow),
                    ),
                    onPressed: () { Navigator.of(context).pushReplacementNamed('/history'); },
                    //child: const Text("Annuler", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white)),
                  ),
                  TextButton.icon(
                    icon: _isRunning
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)
                        : const Icon(Icons.restore_from_trash_outlined, size: 24.0, color: Colors.white,),
                    label: Text(
                      _isRunning ? 'Patientez...' : "Enregistrer",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),),
                    onPressed: () async {
                      setState(() {
                        _isRunning = true;
                      });
                      uploadImage(nomPhoto, imagefile);
                      for (var e in _selectedTypeTrash) {
                        addTrash(e.idType, controllerDescription.text, nomPhoto);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(thirdColor),
                    ),
                    //child: const Text("Enregistrer", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, int nbLigne, TextEditingController controllerText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controllerText,
        maxLines: nbLigne,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54,)),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text("Choisir une photo de vos ordures", style: TextStyle(fontSize: 20.0,),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton.icon(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: const Text("Camera"),
            ),
            const SizedBox(width: 20,),
            ElevatedButton.icon(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: const Text("Galerie"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    DateTime dt = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyy').format(dt);
    setState(() {
      nomPhoto = "Trash_${Random().nextInt(1000)}_${idPersonneConnected}_${formattedDate}";
    });

    final pickedFile = await _picker.pickImage(source: source,);
    setState(() {
      _imageFile = pickedFile!;
    });
    String dir = (await getApplicationDocumentsDirectory()).path;
    String newPath = path.join(dir, '$nomPhoto.png');
    File f = await File(pickedFile!.path).copy(newPath);
    String newPhoto = File(newPath).path.split('/').last;

    File profil = File(newPath);
    setState(() {
      nomPhoto = newPhoto;
      imagefile = profil;
    });
    Navigator.of(context).pop();
  }

  Future uploadImage(String name, File fichier) async {
    var stream= http.ByteStream(DelegatingStream.typed(fichier.openRead()));
    var length= await fichier.length();
    final uri = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/uploadImageTrash.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['name'] = name;
    var pic = http.MultipartFile("image", stream, length, filename: path.basename(fichier.path));
    request.files.add(pic);
    var response = await request.send();

    // if (response.statusCode == 200) {
    //   error(context, "Image de vos ordures enregsitrée avec succès.");
    // }else{
    //   error(context, "Erreur! Veuillez choisir une autre image de vos ordures.");
    // }
  }

  void presentLoader(BuildContext context, {
    String text = 'Patientez...',
    bool barrierDismissible = false,
    bool willPop = true}) {
    showDialog(
        barrierDismissible: barrierDismissible,
        context: context,
        builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              return willPop;
            },
            child: AlertDialog(
              content: Row(
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SizedBox(width: 20.0,),
                  Text(text, style: const TextStyle(fontSize: 18.0),)
                ],
              ),
            ),
          );
        });
  }
}
