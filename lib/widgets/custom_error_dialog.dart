import 'package:flutter/material.dart';

class CustomErrorDialog extends StatelessWidget {


  final String? message;
  CustomErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          },
            child: const Center(
              child:const Text('Ok', textAlign: TextAlign.center,),
            ),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
        )
      ],
    );
  }
}
