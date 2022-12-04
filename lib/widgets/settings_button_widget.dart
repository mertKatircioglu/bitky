import 'package:bitky/globals/globals.dart';
import 'package:flutter/material.dart';

class CustomSettingsButton extends StatelessWidget {
  const CustomSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.settings,
                  color:kPrymaryColor ,);

  }
}
