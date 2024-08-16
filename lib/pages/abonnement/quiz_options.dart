import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trashhunters/pages/tools/constant.dart';
import '../../models/gain_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class QuizOptionsDialog extends StatefulWidget {
  final Gain? gain;

  const QuizOptionsDialog({Key? key, this.gain}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

enum RequestState {
  ongoing,
  success,
  error,
}

class _QuizOptionsDialogState extends State<QuizOptionsDialog> {
  int? _noOfQuestions;
  late bool processing;
  bool selected = false;
  String? idPersonneConnected = "0";
  String contactOrange = "0";
  String contactMtn = "0";

  initValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idPersonne = prefs.getString('idPersonne').toString();
    String contact1 = prefs.getString('contactOrange').toString();
    String contact2 = prefs.getString('contactMtn').toString();

    setState(() {
      idPersonneConnected = idPersonne;
      contactOrange = contact1;
      contactMtn = contact2;
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
    _noOfQuestions = 0;
    setState(() {
      processing = false;
      selected = false;
    });
  }

  String _requestCode = "";

  void addCouponRamassage() async {
    final urlAddCoupon = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/coupon/addCoupon.php");
    final responseAddCoupon = await http.post(urlAddCoupon, body: {
      "idPersonne": idPersonneConnected,
      "idGain": widget.gain!.idGain,
      "reste": widget.gain!.total
    });

    if (responseAddCoupon.statusCode == 200) {
      Navigator.of(context).pop();
      error(context, "Réabonnement envoyé avec succès. Un message a été envoyé à votre administrateur local. La validation prendre quelques minutes.");
    }
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

  Future<void> sendUssdRequest() async {
    await FlutterPhoneDirectCaller.callNumber(_requestCode);
    setState(() {
      processing = false;
    });
    addCouponRamassage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: primaryColor,
            child: Text(
              "PACK ${widget.gain!.libelle} : ${widget.gain!.description}",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10.0),
          const Text("Choisir le moyen de paiement"),
          const SizedBox(height: 10.0),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 16.0,
              spacing: 16.0,
              children: <Widget>[
                const SizedBox(width: 10.0),
                ActionChip(
                  label: const Text("Orange Money"),
                  labelStyle: _noOfQuestions == 10
                      ? const TextStyle(color: Colors.black)
                      : const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 10
                      ? Colors.deepOrange
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(10, "#150*1*1*$contactOrange*100#"),
                ),
                ActionChip(
                  label: const Text("MTN Mobile Money"),
                  labelStyle: _noOfQuestions == 20
                      ? const TextStyle(color: Colors.black)
                      : const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 20
                      ? Colors.yellow
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(20, "*126*1*1*$contactMtn*100#"),
                ),
                ActionChip(
                  label: const Text("EU Mobile Money"),
                  labelStyle: _noOfQuestions == 30
                      ? const TextStyle(color: Colors.black)
                      : const TextStyle(color: Colors.white),
                  backgroundColor: _noOfQuestions == 30
                      ? Colors.blue
                      : Colors.grey.shade600,
                  onPressed: () => _selectNumberOfQuestions(30, "#150*1*1*681549332*100#"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          processing
          ? const CircularProgressIndicator()
          : ElevatedButton.icon(
            icon: const Icon(Icons.payments_outlined, size: 20.0, color: Colors.white,),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shadowColor: thirdColor,
                elevation: 3,
                minimumSize: Size(3*(MediaQuery.of(context).size.width)/4, 50),
              ),
              onPressed: !selected ? null : () {
                setState(() {
                  processing = true;
                });
                sendUssdRequest();
              },
              label: const Text("Payer", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _selectNumberOfQuestions(int i, String text) {
    setState(() {
      _noOfQuestions = i;
      _requestCode = text;
      selected = true;
    });
  }
}
