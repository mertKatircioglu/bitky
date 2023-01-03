
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomLoadingDialog extends StatelessWidget {

  BuildContext? context;
  final String? message;
  CustomLoadingDialog({this.context,this.message});


  Widget _dialog(BuildContext context) {
    return CupertinoAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              alignment: Alignment.center,
              padding:const EdgeInsets.only(top: 10),
              child:const CupertinoActivityIndicator()
          ),
          const SizedBox(height: 10,),
          Text(message!+". Please wait...", style: TextStyle(color: Colors.black54),)

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _dialog(context);
  }
}
