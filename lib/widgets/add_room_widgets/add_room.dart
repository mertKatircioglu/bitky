import 'package:bitky/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../globals/globals.dart';

class AddRoomWidget extends StatelessWidget {
  const AddRoomWidget({Key? key}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrymaryColor,
        elevation: 4,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addyourgardentitle,style: GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/room.png')
          )
        ),
      ),
    );
  }
}
