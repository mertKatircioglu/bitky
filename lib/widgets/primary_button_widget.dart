import 'package:flutter/material.dart';

class CustomPrimaryButton extends StatelessWidget {
  String? text;
  double? radius;
  final VoidCallback? function;
   CustomPrimaryButton({Key? key, this.text, this.function, this.radius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xfff4fe58a),Color(0xfff19C179)]),
        borderRadius:BorderRadius.circular(radius!)
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
            text!, style: const TextStyle(color: Colors.white),
          )),
    );
  }
}
