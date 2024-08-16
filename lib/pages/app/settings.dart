import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/app/aboutus.dart';
import 'package:trashhunters/pages/autres/addcount.dart';
import 'package:trashhunters/pages/profile/editprofile.dart';
import 'package:trashhunters/pages/autres/help.dart';
import 'package:trashhunters/pages/profile/profil.dart';
import 'package:trashhunters/pages/tools/constant.dart';


class SettingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SettingsOnePage();
  }
}
class SettingsOnePage extends StatefulWidget {

  @override
  _SettingsOnePageState createState() => _SettingsOnePageState();
}

class _SettingsOnePageState extends State<SettingsOnePage> {
  String image = 'assets/images/profil.jpeg';
  late bool _dark;
  bool _isLoading = false;
  bool _isLogout = false;

  String? levelConnected = "0";
  String? numberConnected = "0";
  String? idAccountConnected = "0";
  String? idPersonneConnected = "0";
  String? nomConnected = "0";
  String? prenomConnected = "0";
  String? profilConnected = "0";

  /*Personne? personneConnected;
  Account? accountConnected;*/

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String level = prefs.getString('level').toString();
    String idAccount = prefs.getString('idAccount').toString();
    String idPersonne = prefs.getString('idPersonne').toString();
    String nomPersonne = prefs.getString('nomPersonne').toString();
    String prenomPersonne = prefs.getString('prenomPersonne').toString();
    String profilPersonne = prefs.getString('profilPersonne').toString();

    /*Personne? p = await UserFunctions().getDetailsPersonne(number);
    Account? a = await UserFunctions().getDetailsAccount(idAccount);*/

    setState(() {
      numberConnected = number;
      levelConnected = level;
      idAccountConnected = idAccount;
      idPersonneConnected = idPersonne;
      nomConnected = nomPersonne;
      prenomConnected = prenomPersonne;
      profilConnected = profilPersonne;
      //personneConnected = p;
      //accountConnected = a;
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _dark = false;
    _isLogout = false;
    _isLoading = false;
    initValue();
  }

  Brightness _getBrightness() {
    return _dark ? Brightness.dark : Brightness.light;
  }

  void signOut() async {
    setState(() {
      _isLogout = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('number');
    prefs.remove('level');
    prefs.remove('idAccount');
    prefs.remove('idPersonne');
    prefs.setBool('isLoggedIn', false);
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacementNamed('/signin');
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    setState(() {
      _isLogout = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 5,
          titleSpacing: 80,
          backgroundColor: Colors.grey.shade300,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          title: Text(
            'Paramètres',
            style: TextStyle(color: _dark ? Colors.white : Colors.black,fontSize: 16.0),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(FontAwesomeIcons.moon),
              onPressed: () {
                setState(() {
                  _dark = !_dark;
                });
              },
            )
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30.0),
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    color: primaryColor,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(
                            builder: (BuildContext context) => EditProfilePage()));//open edit profile
                      },
                      title: Text("$prenomConnected $nomConnected", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500,),),
                      leading: CircleAvatar(backgroundImage: AssetImage ('assets/images/$profilConnected'),),
                      trailing: const Icon(Icons.edit, color: Colors.white,),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.person, color: Colors.black54,),
                          title: const Text("Mon profil"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (BuildContext context) => ProfilePage()));//open change password
                          },
                        ),
                        _buildDivider(),
                        /*ListTile(
                          leading: const Icon(Icons.people_alt_outlined, color: Colors.black54,),
                          title: const Text("Gestion des comptes"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (BuildContext context) => AccountList()));//open change language
                          },
                        ),
                        _buildDivider(),*/
                        ListTile(
                          leading: const Icon(Icons.account_balance_wallet_outlined, color: Colors.black54,),
                          title: const Text("Mon abonnement"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (BuildContext context) => CountPage()));//open change password
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(Icons.info_outline, color: Colors.black54,),
                          title: const Text("Aide"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (BuildContext context) => AidePage()));//open change language
                          },
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(Icons.account_balance_outlined, color: Colors.black54,),
                          title: const Text("A Propos"),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(
                                builder: (BuildContext context) => AproposPage()));//open change location
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
            Positioned(
              bottom: 167,
              left: 160,
              child: Container(
                width: 70,
                height: 70,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle,),
              ),
            ),
            Positioned(
              bottom: 180,
              left: 170,
              child: IconButton(
                icon: _isLogout
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 3,)
                    : const Icon(FontAwesomeIcons.powerOff, color: Colors.white,),
                onPressed: () async {
                  signOut();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}