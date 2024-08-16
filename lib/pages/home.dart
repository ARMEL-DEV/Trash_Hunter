import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/assets/oval-right-clipper.dart';
import 'package:trashhunters/functions/UserFunctions.dart';
import 'package:trashhunters/models/account_model.dart';
import 'package:trashhunters/models/news_model.dart';
import 'package:trashhunters/models/personne_model.dart';
import 'package:trashhunters/pages/profile/profil.dart';
import 'package:trashhunters/pages/ramassage/signalement_programmes.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:trashhunters/pages/autres/detailpost.dart';
import 'package:trashhunters/pages/tools/easy_loader.dart';
import 'package:trashhunters/pages/trash/history.dart';
import 'package:trashhunters/pages/trash/programmeRamassage.dart';
import 'package:trashhunters/pages/trash/trash.dart';

import '../models/application_model.dart';
import '../models/coupon_model.dart';
import 'abonnement/abonnement.dart';
import 'app/aboutus.dart';
import 'autres/help.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Home();
  }
}
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextStyle whiteText = const TextStyle(color: Colors.white);

  bool _isLoading = false;
  bool _isLogout = false;

  String? totalRammassage = "0";

  String? levelConnected = "0";
  String? numberConnected = "0";
  String? idAccountConnected = "0";
  String? idPersonneConnected = "0";
  Personne? personneConnected;
  Account? accountConnected;

  var titleTextStyle;
  List<News> listNews = [];
  List<Application> monApplication = [];

  getInfoApplication() async {
    final urlInfoApp = Uri.parse("https://trashhunter.dshcenter.com/api/application/listAllApplication.php");
    final responseInfoApp = await http.post(urlInfoApp);

    if(responseInfoApp.statusCode == 200) {
      final mapInfoApp = json.decode(responseInfoApp.body);
      final resultInfoApp = mapInfoApp["result"];
      if(resultInfoApp != "false") {
        for(var infoApp in resultInfoApp) {
          Application app = Application(
              infoApp['idApp'],
              infoApp['name'],
              infoApp['description'],
              infoApp['contactOrange'],
              infoApp['contactMtn'],
              infoApp['logo'],
              infoApp['version']
          );
          monApplication.add(app);
        }
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('contactOrange', monApplication[0].contactOrange);
    prefs.setString('contactMtn', monApplication[0].contactMtn);
    setState(() {
      _isLoading = true;
    });
  }

  getAllNews() async {
    DateTime dt = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    final urlListNews = Uri.parse("https://trashhunter.dshcenter.com/api/news/findNewsByTime.php");
    final responseListNews = await http.post(urlListNews, body: {
      "time": formattedDate
    });

    if(responseListNews.statusCode == 200) {
      final mapNews = json.decode(responseListNews.body);
      final allNews = mapNews["result"];
      if(allNews != "false") {
        for(var myNews in allNews) {
          News n = News(
              myNews['idNew'],
              myNews['idPersonne'],
              myNews['libelle'],
              myNews['description'],
              myNews['time'],
              myNews['image'],
              myNews['statut']
          );
          listNews.add(n);
        }
      }
    }
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context, String titre, String libelle) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          content: Text(libelle),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: const Text('ANNULER'),
              onPressed: () { Navigator.pop(context); },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('METTRE A JOUR'),
              onPressed: () {
                Navigator.pop(context);
                setState(() async {
                  String refresh = await Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) => MonAbonnementPage()));
                  if (refresh == 'refresh') {
                    _isLoading = true;
                    initValue();
                  }
                });
              },
            ),
          ],
        );
      });
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number').toString();
    String level = prefs.getString('level').toString();
    String idAccount = prefs.getString('idAccount').toString();
    String idPersonne = prefs.getString('idPersonne').toString();

    Personne? p = await UserFunctions().getDetailsPersonne(number);
    Account? a = await UserFunctions().getDetailsAccount(idAccount);
    Coupon? monCoupon = await UserFunctions().getResteRamassagePersonne(idPersonne);

    setState(() {
      totalRammassage = monCoupon.reste;
      numberConnected = number;
      levelConnected = level;
      idAccountConnected = idAccount;
      idPersonneConnected = idPersonne;
      personneConnected = p;
      accountConnected = a;
      _isLoading = true;
    });
    prefs.setString('totalRammassage', monCoupon.reste);
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    _isLogout = false;
    initValue();
    getAllNews();
    getInfoApplication();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ! _isLoading ? const EasyLoader() : Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        backgroundColor: primaryColor,
        toolbarHeight: 70,
        //automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 35,),
          onPressed: () {
            _key.currentState?.openDrawer();
          },
        ),
        //actions: <Widget>[_buildAvatar(context, "${personneConnected?.profil}")],
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                image: const DecorationImage(image: AssetImage('assets/collecte.png'), fit: BoxFit.fill),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(totalRammassage!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 40),)),
            ),
          )
        ],
      ),

      drawer: _buildDrawer(context),
      body: ListView(
        //padding: const EdgeInsets.all(5.0),
        //child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              child:_buildTitledContainer("Mes Pourcentages", child: Container(height: 190, child: DonutPieChart.withSampleData())),
            ),
            const SizedBox(height: 10.0),
            InkWell(child:_buildTitledContainer("Actualités",),),
            SizedBox(
              height: 300,
              child: ListView.builder(
                  //padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: listNews.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildRooms(context, index);
                  }),
            ),
            //const SizedBox(height: 10.0),
          ],
        //),
      ),
    );
  }

  Widget _buildRooms(BuildContext context, int index) {
    DateTime dt1 = DateTime.now();
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(dt1);
    DateTime dt2 = DateTime.parse(listNews[index].time);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(dt2);
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          child: InkWell(
            onTap:(){
              //print("card one is tapped");
              Navigator.push(context,MaterialPageRoute(
              builder: (BuildContext context) => const PostPage()));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.asset("assets/images/${listNews[index].image}"),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(Icons.star, color: Colors.grey.shade800, size: 20.0,),
                    ),
                    const Positioned(
                      right: 8,
                      top: 8,
                      child: Icon(Icons.star_border, color: Colors.white, size: 24.0,),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 10.0,
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.white,
                        child: Text(
                          (formattedDate1 == formattedDate2) ? "LIVE" : "BIENTOT",
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        listNews[index].libelle,
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5.0,),
                      Text(listNews[index].description),
                      const SizedBox(height: 10.0,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            (formattedDate1 == formattedDate2)
                                ? "Aujourd'hui, ${DateFormat.Hm().format(dt2).toString()}"
                                : "A venir, le ${DateFormat.d().format(dt2)} ${DateFormat.MMM().format(dt2)} à ${DateFormat.Hm().format(dt2).toString()}",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    DateTime dt1 = DateTime.now();
    String formattedDate1 = DateFormat('yyyy-MM-dd').format(dt1);
    DateTime dt2 = DateTime.parse(listNews[index].time);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(dt2);
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap:(){
            //print("card one is tapped");
            Navigator.push(context,MaterialPageRoute(
                builder: (BuildContext context) => const PostPage()));
          },
          child: Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          image: DecorationImage(
                            image: AssetImage ("assets/images/${listNews[index].image}"),
                            fit: BoxFit.cover,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        listNews[index].description,
                        style: titleTextStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            (formattedDate1 == formattedDate2)
                                ? "Aujourd'hui, ${DateFormat.Hm().format(dt2).toString()}"
                                : "A venir, le ${DateFormat.d().format(dt2)} ${DateFormat.MMM().format(dt2)} à ${DateFormat.Hm().format(dt2).toString()}",
                            style: const TextStyle(color: Colors.grey, fontSize: 14.0,),
                          ),
                          const Spacer(),
                          Text(
                            listNews[index].libelle,
                            style: const TextStyle(color: Colors.grey, fontSize: 14.0,),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
                Positioned(
                  top: 190,
                  left: 20.0,
                  child: Container(
                    color: (formattedDate1 == formattedDate2) ? primaryColor : secondary,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                        (formattedDate1 == formattedDate2) ? "LIVE" : "BIENTOT",
                        style: const TextStyle(color: Colors.white, fontSize: 12.0,)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  Container _buildTile(
      {required Color color, required IconData icon, required String title, required String data}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(icon, color: Colors.white,),
          Text(title, style: whiteText.copyWith(fontWeight: FontWeight.bold),),
          Text(data, style: whiteText.copyWith(fontWeight: FontWeight.bold, fontSize: 20.0),),
        ],
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: const BoxDecoration(
              color: colorWhite, boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: _isLogout
                          ? const CircularProgressIndicator(color: primaryColor, strokeWidth: 3,)
                          : const Icon(Icons.power_settings_new, color: primaryColor,),
                      onPressed: () async {
                        signOut();
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [fourColor, thirdColor])),
                    //child: CircleAvatar(radius: 40, backgroundImage: AssetImage ('assets/images/${personneConnected?.profil}'),),
                    child: CircleAvatar(radius: 40,
                      backgroundImage: NetworkImage("https://trashhunter.dshcenter.com/images/profil/${personneConnected?.profil}"),),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    "${personneConnected?.nom} ${personneConnected?.prenom}",
                    style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Text(
                    accountConnected?.niveauAcces=="1"
                    ? "ADMINISTRATEUR"
                      : accountConnected?.niveauAcces=="2"
                      ? "RAMASSEUR"
                      : "CLIENT",
                    style: const TextStyle(color: active, fontSize: 16.0),
                  ),
                  const SizedBox(height: 30.0),
                  //_buildRow(context, '/home', Icons.home, "Accueil",true),
                  //_buildDivider(),
                  accountConnected?.niveauAcces=="1" ? _buildRow(context, ListProgrammeRamassage(), "ramassage", Icons.shopping_cart_checkout, "Effectuer un ramassage") :
                  accountConnected?.niveauAcces=="2" ? _buildRow(context, ListProgrammeRamassage(), "ramassage", Icons.shopping_cart_checkout, "Effectuer un ramassage") : _buildDivider(),
                  _buildRow(context, Trash(), "declaration", Icons.restore_from_trash_rounded, "Singaler des Ordures"),
                  //_buildDivider(),
                  _buildRow(context, History(), "listing", Icons.restore_from_trash_outlined, "Historiques des ordures"),
                  //_buildDivider(),
                  _buildRow(context, ProgrammeRamassagePage(), "programme", Icons.chrome_reader_mode, "Programme de ramassage"),
                  _buildDivider(),
                  _buildRow(context, MonAbonnementPage(), "abonnement", Icons.price_check, "Mon Abonnement"),
                  //_buildDivider(),
                  //_buildRow(context, '/chat', Icons.chat_rounded, "Messagerie",true),
                  //_buildDivider(),
                  _buildRow(context, ProfilePage(), "profil", Icons.person_pin_outlined, "Mon profil"),
                  _buildDivider(),
                  _buildRow(context, AproposPage(), "apropos", Icons.email, "A Propos"),
                  //_buildDivider(),
                  _buildRow(context, AidePage(), "aide", Icons.info_outline, "Aide"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      color: active,
    );
  }

  Widget _buildRow(BuildContext context, Widget page, String nomPage, IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        children: <Widget> [
        Icon(icon, color: thirdColor,),
        const SizedBox(width: 10.0),
        TextButton(
          child: Text(title,style: const TextStyle(color: Colors.black87)),
          onPressed: () async {
            Navigator.of(context).pop();
            if((totalRammassage?.compareTo("0")==0) && (nomPage.compareTo("declaration")==0)){
              _displayTextInputDialog(context, "Total Déclaration restant : $totalRammassage" , "Désolé ! Vous ne disposez plus assez de crédit pour déclarer des ordures. Veillez mettre à jour votre Abonnement");
            }else {
              String refresh = await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) => page));
              if (refresh == 'refresh') {
                _isLoading = true;
                initValue();
              }
            }
          },
        ),
      ]),
    );
  }
}
Widget _buildAvatar(BuildContext context, String avatar) {
  //final String image = images[1];
  return IconButton(
    iconSize: 40,
    padding: const EdgeInsets.all(0),
    icon: CircleAvatar(
      backgroundColor: Colors.grey.shade300,
      child: CircleAvatar(radius: 18, backgroundImage: NetworkImage("https://trashhunter.dshcenter.com/images/profil/$avatar")),
    ),
    onPressed: () {},
  );
}
class DonutPieChart extends StatelessWidget {
  final List<PieChartSectionData> seriesList;

  const DonutPieChart(this.seriesList, {super.key});

  /// Creates a [PieChart] with sample data and no transition.
  factory DonutPieChart.withSampleData() {
    return DonutPieChart(
      _createSampleData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40.0,
        sectionsSpace: 10.0,
        sections: seriesList,
      ),
      swapAnimationDuration: const Duration(milliseconds: 150),
      swapAnimationCurve: Curves.linear,
    );
  }

  /// Create one series with sample hard coded data.
  static List<PieChartSectionData> _createSampleData() {
    final data = [
      PieChartSectionData(
        value: 100,
        title: "Organique",
        color: Colors.grey,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        title: "Metal",
        value: 75,
        color: Colors.deepOrange,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1.5,
      ),
      PieChartSectionData(
        title: "Verre",
        value: 25,
        color: Colors.green,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset: 1.3,
      ),
      PieChartSectionData(
        title: "Plastique",
        value: 30,
        color: Colors.yellow,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset:1.7,
      ),
      PieChartSectionData(
        title: "Papier",
        value: 20,
        color: Colors.blue,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        titlePositionPercentageOffset:1.7,
      ),
    ];

    return data;
  }
}

/// Sample linear data type.
class LinearSales {
  final String month;
  final int sales;

  LinearSales(this.month, this.sales);
}

Container _buildTitledContainer(String title,
    {Widget? child, double? height}) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    width: double.infinity,
    height: height,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.white70,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
        ),
        if (child != null) ...[const SizedBox(height: 10.0), child]
      ],
    ),

  );
}