import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? iconData;
  final String? hintText;
  bool? isObscreen = true;
  bool? enabled = true;
  final VoidCallback? buttonIconFunc;
  final VoidCallback? onEditingComplate;
  final IconData? buttonIcon;
  final Color? buttonIconColor;
  final double? height;


  CustomTextField({this.onEditingComplate, this.buttonIconColor, this.buttonIcon, this.buttonIconFunc,
    this.controller, this.hintText, this.iconData, this.enabled,
    this.isObscreen, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width /1.2,
      height: height,
      decoration:const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6)
        )
      ),
      margin:const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObscreen!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          suffixIcon: buttonIcon !=null ? Card(
            child: IconButton(
              onPressed: buttonIconFunc,
              icon: Icon(buttonIcon),
              color: buttonIconColor,
            ),
          ) : null,
          border: InputBorder.none,
          prefixIcon: Icon(iconData, color: Colors.black45, ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 12)
        ),
      ),
    );
  }
}
