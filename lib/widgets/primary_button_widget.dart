import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  String? text;
  final VoidCallback? function;
   CustomPrimaryButton({Key? key, this.text, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.symmetric(horizontal: 70),
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xfff4FE58A),Color(0xfff19C179)]),
        borderRadius:BorderRadius.circular(18.0)
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25)
          )
        ),
          onPressed:function,
          child: Text(
            text!
          )),
    );
  }
}
