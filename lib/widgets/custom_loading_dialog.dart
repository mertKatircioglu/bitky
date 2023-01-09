
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

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
          Text("${message!}. ${AppLocalizations.of(context)!.plswait}", style: const TextStyle(color: Colors.black54),)

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _dialog(context);
  }
}
