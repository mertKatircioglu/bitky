import 'package:bitky/globals/globals.dart';
import 'package:bitky/nav_bar_items/settings_item.dart';
import 'package:flutter/material.dart';

class CustomSettingsButton extends StatelessWidget {
  const CustomSettingsButton({Key? key}) : super(key: key);



  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>const SettingsItem(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){

      Navigator.of(context).push(_createRoute());
    }, icon: const Icon(Icons.settings,
      color:kPrymaryColor ,));
  }
}
