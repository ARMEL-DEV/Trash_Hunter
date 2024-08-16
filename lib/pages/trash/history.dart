import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashhunters/models/trash_model.dart';
import 'package:http/http.dart' as http;
import 'package:trashhunters/models/typetrash_model.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/easy_loader.dart';

class History extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return HistoryList();
  }
}

class HistoryList extends StatefulWidget {
  HistoryList({Key? key}) : super(key: key);

  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final TextStyle dropdownMenuItem = const TextStyle(color: Colors.black, fontSize: 18);

  String idPersonneConnected = "";
  String levelConnected = "";
  bool _isLoading = false;
  List<Trash_Model> listTrash = [];
  List<Trash_Model> filterListTrash = [];
  List<Trash_Model> tempFilterListTrash = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  getAllTrash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idPersonne = prefs.getString('idPersonne').toString();
    Uri urlListTrash;
    http.Response responseListTrash;
    if(levelConnected == "1" || levelConnected == "2"){
      urlListTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/listAllTrash.php");
      responseListTrash = await http.post(urlListTrash);
    } else {
      urlListTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/findTrashByPersonne.php");
      responseListTrash = await http.post(urlListTrash, body: {
        "idPersonne": idPersonne,
      });
    }

    if(responseListTrash.statusCode == 200) {
      final mapTrash = json.decode(responseListTrash.body);
      final allTrash = mapTrash["result"];
      if(allTrash != "false") {
        for(var myTrash in allTrash) {

          Future<String> stringFuture = getDetailsTypeTrash(myTrash['idType']);
          String libelleTypeTrash = await stringFuture;

          Trash_Model t = Trash_Model(
              myTrash['idTrash'],
              libelleTypeTrash,
              myTrash['idPersonne'],
              myTrash['gender'],
              myTrash['image'],
              myTrash['dateEnregistrement'],
              myTrash['statut']
          );
          listTrash.add(t);
        }
      }
    }
    setState(() {
      for(Trash_Model enf in listTrash){
        tempFilterListTrash.add(enf);
      }
      filterListTrash = tempFilterListTrash;
      _isLoading = true;
    });
  }

  Future<String> getDetailsTypeTrash(String idType) async {
    TypeTrash typeTrash = TypeTrash("", "", "");
    final urlDetailsTypeTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/typetrash/findTypeTrashByIdType.php");
    final responseDetailsTypeTrash = await http.post(urlDetailsTypeTrash, body: {
      "idType": idType,
    });

    if(responseDetailsTypeTrash.statusCode == 200) {
      final mapDetailsTypeTrash = json.decode(responseDetailsTypeTrash.body);
      final allDetailsTypeTrash = mapDetailsTypeTrash["result"];
      if(allDetailsTypeTrash != "false") {
        for(var detailsTypeTrash in allDetailsTypeTrash) {
          TypeTrash t = TypeTrash(
              detailsTypeTrash['idType'],
              detailsTypeTrash['libelle'],
              detailsTypeTrash['description']
          );
          typeTrash = TypeTrash(t.idType, t.libelle, t.description);
        }
      }
    }
    return typeTrash.libelle;
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idPersonne = prefs.getString('idPersonne').toString();
    String level = prefs.getString('level').toString();
    setState(() {
      idPersonneConnected = idPersonne;
      levelConnected = level;
    });
  }

  @override
  void initState() {
    super.initState();
    dateInput.text = "";
    _isLoading = false;
    dateInput.addListener(_performSearch);
    getAllTrash();
  }

  Future<void> _performSearch() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      filterListTrash = tempFilterListTrash
          .where((element) => element.dateEnregistrement
          .contains(dateInput.text))
          .toList();
    });
  }

  @override
  void dispose() {
    dateInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ! _isLoading ? const EasyLoader() : Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 145),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: filterListTrash.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildList(context, index);
                    }),
              ),
              Container(
                height: 140,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context, 'refresh');
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white,),
                      ),
                      const Text(
                        "Mes Ordures Signalées...",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      IconButton(
                        onPressed: () { Navigator.pushNamed(context, '/trash'); },
                        icon: const Icon(Icons.restore_from_trash, color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 110,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        controller: dateInput,
                        cursorColor: Theme.of(context).primaryColor,
                        style: dropdownMenuItem,
                        readOnly: true,
                        //onChanged: (value) { dateInput.text = value; },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime.now());

                          if (pickedDate != null) {
                            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                            setState(() {
                              dateInput.text = formattedDate; //set output date to TextField value.
                            });
                          } else {}
                        },
                        decoration: const InputDecoration(
                            hintText: "Rechercher une déclaration",
                            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
                            prefixIcon: Material(
                              elevation: 0.0,
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)),
                              child: Icon(Icons.calendar_month),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 3, color: thirdColor),
              image: DecorationImage(image: NetworkImage("https://trashhunter.dshcenter.com/images/ordures/${filterListTrash[index].image}"), fit: BoxFit.fill),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  filterListTrash[index].gender,
                  style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.calendar_month, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text(filterListTrash[index].dateEnregistrement, style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.restore_from_trash_outlined, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text("Déchet de type : ${filterListTrash[index].idType}", style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.access_time_rounded, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text("Statut : ${filterListTrash[index].statut}", style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
