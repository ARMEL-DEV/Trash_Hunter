import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_number/mobile_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/account_model.dart';
import '../../models/personne_model.dart';

class SignInPage extends StatelessWidget{
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const SignIn();
  }
}
class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignIn> {
  bool _isLogin = false;

  late Personne personConnected;
  late Account accountConnected;

  String _mobileNumber = '';

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

  void signInFunction(String number, String password) async {
    setState(() {
      _isLogin = true;
    });
    if (number.isEmpty || password.isEmpty) {
      setState(() {
        _isLogin = false;
        error(context, "Veillez remplir le champ Numéro et Mot de passe");
      });
    } else {
      final urlFindAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/account/findAccountByLoginPassword.php");
      final responseFindAccount = await http.post(urlFindAccount, body: {
        "login": number,
        "password": password,
      });

      if (responseFindAccount.statusCode == 200) {
        final mapFindAccount = json.decode(responseFindAccount.body);
        final infoAccount = mapFindAccount["result"];
        if(infoAccount != "false") {
          for(var user in infoAccount) {
            Personne p = Personne(
                user['idPersonne'],
                user['nom'],
                user['prenom'],
                user['sexe'],
                user['email'],
                user['contact'],
                user['adresse'],
                user['profil'],
                user['statut']
            );
            personConnected = p;

            Account a = Account(
                user['idAccount'],
                user['idApp'],
                user['idPersonne'],
                user['login'],
                user['password'],
                user['niveauAcces'],
                user['statut']
            );
            accountConnected = a;
          }

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('number', accountConnected.login);
          prefs.setString('level', accountConnected.niveauAcces);
          prefs.setString('idAccount', accountConnected.idAccount);
          prefs.setString('idPersonne', personConnected.idPersonne);
          prefs.setString('nomPersonne', personConnected.nom);
          prefs.setString('prenomPersonne', personConnected.prenom);
          prefs.setString('emailPersonne', personConnected.email);
          prefs.setString('profilPersonne', personConnected.profil);
          prefs.setString('zone', personConnected.adresse);
          prefs.setBool('isLoggedIn', true);

          setState(() {
            _isLogin = false;
            error(context, "Welcome back ${personConnected.sexe} ${personConnected.prenom} ${personConnected.nom}");
          });
          await Future.delayed(const Duration(seconds: 2));
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          setState(() {
            _isLogin = false;
            error(context, "Désolé ! Le numéro de téléphone et/ou le mot de passe est(sont) incorrect(s).");
          });
        }
      } else {
        setState(() {
          _isLogin = false;
          error(context, "Désolé ! Vérifier votre connexion internet.");
        });
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
    return Scaffold(
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
              color: Color.fromRGBO(53, 55, 88, 1),
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
                    "Bienvenue sur Trash Hunter",
                    style: TextStyle(fontSize: 17, color: Color.fromRGBO(147, 148, 184, 1), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.only(top: 22.5, right: 22.5, left: 22.5),
                    child: TextField(
                      controller: controllerLogin,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromRGBO(90, 90, 90, 1))),
                        icon: Icon(Icons.phone_iphone, color: Colors.white,),
                        contentPadding: EdgeInsets.all(11.25),
                        hintText: "Numéro de téléphone",
                        hintStyle: TextStyle(color: Colors.white,),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 22.5, right: 22.5, left: 22.5),
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
                        hintStyle: TextStyle(color: Colors.white,),
                      ),
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    margin: const EdgeInsets.only(top: 40, left: 30, right: 30),
                    child: TextButton.icon(
                      icon: _isLogin
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)
                          : const Icon(Icons.login, size: 20.0, color: Colors.white,),
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
                      onPressed: (){signInFunction(controllerLogin.text, controllerPass.text);},
                      label: Text(
                        _isLogin ? 'Patientez...' : "Se Connecter",
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    margin: const EdgeInsets.only(top: 20, right: 30, left: 30),
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
                      onPressed: (){error(context, "Veillez contacter votre administrateur local.");},
                      child: const Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 60),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          IconButton(icon: const Icon(Icons.add_reaction_outlined), onPressed: (){Navigator.of(context).pushReplacementNamed('/signup');}),
                          const Text(
                            "S'inscrire",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
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
}
