import 'package:bitky/globals/globals.dart';
import 'package:bitky/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';

import '../restart_app.dart';

class ProfileItem extends StatefulWidget {
  const ProfileItem({Key? key}) : super(key: key);

  @override
  State<ProfileItem> createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onPressed: (){
          authUser.signOut().whenComplete(() {
            RestartWidget.restartApp(context);
          });

        },
        child: Text("Logout"),
      ),
    );
  }
}
