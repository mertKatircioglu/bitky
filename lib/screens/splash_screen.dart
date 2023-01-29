import 'dart:async';

import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../locator.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';
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


  startTimer(BuildContext context)async{
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true){
      Timer(const Duration(seconds: 3), () async {
        if(authUser.currentUser != null){
          Navigator.of(context).pushReplacement(_createRoute());
        }else{
          Navigator.of(context).pushReplacement(_createRouteAuth());

        }
      });
    } else{
      showDialog(context: context, builder: (c){
        return CustomErrorDialog(message: "No Internet connection.");
      });
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }


  }

  @override
  void initState() {
    super.initState();
     CustomAppBarWidget();
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
             Text(AppLocalizations.of(context)!.splashtitle,style: TextStyle(fontSize: 12,)),
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
