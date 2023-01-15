import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {

  final String? message;
  CustomErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      content: Text(message!, textAlign: TextAlign.center,),
      actions: [
        CupertinoButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },

            child: const Center(
              child:Text('Ok', textAlign: TextAlign.center,),
            ),
        )
      ],
    );
  }
}
