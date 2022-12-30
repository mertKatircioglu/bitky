import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {

  final String? message;
  CustomErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!, textAlign: TextAlign.center,),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
            child: const Center(
              child:Text('Ok', textAlign: TextAlign.center,),
            ),
        )
      ],
    );
  }
}
