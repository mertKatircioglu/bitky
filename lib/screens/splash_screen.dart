import 'dart:async';

import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
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
      Timer(const Duration(seconds: 6), () async {
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
     const CustomAppBarWidget();
    startTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            /*   image: DecorationImage(
            image: AssetImage('images/bt_banner.png'),alignment: Alignment.bottomCenter),*/
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Lottie.asset("images/splashLottie2.json", width: 400, height: 400),
             Text("Bitky",  style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontSize: 22, fontWeight: FontWeight.bold),),
             Text(AppLocalizations.of(context)!.splashtitle,style: GoogleFonts.sourceSansPro(color: Colors.black54,
             fontWeight: FontWeight.w600
             )),

            ],
          ),
        ),
      ),
    );
  }
}
