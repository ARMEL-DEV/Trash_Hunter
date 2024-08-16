import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trashhunters/models/programmeramassage_model.dart';
import 'package:http/http.dart' as http;
import 'package:trashhunters/pages/tools/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../tools/easy_loader.dart';

class ListProgrammeRamassage extends StatelessWidget{
  const ListProgrammeRamassage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const ListProgrammeRamassageList();
  }
}

class ListProgrammeRamassageList extends StatefulWidget {
  const ListProgrammeRamassageList({Key? key}) : super(key: key);

  _ListProgrammeRamassageListState createState() => _ListProgrammeRamassageListState();
}

class _ListProgrammeRamassageListState extends State<ListProgrammeRamassageList> {
  final TextStyle dropdownMenuItem = const TextStyle(color: Colors.black, fontSize: 18);

  String? idPersonneConnected = "0";
  String? zoneConnected = "";
  bool _isLoading = false;
  List<ProgrammeRamassage> listProgRam = [];
  List<ProgrammeRamassage> filterListProgRam = [];
  List<ProgrammeRamassage> tempFilterListProgRam = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController dateInput = TextEditingController();

  getAllProgrammeRamassage() async {
    final urlListProgRam = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/programmeRamassage/findRamassageByZone.php");
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
      for(ProgrammeRamassage enf in listProgRam){
        if(idPersonneConnected == enf.idPersonne){
          tempFilterListProgRam.add(enf);
        }
      }
      filterListProgRam = tempFilterListProgRam;
      _isLoading = true;
    });
  }

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idPersonne = prefs.getString('idPersonne').toString();
    String zone = prefs.getString('zone').toString();
    setState(() {
      idPersonneConnected = idPersonne;
      zoneConnected = zone;
    });
  }

  @override
  void initState() {
    dateInput.text = "";
    initValue();
    _isLoading = false;
    dateInput.addListener(_performSearch);
    getAllProgrammeRamassage();
    super.initState();
  }

  Future<void> _performSearch() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      filterListProgRam = tempFilterListProgRam
          .where((element) => element.dateProgrammation
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, 'refresh');
        return false;
      },
      child: ! _isLoading ? const EasyLoader() : Scaffold(
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
                      itemCount: filterListProgRam.length,
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
                          "Mes Ramassages",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        IconButton(
                          onPressed: () {  },
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
                              hintText: "Rechercher un programme",
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
      )
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      width: double.infinity,
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FloatingActionButton(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            mini: true,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('idProgramme', filterListProgRam[index].idProgramme);
              prefs.setString('zone', filterListProgRam[index].zone);
              Navigator.pushNamed(context, '/signalementListOrdures');
            },
            child: const Icon(Icons.remove_red_eye_outlined),
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  filterListProgRam[index].zone,
                  style: const TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.calendar_month, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text(filterListProgRam[index].dateProgrammation, style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
                  ],
                ),
                const SizedBox(height: 6,),
                Row(
                  children: <Widget>[
                    const Icon(Icons.access_time_rounded, color: thirdColor, size: 20,),
                    const SizedBox(width: 5,),
                    Text("Statut : ${filterListProgRam[index].statut}", style: const TextStyle(color: primary, fontSize: 13, letterSpacing: .3)),
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
