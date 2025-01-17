import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:trashhunters/pages/home.dart';
import '../tools/constant.dart';
import 'question.dart';

class CheckAnswersPage extends StatelessWidget {
  final List<Question> questions;
  final Map<int, dynamic> answers;

  const CheckAnswersPage(
      {Key? key, required this.questions, required this.answers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Récapitulatif'),
          elevation: 0,leading: IconButton(
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
            ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: questions.length + 1,
              itemBuilder: _buildItem,
            )
          ],
        ),

    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index == questions.length) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: primaryColor.withOpacity(0.8),
          foregroundColor: Colors.white,
        ),
        child: const Text("Envoyer"),
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) =>  HomePage()));
        },
      );
    }
    Question question = questions[index];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.question!,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              "${answers[index]}",
              style: const TextStyle(
                  color: thirdColor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5.0),

          ],
        ),
      ),
    );
  }
/*
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
 */
}
