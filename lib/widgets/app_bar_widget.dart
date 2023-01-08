import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarCustomWidget extends StatelessWidget with PreferredSizeWidget{
  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  const Size.fromHeight(100);
  String? title;
   AppBarCustomWidget({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      backwardsCompatibility: false,
      foregroundColor: Colors.black,
      title: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Text(title!,style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600),),


  ),
    );
  }


}
