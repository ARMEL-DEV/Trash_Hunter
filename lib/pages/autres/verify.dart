import 'dart:convert';
import '../../models/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:trashhunters/pages/autres/phone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_sms/flutter_sms.dart';
import '../tools/easy_loader.dart';
import 'package:flutter/services.dart';

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLogin = false;
  bool _isLoading = false;
  String? nomPerson;
  String? prenomPerson;
  String? contactPerson;
  String? passwordPerson;
  List<String> recipents = ["698813857"];

  initValue() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+237698813857',
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        MyPhone.verify = verificationId;
        //Navigator.pushNamed(context, '/verify');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String nom = prefs.getString('nom').toString();
    String prenom = prefs.getString('prenom').toString();
    String contact = prefs.getString('contact').toString();
    String motdepasse = prefs.getString('motdepasse').toString();

    setState(() {
      nomPerson = nom;
      prenomPerson = prenom;
      contactPerson = contact;
      passwordPerson = motdepasse;
      _isLoading = true;
    });
  }

  static const platform = const MethodChannel('sendSms');

  Future<Null> sendSms()async {
    print("SendSMS");
    try {
      final String result = await platform.invokeMethod('send',<String,dynamic>{"phone":"+237$contactPerson","msg":"Hello! I'm sent programatically."}); //Replace a 'X' with 10 digit phone number
      print(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  void _sendMySMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  Future<void> _sendSMS(List<String> recipients) async {
    try {
      String _result = await sendSMS(
        message: "TEST ENVOIE MESSAGE!!!",
        recipients: recipients,
        sendDirect: true,
      );
      print(_result);
      error(context, "MESSAGE ENVOYE AVEC SUCCES.");
    } catch (errors) {
      print(errors);
      error(context, "ECHEC D'ENVOI DU MESSAGE.");
    }
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    initValue();
  }

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code ="";

    return ! _isLoading ? const EasyLoader() : Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/img1.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 25,),
              const Text(
                "Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Veillez entrer le code de vérification que vous avez reçu par sms!",
                style: TextStyle(fontSize: 16,),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30,),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
                onChanged: (value) { code = value; },
                //onCompleted: (pin) => print(pin),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: TextButton.icon(
                    icon: _isLogin
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)
                        : const Icon(Icons.verified_user_outlined, size: 20.0, color: Colors.white,),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      print("ENTREEEE VERIFICATION!!!!");
                      setState(() {
                        _isLogin = true;
                      });
                      try{
                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: MyPhone.verify, smsCode: code);
                        await auth.signInWithCredential(credential);

                        final urlAddAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/addAccount.php");
                        final responseAddAccount = await http.post(urlAddAccount, body: {
                          "nom": nomPerson,
                          "prenom": prenomPerson,
                          "contact": contactPerson
                        });

                        String idPerson = "";

                        if (responseAddAccount.statusCode == 200) {
                          print("COMPTE AJOUTE!!!");
                          final findIdAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/findPersonneByNomPrenom.php");
                          final responsePerson = await http.post(findIdAccount, body: {
                            "nom": nomPerson,
                            "prenom": prenomPerson
                          });

                          if(responsePerson.statusCode == 200) {
                            print("PERSONNE TROUVE!!!!!");
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
                              "login": contactPerson,
                              "motdepasse": passwordPerson
                            });
                            if (responseAddCompte.statusCode == 200) {
                              print("ACCOUNT AJOUTE!!!! -> $contactPerson -> $passwordPerson");
                              final urlGetCompte = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/account/findAccountByLoginPassword.php");
                              final responseGetCompte = await http.post(urlGetCompte, body: {
                                "login": contactPerson,
                                "password": passwordPerson,
                              });
                              if (responseGetCompte.statusCode == 200) {
                                print("ACCOUNT TROUVE!!! -> ${responseGetCompte.statusCode}");
                                final mapFindAccount = json.decode(responseGetCompte.body);
                                print("MAPPING -> $mapFindAccount");
                                final infoAccount = mapFindAccount["result"];
                                print("REPONSE : $infoAccount");
                                late Account monCompte;
                                if(infoAccount != "false") {
                                  for(var user in infoAccount) {
                                    Account a = Account(
                                        user['idAccount'],
                                        user['idApp'],
                                        user['idPersonne'],
                                        user['login'],
                                        user['password'],
                                        user['niveauAcces'],
                                        user['statut']
                                    );
                                    monCompte = a;
                                  }
                                  print("MONCOMPTE : ${monCompte.login}");
                                  error(context, "Inscription effectué avec succès.");
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('number', contactPerson!);
                                  prefs.setString('level', "3");
                                  prefs.setString('idAccount', "${monCompte.idAccount}");
                                  prefs.setString('idPersonne', idPerson);
                                  prefs.setBool('isLoggedIn', true);
                                  Navigator.of(context).pushReplacementNamed('/home');
                                }
                              }
                            }
                          }
                        }
                        //Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                      }catch(e){}
                    },
                    label: Text(_isLogin ? 'Patientez...' : "Verifier mon numéro",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        //Navigator.pushNamedAndRemoveUntil(context, '/phone', (route) => false,);
                      },
                      child: const Text(
                        "Modifier le numéro",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}