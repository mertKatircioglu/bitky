import 'package:bitky/globals/globals.dart';
import 'package:bitky/screens/home_screen.dart';
import 'package:bitky/view_models/planet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitky Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: kPrymaryColor
      ),
      home: ChangeNotifierProvider<BitkyViewModel>(
          create: (context)=>locator<BitkyViewModel>(),
          child: const HomeScreen()),
    );
  }
}

