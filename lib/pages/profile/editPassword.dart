import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:http/http.dart' as http;

class EditPasswordPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return EditPasswordOnePage();
  }
}
class EditPasswordOnePage extends StatefulWidget {

  @override
  _EditPasswordOnePageState createState() => _EditPasswordOnePageState();
}

class _EditPasswordOnePageState extends State<EditPasswordOnePage> {
  String image = 'assets/images/profil.jpeg';
  bool showPassword = false;
  bool _isUpdating = false;
  String? numberConnected = "0";
  String? idAccountConnected = "0";
  String? idPersonneConnected = "0";

  TextEditingController controllerLogin = TextEditingController();
  TextEditingController controllerOldPassword = TextEditingController();
  TextEditingController controllerNewPassword = TextEditingController();

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String idAccount = prefs.getString('idAccount').toString();
    String idPersonne = prefs.getString('idPersonne').toString();

    setState(() {
      numberConnected = number;
      idAccountConnected = idAccount;
      idPersonneConnected = idPersonne;
      controllerLogin.text = number;
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
    setState(() {
      _isUpdating = false;
    });
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

  void editPasswordFunction(String idPerson, String idAccount, String oldPassword, String newPassword) async {
    setState(() {
      _isUpdating = true;
    });
    if (oldPassword.isEmpty) {
      error(context, "Veillez renseigner votre ancien mot de passe");
    } else if (newPassword.isEmpty) {
      error(context, "Veillez renseigner un nouveau mot de passe");
    } else {
      final urlFindAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/account/findAccountByLoginPassword.php");
      final responseFindAccount = await http.post(urlFindAccount, body: {
        "login": numberConnected,
        "password": oldPassword,
      });

      if (responseFindAccount.statusCode == 200) {
        final mapFindAccount = json.decode(responseFindAccount.body);
        final infoAccount = mapFindAccount["result"];
        if(infoAccount != "false") {
          final urlUpdatePassword = Uri.parse(
              "https://trashhunter.dshcenter.com/api/GestionComptes/account/updateAccount.php");
          final responseUpdatePassword = await http.post(
              urlUpdatePassword, body: {
            "idPersonne": idPerson,
            "idAccount": idAccount,
            "newpassword": newPassword
          });

          if (responseUpdatePassword.statusCode == 200) {
            setState(() {
              error(context,
                  "Mot de passe modifié avec succès. Vous allez être déconnecté dans quelques secondes");
            });
            await Future.delayed(const Duration(seconds: 3));
            signOut();
          } else {
            setState(() {
              error(context,
                  "Une erreur est survenue ! Vérifiez votre connexion Internet.");
            });
          }
        } else {
          setState(() {
            error(context, "Désolé ! Ancien mot de passe incorrect.");
          });
        }
      }
    }
  }

  @override
  void initState() {
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
                        const ListTile(title: Text("Modifier votre mot de passe",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold ),),),
                        const Divider(),
                        const SizedBox(height: 15,),
                        buildTextField("Identifiant", "$numberConnected", controllerLogin, false, false),
                        buildTextField("Ancien Mot de Passe", "********", controllerOldPassword, true, true),
                        buildTextField("Nouveau Mot de Passe", "********", controllerNewPassword, true, true),
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
                                editPasswordFunction("$idPersonneConnected", "$idAccountConnected", controllerOldPassword.text, controllerNewPassword.text);
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
    );
  }

  Widget buildTextField(String labelText, String placeholder, TextEditingController controller, bool isPasswordTextField, bool enable) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0, left: 10, right: 10),
      child: TextField(
        enabled: enable,
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
