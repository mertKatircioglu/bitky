import 'dart:async';

import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../locator.dart';
import '../models/weather_data_model.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {
  WeatherDataModel _weatherDataModel = WeatherDataModel();
  final BitkyViewModel _bitkyViewModel = BitkyViewModel();
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return ChangeNotifierProvider<BitkyViewModel>(
            create: (context)=>locator<BitkyViewModel>(),
            child: HomeScreen(dataModel: _weatherDataModel,));
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


  startTimer(BuildContext context)async{
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true){
      Timer(const Duration(seconds: 2), () async {
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

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(AppLocalizations.of(context)!.locationservicesaredisable);
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(AppLocalizations.of(context)!.locationpermissionaredenied);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          AppLocalizations.of(context)!.locationpermissionpermanetly);
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      _bitkyViewModel.getWeatherFromUi(value.latitude, value.longitude, context).then((value) {
        _weatherDataModel = value;
        print(_weatherDataModel.toJson().toString());
      });
    }).whenComplete(() => startTimer(context));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('images/banner.png'),alignment: Alignment.topCenter),
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
