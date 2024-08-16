import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:trashhunters/pages/abonnement/abonnement.dart';
import 'package:trashhunters/pages/app/aboutus.dart';
import 'package:trashhunters/pages/autres/chat.dart';
import 'package:trashhunters/pages/autres/detailpost.dart';
import 'package:trashhunters/pages/profile/editAvatar.dart';
import 'package:trashhunters/pages/profile/editPassword.dart';
import 'package:trashhunters/pages/profile/profil.dart';
import 'package:trashhunters/pages/ramassage/signalement_listOrdures.dart';
import 'package:trashhunters/pages/ramassage/signalement_programmes.dart';
import 'package:trashhunters/pages/tools/easy_loader.dart';
import 'package:trashhunters/pages/profile/editprofile.dart';
import 'package:trashhunters/pages/autres/help.dart';
import 'package:trashhunters/pages/trash/history.dart';
import 'package:trashhunters/pages/home.dart';
import 'package:trashhunters/pages/autres/phone.dart';
import 'package:trashhunters/pages/autres/pick.dart';
import 'package:trashhunters/pages/trash/programmeRamassage.dart';
import 'package:trashhunters/pages/ramassage/ramassage.dart';
import 'package:trashhunters/pages/app/settings.dart';
import 'package:trashhunters/pages/signinup/signin_page.dart';
import 'package:trashhunters/pages/signinup/signup_page.dart';
import 'package:trashhunters/pages/trash/trash.dart';
import 'package:trashhunters/pages/autres/verify.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //runApp(const MyApp());

  runApp(MaterialApp(
    title: 'Trash Hunter App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const MyApp(),
    routes: {
      '/phone' :(context) => const MyPhone(),
      '/verify' :(context) => const MyVerify(),
      '/signin' :(context) => const SignInPage(),
      '/signup' :(context) => const SignUpPage(),
      '/home' :(context) => const Home(),
      '/edit_profil' :(context) => EditProfilePage(),
      '/edit_avatar' :(context) => EditAvatarPage(),
      '/edit_password' :(context) => EditPasswordPage(),
      '/profil' :(context) => ProfilePage(),
      '/trash' :(context) => const Trash(),
      '/history' :(context) => History(),
      '/todo' :(context) => Pick(),
      '/chat' :(context) => Chat(),
      '/help' :(context) => AidePage(),
      '/aboutus' :(context) => const AproposPage(),
      '/settings' :(context) => SettingPage(),
      '/detailpost' :(context) => const PostPage(),
      '/ramassage' :(context) => const RamassagesPage(),
      '/abonnement' :(context) => const MonAbonnementPage(),
      '/signalementProgRam' :(context) => const ListProgrammeRamassage(),
      '/signalementListOrdures' :(context) => const ListOrdures(),
      '/programmeRamassage' :(context) => const ProgrammeRamassagePage()
    },
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _myAppState();
}

class _myAppState extends State<MyApp> {
  String string = '';

  bool isoffline = false;
  bool userIsLoggedIn = false;
  Timer? timer;

  getLoggedInState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool('isLoggedIn');
    setState(() {
      userIsLoggedIn = value!;
    });
  }

  @override
  void initState() {
    super.initState();

    getLoggedInState();
    Timer(const Duration(seconds: 5), () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => userIsLoggedIn != null
              ? userIsLoggedIn
                ? const HomePage()
                : const SignInPage()
              : const SignInPage()),
    ),
    );
  }

  @override
  void dispose() {
    //_networkConnectivity.disposeStream();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      //title: nameApp,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
              child: EasyLoader()
          )),
    );
  }
}
