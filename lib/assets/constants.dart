import 'package:flutter/material.dart';

import '/assets/assets.dart';
import '/assets/developer.dart';

const String githubRepo =
    "https://github.com/lohanidamodar/flutter_ui_challenges";
const String youtubeChannel = "https://youtube.com/c/reactbits";

// Colors
const kBackgroundColor = Color(0xFFFFFFFF);
const kPrimaryColor = Color(0xFF2D5D70);
const kSecondaryColor = Color(0xFF265DAB);

const List<Developer> DEVELOPERS = [
  Developer(
    name: "Damodar Lohani",
    profession: "Full Stack Developer",
    address: "Kathmandu, Nepal",
    github: "https://github.com/lohanidamodar",
    imageUrl: devDamodar,
  ),
  Developer(
    name: "Sudip Thapa",
    profession: "Flutter & React Developer",
    address: "Kathmandu, Nepal",
    github: "https://github.com/sudeepthapa",
    imageUrl: devSudip,
  ),
  Developer(
    name: "Arpana Dulal",
    profession: "Flutter Developer",
    address: "Kathmandu, Nepal",
    github: "https://github.com/ambikadulal",
    imageUrl: devArpana,
  ),
];

const String privacyUrl = "https://popupbits.com/contact/flutter-ui-challenges-privacy-policy/";