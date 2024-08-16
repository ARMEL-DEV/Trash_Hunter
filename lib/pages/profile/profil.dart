import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import '../../functions/UserFunctions.dart';
import '../../models/account_model.dart';
import '../../models/personne_model.dart';
import '../tools/easy_loader.dart';
import 'editAvatar.dart';
import 'editPassword.dart';
import 'editprofile.dart';
import 'expandableTab.dart';

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProfilesOnePage();
  }
}
class ProfilesOnePage extends StatefulWidget {

  @override
  _ProfilesOnePageState createState() => _ProfilesOnePageState();
}

class _ProfilesOnePageState extends State<ProfilesOnePage> {
  bool _isLoading = false;

  String? levelConnected = "0";
  String? numberConnected = "0";
  String? idAccountConnected = "0";
  String? idPersonneConnected = "0";

  Personne? personneConnected;
  Account? accountConnected;

  initValue() async {
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

  @override
  Widget build(BuildContext context){
    return ! _isLoading ? const EasyLoader() : Scaffold(
      backgroundColor: Colors.grey.shade300,
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            //onPressed: () => _showAction(context, 0),
            onPressed: () async {
              String refresh = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => EditProfilePage()));
              if(refresh == 'refresh'){
                _isLoading = true;
                initValue();
              }
            },
            icon: const Icon(Icons.edit_note),
          ),
          ActionButton(
            onPressed: () async {
              String refresh = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => EditAvatarPage()));
              if(refresh == 'refresh'){
                _isLoading = true;
                initValue();
              }
            },
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () async {
              String refresh = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) => EditPasswordPage()));
              if(refresh == 'refresh'){
                _isLoading = true;
                initValue();
              }
            },
            icon: const Icon(Icons.settings_power),
          ),
        ],
      ),
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
                  Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(top: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(left: 96.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${personneConnected?.nom} ${personneConnected?.prenom}", style: Theme.of(context).textTheme.headline6?.apply(color: primaryColor),),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Text(
                                        accountConnected?.niveauAcces=="1"
                                        ? "ADMINISTRATEUR"
                                        : accountConnected?.niveauAcces=="2"
                                        ? "RAMASSEUR"
                                        : "CLIENT",
                                        style: const TextStyle(color: Colors.black ),),
                                    //subtitle: const Text("parentez",style: TextStyle(color: Colors.black ),),
                                  ),
                                ],
                              ),
                            ),
                            /*const SizedBox(height: 10.0),
                            Row(
                              children: <Widget>[
                                Expanded(child: Column(
                                  children: const <Widget>[
                                    Text("25",style: TextStyle(color: Colors.black ),),
                                    Text("Trash",style: TextStyle(color: Colors.black ),)
                                  ],
                                ),),
                                Expanded(child: Column(
                                  children: const <Widget>[
                                    Text("500",style: TextStyle(color: Colors.black ),),
                                    Text("Comments",style: TextStyle(color: Colors.black ),)
                                  ],
                                ),),
                                Expanded(child: Column(
                                  children: const <Widget>[
                                    Text("50",style: TextStyle(color: Colors.black ),),
                                    Text("Subscription",style: TextStyle(color: Colors.black ),)
                                  ],
                                ),),
                              ],
                            ),*/
                          ],
                        ),
                      ),
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                                //image: AssetImage('assets/images/${personneConnected?.profil}'),
                                image: NetworkImage("https://trashhunter.dshcenter.com/images/profil/${personneConnected?.profil}"),
                                fit: BoxFit.cover
                            )
                        ),
                        margin: const EdgeInsets.only(left: 16.0),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        const ListTile(title: Text("Informations Personnelles",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold ),),),
                        const Divider(),
                        ListTile(
                          title: const Text("Email",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),),
                          subtitle: Text("${personneConnected?.email}",style: const TextStyle(color: primaryColor ),),
                          leading: const Icon(Icons.email, color: primaryColor),
                        ),
                        ListTile(
                          title: const Text("Telephone",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),),
                          subtitle: Text("+237 ${personneConnected?.contact}",style: const TextStyle(color: primaryColor ),),
                          leading: const Icon(Icons.phone, color: primaryColor),
                        ),
                        ListTile(
                          title: const Text("Adresse de résidence",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),),
                          subtitle: Text("${personneConnected?.adresse}",style: const TextStyle(color: primaryColor ),),
                          leading: const Icon(Icons.pin_drop, color: primaryColor),
                        ),
                        ListTile(
                          title: const Text("Identifiant",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),),
                          subtitle: Text("${accountConnected?.login}",style: const TextStyle(color: primaryColor ),),
                          leading: const Icon(Icons.person, color: primaryColor),
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
}