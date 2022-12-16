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

class _SplashScreenState extends State<SplashScreen> {
  startTimer(BuildContext context){
    Timer(const Duration(seconds: 3), () async {

      if(authUser.currentUser != null){
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (c){
          return ChangeNotifierProvider<BitkyViewModel>(
              create: (context)=>locator<BitkyViewModel>(),
              child:const HomeScreen());
        }));
      }else{
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (c)=>const AuthScreen()));
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
            children: const [
              CupertinoActivityIndicator(),

            ],
          ),
        ),
      ),
    );
  }
}
