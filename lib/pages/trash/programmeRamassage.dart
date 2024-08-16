import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/models/programmeramassage_model.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:trashhunters/pages/tools/easy_loader.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../abonnement/abonnement.dart';

class ProgrammeRamassagePage extends StatefulWidget {
  const ProgrammeRamassagePage({Key? key}) : super(key: key);
  @override
  _ProgrammeRamassagePageState createState() => _ProgrammeRamassagePageState();
}

class _ProgrammeRamassagePageState extends State<ProgrammeRamassagePage> {

  String zoneConnected = "";
  String totalRamassage = "0";
  bool _isLoading = false;
  List<ProgrammeRamassage> listProgRam = [];

  getAllProgrammeRamassage() async {
    final urlListProgRam = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/programmeRamassage/listAllProgrammeRamassage.php");
    final responseListProgRam = await http.post(urlListProgRam, body: {
      "zone": zoneConnected
    });

    if(responseListProgRam.statusCode == 200) {
      final mapProgRam = json.decode(responseListProgRam.body);
      final allProgRam = mapProgRam["result"];
      if(allProgRam != "false") {
        for(var myProgRam in allProgRam) {
          ProgrammeRamassage p = ProgrammeRamassage(
              myProgRam['idProgramme'],
              myProgRam['idPersonne'],
              myProgRam['zone'],
              myProgRam['dateProgrammation'],
              myProgRam['statut']
          );
          listProgRam.add(p);
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
    String zone = prefs.getString('zone').toString();
    String total = prefs.getString('totalRamassage').toString();
    setState(() {
      zoneConnected = zone;
      totalRamassage = total;
    });
  }

  @override
  void initState() {
    initValue();
    super.initState();
    _isLoading = false;
    getAllProgrammeRamassage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ! _isLoading ? const EasyLoader() : Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Programme de ramassage",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),textAlign: TextAlign.center,),
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: HeaderFooterwidget(
        header: _buildDateHeader(DateTime.now()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 25),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: listProgRam.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildTask(context, index);
                    }),
              ),
              /*_buildTask(color: thirdColor),
              const SizedBox(height: 20.0),
              _buildTaskTwo(),
              const SizedBox(height: 20.0),
              _buildTask(color: secondary),
              const SizedBox(height: 20.0),
              _buildTaskTwo(),*/
            ],
          ),
        ),
        footer: _buildBottomBar(),
      ),
    );
  }

  Container _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 5.0),
          const Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Nouvelle déclaration d'ordure",
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
          ),
          SizedBox.fromSize(
            size: const Size(56, 56),
            child: ClipOval(
              child: Material(
                color: Colors.amberAccent,
                child: InkWell(
                  splashColor: Colors.green,
                  onTap: () {
                    if(totalRamassage.compareTo("0")==0){
                      _displayTextInputDialog(context, "Total Déclaration restant : $totalRamassage" , "Désolé ! Vous ne disposez plus assez de crédit pour déclarer des ordures. Veillez mettre à jour votre Abonnement");
                    }else {
                      Navigator.pushNamed(context, '/trash');
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Icon(Icons.restore_from_trash_outlined),
                      Text("New"),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    const TextStyle boldStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 2.0);
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: MaterialButton(
            minWidth: 0,
            elevation: 0,
            highlightElevation: 0,
            textColor: thirdColor,
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 8.0,
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(DateFormat.MMM().format(date).toUpperCase()),
                const SizedBox(height: 5.0),
                Text(
                  DateFormat.d().format(date),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              DateFormat.EEEE().format(date).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            Container(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                minWidth: 200.0,
                maxWidth: 200.0,
                minHeight: 50.0,
                maxHeight: 150.0,
              ),
              child: AutoSizeText(
                zoneConnected.toUpperCase(),
                style: boldStyle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container _buildTask(BuildContext context, int index) {
    List listColor = [thirdColor, colorWhite];

    DateTime dateFormat = DateTime.parse(listProgRam[index].dateProgrammation);
    String date = DateFormat('dd-MM-yyyy').format(dateFormat);
    String time = DateFormat.Hms().format(dateFormat).toString();

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        color: index.isEven ? listColor[0] : listColor[1],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(listProgRam[index].zone,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: primaryColor),
          ),
          const SizedBox(height: 5.0),
          Text("Le $date à $time",
            style: const TextStyle(letterSpacing: 1.5, color: primaryColor),
          ),
          //const SizedBox(height: 5.0),
          //Text(listProgRam[index].idPersonne),
          const SizedBox(height: 5.0),
          Text("STATUT : ${listProgRam[index].statut}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0, color: primaryColor)
          ),
          const SizedBox(height: 5.0),
          const Divider(color: thirdColor,),
        ],
      ),
    );
  }
}

class HeaderFooterwidget extends StatelessWidget {
  final Widget? header;
  final Widget? footer;
  final Widget? body;
  final Color headerColor;
  final Color footerColor;
  final double? headerHeight;

  const HeaderFooterwidget(
      {Key? key,
        this.header,
        this.footer,
        this.body,
        this.headerColor = primaryColor,
        this.footerColor = secondary,
        this.headerHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Stack _buildBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 20,
          bottom: 120,
          right: 0,
          width: 30,
          child: DecoratedBox(
            decoration: BoxDecoration(color: headerColor),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 120,
          child: DecoratedBox(
            decoration: BoxDecoration(color: footerColor),
          ),
        ),
        Positioned(
          bottom: 100,
          right: 0,
          width: 10,
          height: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: headerColor,
                borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20.0))),
          ),
        ),
        Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: body,
              ),
            ),
            const SizedBox(height: 10.0),
            if (footer != null) footer!,
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: headerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30.0)),
        color: headerColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: header,
    );
  }
}
