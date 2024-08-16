import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:trashhunters/models/trash_model.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/easy_loader.dart';

class ListOrdures extends StatelessWidget{
  const ListOrdures({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ListOrduresList();
  }
}

class ListOrduresList extends StatefulWidget {
  const ListOrduresList({Key? key}) : super(key: key);

  _ListOrduresListState createState() => _ListOrduresListState();
}

class _ListOrduresListState extends State<ListOrduresList> {
  final TextStyle dropdownMenuItem = const TextStyle(color: Colors.black, fontSize: 18);

  String? codeDialog;
  String? valueText;
  final TextEditingController _textFieldController = TextEditingController();

  String? idPersonneConnected = "0";
  String? idProgramme = "";
  String zoneProgamme = "";
  bool _isLoading = false;
  bool _isInserting = false;
  List<Trash_Model> listOrdures = [];
  List<Trash_Model> filterListOrdures = [];
  List<Trash_Model> tempFilterListOrdures = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  getAllOrdures() async {
    final urlListOrdures = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/listAllTrashByAdressePersonne.php");
    final responseListOrdures = await http.post(urlListOrdures, body: {
      "adresse": zoneProgamme
    });

    if(responseListOrdures.statusCode == 200) {
      final mapOrdures = json.decode(responseListOrdures.body);
      final allOrdures = mapOrdures["result"];
      if(allOrdures != "false") {
        for(var myTrash in allOrdures) {
          Trash_Model p = Trash_Model(
              myTrash['idTrash'],
              myTrash['idType'],
              myTrash['idPersonne'],
              myTrash['gender'],
              myTrash['image'],
              myTrash['dateEnregistrement'],
              myTrash['statut']
          );
          String address = myTrash['adresse'];
          if(zoneProgamme.contains(address)) {
            listOrdures.add(p);
          }
        }
      }
    }
    setState(() {
      for(Trash_Model enf in listOrdures){
        //if(idPersonneConnected == enf.idPersonne){
          tempFilterListOrdures.add(enf);
        //}
      }
      filterListOrdures = tempFilterListOrdures;
      _isLoading = true;
    });
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idPersonne = prefs.getString('idPersonne').toString();
    String idProg = prefs.getString('idProgramme').toString();
    String zoneProg = prefs.getString('zone').toString();
    setState(() {
      idPersonneConnected = idPersonne;
      idProgramme = idProg;
      zoneProgamme = zoneProg;
    });
  }

  @override
  void initState() {
    initValue();
    dateInput.text = "";
    setState(() {
      _isInserting = false;
      _isLoading = false;
    });
    dateInput.addListener(_performSearch);
    getAllOrdures();
    super.initState();
  }

  Future<void> _performSearch() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      filterListOrdures = tempFilterListOrdures
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

  Future<void> _displayTextInputDialog(BuildContext context, String libelle, String idTrash) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(libelle),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration:
              const InputDecoration(hintText: "Saisir le poids"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('ANNULER'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context, 'refresh');
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: _isInserting
                        ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 1,)
                        : const Text('VALIDER'),
                onPressed: () async {
                  setState(() {
                    _isInserting = true;
                  });
                  DateTime dt = DateTime.now();
                  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
                  final urlAddRamassage = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/ramassage/addRamassage.php");
                  final responseAddRamassage = await http.post(urlAddRamassage, body: {
                    "idPersonne": idPersonneConnected,
                    "idProgramme": idProgramme,
                    "idTrash": idTrash,
                    "poids": valueText,
                    "dateRamassage": formattedDate
                  });
                  if (responseAddRamassage.statusCode == 200) {
                    final urlUpdateStatutTrash = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/trash/updateStatutTrash.php");
                    final responseUpdateStatutTrash = await http.post(urlUpdateStatutTrash, body: {
                      "idTrash": idTrash,
                      "statut": "TERMINE"
                    });
                    if (responseUpdateStatutTrash.statusCode == 200) {
                      setState(() {
                        _isInserting = false;
                        error(context, "Ramassage enregistré avec succès.");
                        Navigator.pop(context);
                        initValue();
                      });
                    }
                  }else {
                    setState(() {
                      _isInserting = false;
                      error(context, "Désolé! Impossible d'enregistrer ce ramassage.");
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          );
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
                    itemCount: filterListOrdures.length,
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
                      Text(
                        "Zone : $zoneProgamme",
                        style: const TextStyle(color: Colors.white, fontSize: 14,),
                      ),
                      /*IconButton(
                        onPressed: () {  },
                        icon: const Icon(Icons.restore_from_trash, color: Colors.white,
                        ),
                      ),*/
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
                            hintText: "Rechercher une ordure",
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
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () {
              _displayTextInputDialog(context, listOrdures[index].gender, listOrdures[index].idTrash);
            },
            child: const Icon(Icons.transfer_within_a_station),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  listOrdures[index].gender,
                  style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.calendar_month, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text(listOrdures[index].dateEnregistrement, style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
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
