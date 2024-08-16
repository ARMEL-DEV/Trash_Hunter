import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import '../../models/application_model.dart';
import '../../models/gain_model.dart';
import '../tools/easy_loader.dart';
import 'category.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'quiz_options.dart';

class MonAbonnementPage extends StatefulWidget {
  const MonAbonnementPage({Key? key}) : super(key: key);
  @override
  _MonAbonnementPageState createState() => _MonAbonnementPageState();
}

class _MonAbonnementPageState extends State<MonAbonnementPage> {

  final List<Category> categories = [
    Category(1, "Basic", "300 Francs CFA pour 3 ramassages", icon: FontAwesomeIcons.atom),
    Category(2, "Premium", "500 Francs CFA pour 6 ramassages", icon: FontAwesomeIcons.apple),
    Category(3, "VIP", "1000 Francs CFA pour 10 ramassages", icon: FontAwesomeIcons.asterisk),
    Category(4, "Gold", "2000 Francs CFA pour 20 ramassages", icon: FontAwesomeIcons.archive),
  ];

  bool _isLoading = false;
  List<Gain> listGains = [];

  getAllGains() async {
    final urlListGains = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/gain/listAllGain.php");
    final responseListGains = await http.post(urlListGains);

    if(responseListGains.statusCode == 200) {
      final mapGains = json.decode(responseListGains.body);
      final allGains = mapGains["result"];
      if(allGains != "false") {
        for(var myGain in allGains) {
          Gain g = Gain(
              myGain['idGain'],
              myGain['idPersonne'],
              myGain['libelle'],
              myGain['description'],
              myGain['total'],
              myGain['dateAjout'],
              myGain['statut']
          );
          listGains.add(g);
        }
      }
    }
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;
    getAllGains();
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
      child: ! _isLoading ? const EasyLoader() : Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Mon abonnement'),
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context, 'refresh');
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipperTwo(),
                child: Container(
                  decoration: const BoxDecoration(color: primaryColor),
                  height: 200,
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: <Widget>[
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        "Choisir le type d'abonnement",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverGrid(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0),
                        delegate: SliverChildBuilderDelegate(
                          _buildCategoryItem,
                          childCount: listGains.length,
                        )),
                  ),
                ],
              ),
            ],
          )
        )
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return MaterialButton(
      elevation: 1.0,
      highlightElevation: 1.0,
      onPressed: () => _categoryPressed(context, listGains[index]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.grey.shade800,
      textColor: Colors.white70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (category.icon != null) Icon(category.icon),
          if (category.icon != null) const SizedBox(height: 5.0),
          Text(listGains[index].libelle, textAlign: TextAlign.center, maxLines: 3, style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 18),),
          Text(listGains[index].description, textAlign: TextAlign.center, maxLines: 3, style: const TextStyle(fontSize: 10),),
        ],
      ),
    );
  }

  _categoryPressed(BuildContext context, Gain gain) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          gain: gain,
        ),
        onClosing: () {},
      ),
    );
  }
}
