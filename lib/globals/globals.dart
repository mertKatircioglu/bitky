import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth authUser = FirebaseAuth.instance;
bool? hideNavBar=false;
const Color kBackGroundColor = Color(0xFFF5F5F5);
const Color kPrymaryColor = Color(0xfff19c179);
const Color kButtonColorPrimary = Color(0x004fe58a);
const Color kButtonColorRed = Color(0x00f36d6d);

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}