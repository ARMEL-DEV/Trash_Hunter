import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import "package:async/async.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:http/http.dart' as http;
import '../../functions/UserFunctions.dart';
import '../../models/personne_model.dart';


class EditAvatarPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EditAvatarOnePage();
  }
}
class EditAvatarOnePage extends StatefulWidget {

  @override
  _EditAvatarOnePageState createState() => _EditAvatarOnePageState();
}

class _EditAvatarOnePageState extends State<EditAvatarOnePage> {
  XFile _imageFile = XFile("");
  File imagefile = File("");
  final ImagePicker _picker = ImagePicker();
  String nomAvatar = "";

  String image = 'assets/images/profil.jpeg';
  bool showPassword = false;
  bool _isLoading = false;
  bool _isUpdating = false;

  String? idPersonneConnected = "0";
  Personne? personneConnected;

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String idPersonne = prefs.getString('idPersonne').toString();

    Personne? p = await UserFunctions().getDetailsPersonne(number);

    setState(() {
      idPersonneConnected = idPersonne;
      personneConnected = p;
      nomAvatar = p.profil;
      _isLoading = true;
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

  @override
  void initState() {
    _isLoading = false;
    _isUpdating = false;
    initValue();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        const ListTile(title: Text("Modifier votre photo de profil",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold ),),),
                        const Divider(),
                        const SizedBox(height: 15,),
                        ! _isLoading
                        ? const CircularProgressIndicator(color: primaryColor)
                        : Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 4, color: thirdColor),
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(fit: BoxFit.cover, image: NetworkImage("https://trashhunter.dshcenter.com/images/profil/$nomAvatar"))),
                              ),
                              Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        _isUpdating = true;
                                        showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet()),
                                        );
                                      },
                                      child: _isUpdating
                                          ? const Center(child: CircularProgressIndicator(color: primaryColor,),)
                                          : const Icon(Icons.photo_camera, color: Colors.white,),
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context, 'refresh');
                },
                icon: const Icon(Icons.arrow_back),
              ),
            )
          ],
        ),
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
          const Text("Choisir une photo de profil", style: TextStyle(fontSize: 20.0,),),
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
    final pickedFile = await _picker.pickImage(source: source,);
    setState(() {
      _imageFile = pickedFile!;
    });
    String dir = (await getApplicationDocumentsDirectory()).path;
    DateTime dt = DateTime.now();
    String formattedDate = DateFormat('Hms').format(dt);
    String newPath = path.join(dir, '${personneConnected?.nom.toLowerCase().replaceAll(" ", "")}${personneConnected?.prenom.toLowerCase().replaceAll(" ", "")}${formattedDate.replaceAll(":", "")}.jpg');
    File f = await File(pickedFile!.path).copy(newPath);
    String newPhoto = File(newPath).path.split('/').last;

    File profil = File(newPath);
    setState(() {
      nomAvatar = newPhoto;
    });
    uploadProfil(newPhoto, profil);
  }

  Future uploadProfil(String name, File fichier) async {
    var stream= http.ByteStream(DelegatingStream.typed(fichier.openRead()));
    var length= await fichier.length();
    final uri = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/updateAvatar.php");
    var request = http.MultipartRequest('POST',uri);
    request.fields['idPersonne'] = "${personneConnected?.idPersonne}";
    request.fields['name'] = name;
    var pic = http.MultipartFile("image", stream, length, filename: path.basename(fichier.path));
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      error(context, "Photo de profil mis à jour avec succès.");
    }else{
      error(context, "Erreur! Veuillez choisir une autre photo pour votre profil.");
    }
    setState(() {
      _isUpdating = false;
    });
    Navigator.pop(context);
  }

}
