import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trashhunters/assets/src/config.dart';
import 'package:trashhunters/pages/ramassage/check_answers.dart';
import '../../models/programmeramassage_model.dart';
import 'question.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class RamassagesPage extends StatefulWidget{
  const RamassagesPage({Key? key}) : super(key: key);

  @override
  _RamassagesPageState createState() => _RamassagesPageState();
}

class _RamassagesPageState extends State<RamassagesPage> {
  final TextStyle _questionStyle = const TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.w500, color: Colors.white);

  bool _isLoading = false;
  String zone = "Bepanda";
  List<ProgrammeRamassage> listProgRam = [];

  int _currentIndex = 0;
  final Map<int, dynamic> _answers = {};

  final List<Question> questions = Question.fromData([
    {
      "question": "Quelle ordure voulez-vous ramasser ?",
      "incorrect_answers": ["Music Player", "Multi Pass", "Micro Point"]
    },
    {
      "question": "Pour quel programme de ramassage d'ordures ?",
      "incorrect_answers": ["Central Processing Unit", "Hard Disk Drive", "Random Access Memory"]
    },
    {
      "question": "Quel est le poids de l'ordure ?",
      "incorrect_answers": ["1", "2", "64"]
    },
  ]);

  getAllProgrammeRamassage() async {
    final urlListProgRam = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/programmeRamassage/findRamassageByZone.php");
    final responseListProgRam = await http.post(urlListProgRam, body: {
      "zone": zone
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

  @override
  Widget build(BuildContext context) {
    Question question = questions[_currentIndex];
    final List<dynamic> options = question.incorrectAnswers!;

    return WillPopScope(
      onWillPop: _onWillPop as Future<bool> Function()?,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text("Enregistrer un Ramassage"),
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
                decoration: BoxDecoration(
                  color: primaryColor,
                ),
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        child: Text("${_currentIndex + 1}"),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          questions[_currentIndex].question!,
                          softWrap: true,
                          style: _questionStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ...options.map((option) => RadioListTile(
                              title: Text("$option"),
                              groupValue: _answers[_currentIndex],
                              value: option!,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _answers[_currentIndex] = option;
                                });
                              },
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _nextSubmit,
                        child: Text(
                            _currentIndex == (questions.length - 1)
                                ? "Récapitulatif"
                                : "Suivant"),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _nextSubmit() {
    if (_answers[_currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Vous devez sélectionner une réponse pour continuer."),
      ));
      return;
    }
    if (_currentIndex < (questions.length - 1)) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => CheckAnswersPage(
              questions: questions, answers: _answers)));
    }
  }

  Future<bool?> _onWillPop() async {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: const Text(
                "Êtes-vous sûr de vouloir quitter ? Tous vos progrès seront perdus."),
            title: const Text("Attention!"),
            actions: <Widget>[
              TextButton(
                child: const Text("Oui"),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
              TextButton(
                child: const Text("Non"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
            ],
          );
        });
  }
}
