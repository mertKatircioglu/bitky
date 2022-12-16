import 'package:bitky/globals/globals.dart';
import 'package:flutter/material.dart';

import '../restart_app.dart';

class SettingsItem extends StatefulWidget {
  const SettingsItem({Key? key}) : super(key: key);

  @override
  State<SettingsItem> createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kPrymaryColor,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: TextButton(
            onPressed: (){
              authUser.signOut().whenComplete(() {
                RestartWidget.restartApp(context);
              });

            },
            child:const Text("Logout"),
          ),
        ),
      ),

    );
  }
}
