import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/app_bar_widget.dart';

class MyGarden extends StatefulWidget {
  const MyGarden({Key? key}) : super(key: key);

  @override
  State<MyGarden> createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustomWidget(title: "My Garden",),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFA5EFB0),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(3.0, 2.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        child: Center(
          child: CustomPrimaryButton(
            text: "Add your first garden",
            radius: 15,
            function:()=> print("click"),
          ),
        ),
      ),
    );

  }
}
