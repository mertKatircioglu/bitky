import 'dart:io';
import 'dart:math';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/l10n/app_localizations_tr.dart';
import 'package:bitky/restart_app.dart';
import 'package:bitky/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/l10.dart';
import 'locator.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  setupLocator();
  HttpOverrides.global =  MyHttpOverrides();
  runApp(RestartWidget(child: const MyApp(),));
}



class MyApp extends StatelessWidget with WidgetsBindingObserver {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Bitky Guide',
      supportedLocales: L10n.all,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kPrymaryColor
      ),
      home:const SplashScreen(),
    );
  }
}

