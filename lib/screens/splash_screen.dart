import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../locator.dart';
import '../view_models/planet_view_model.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      return ChangeNotifierProvider<BitkyViewModel>(
          create: (context)=>locator<BitkyViewModel>(),
          child:const HomeScreen());
    },
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

Route _createRouteAuth() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>const AuthScreen(),
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


class _SplashScreenState extends State<SplashScreen> {
  startTimer(BuildContext context){
    Timer(const Duration(seconds: 3), () async {

      if(authUser.currentUser != null){
        Navigator.of(context).pushReplacement(_createRoute());
      }else{
        Navigator.of(context).pushReplacement(_createRouteAuth());

      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Image.asset("images/plant.png", width: 70, height: 70,),
            const Text("Bitky", style: TextStyle(fontSize: 18, color: kPrymaryColor),),
            const Text("Identify a plant or plant problem",style: TextStyle(fontSize: 12,)),
            const SizedBox(height: 20,),
            const CupertinoActivityIndicator(
                radius: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
