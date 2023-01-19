import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {
  VoidCallback? fnc;
  final String? message;
  CustomErrorDialog({this.message, this.fnc});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      content: Text(message!, textAlign: TextAlign.center,),
      actions: [
        CupertinoButton(
          onPressed: fnc !=null ? fnc : ()=> Navigator.of(context, rootNavigator: true).pop("Discard"),

            child: const Center(
              child:Text('Ok', textAlign: TextAlign.center,),
            ),
        )
      ],
    );
  }
}
