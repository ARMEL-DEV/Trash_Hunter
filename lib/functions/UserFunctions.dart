import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trashhunters/models/coupon_model.dart';
import 'package:trashhunters/models/personne_model.dart';
import '../models/account_model.dart';

class UserFunctions {
  Future<Personne> getDetailsPersonne(String contact) async {
    Personne pers = Personne("", "", "", "", "", "", "", "", "");

    final urlDetailsPersonne = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/personne/findPersonneByContact.php");
    final responseDetailsPersonne = await http.post(urlDetailsPersonne, body: {
      "contact": contact
    });

    if(responseDetailsPersonne.statusCode == 200) {
      final mapPersonne = json.decode(responseDetailsPersonne.body);
      final personne = mapPersonne["result"];

      for(var user in personne){
        Personne p = Personne(
            user['idPersonne'],
            user['nom'],
            user['prenom'],
            user['sexe'],
            user['email'],
            user['contact'],
            user['adresse'],
            user['profil'],
            user['statut']
        );
        pers = p;
      }
    }
    return pers;
  }

  Future<Account> getDetailsAccount(String idAccount) async {
    Account account = Account("", "", "", "", "", "", "");

    final urlDetailsAccount = Uri.parse("https://trashhunter.dshcenter.com/api/GestionComptes/account/findAccountByIdAccount.php");
    final responseDetailsAccount = await http.post(urlDetailsAccount, body: {
      "idAccount": idAccount
    });

    if(responseDetailsAccount.statusCode == 200) {
      final mapAccount = json.decode(responseDetailsAccount.body);
      final acc = mapAccount["result"];

      for(var user in acc){
        Account a = Account(
            user['idAccount'],
            user['idApp'],
            user['idPersonne'],
            user['login'],
            user['password'],
            user['niveauAcces'],
            user['statut']
        );
        account = a;
      }
    }
    return account;
  }

  Future<Coupon> getResteRamassagePersonne(String idPersonne) async {
    Coupon coupon = Coupon("", "", "", "", "", "", "0", "");
    final urlDetailsCoupon = Uri.parse("https://trashhunter.dshcenter.com/api/GestionTrash/coupon/findCouponByPersonne.php");
    final responseDetailsCoupon = await http.post(urlDetailsCoupon, body: {
      "idPersonne": idPersonne
    });

    if(responseDetailsCoupon.statusCode == 200) {
      final mapCoupon = json.decode(responseDetailsCoupon.body);
      final list = mapCoupon["result"];

      if(list != "false") {
        for (var coup in list) {
          Coupon c = Coupon(
              coup['idCoupon'],
              coup['idPersonne'],
              coup['Use_idPersonne'],
              coup['idGain'],
              coup['dateCoupon'],
              coup['preuve'],
              coup['reste'],
              coup['statut']
          );
          coupon = c;
        }
      }
    }
    return coupon;
  }
}