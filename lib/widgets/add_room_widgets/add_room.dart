import 'package:bitky/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../globals/globals.dart';
import '../custom_error_dialog.dart';
import '../custom_textfield.dart';
import '../primary_button_widget.dart';

class AddRoomWidget extends StatelessWidget {
   AddRoomWidget({Key? key}) : super(key: key);

    TextEditingController _roomController = TextEditingController();


   Future<void> formValidation(BuildContext context) async {
     final roomId = UniqueKey().hashCode;

     if (_roomController.text.isNotEmpty) {
       FirebaseFirestore.instance
           .collection("users/${authUser.currentUser!.uid}/gardens")
           .doc(roomId.toString())
           .set({
         "roomName": _roomController.text.toCapitalized().trim(),
         "roomId": roomId,
         "createDate": DateTime.now()
       }).whenComplete(() {
         showDialog(
             context: context,
             builder: (c) {
               return CustomErrorDialog(
                 message: AppLocalizations.of(context)!.addedisokey,
               );
             }).whenComplete(() =>Navigator.pop(context));
       });
     } else {
       showDialog(
           context: context,
           builder: (c) {
             return CustomErrorDialog(
               message: AppLocalizations.of(context)!.fillallfields,
             );
           });
     }
   }


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrymaryColor,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.mygardentitle,style: GoogleFonts.sourceSansPro(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/gardenroom.png'),alignment: Alignment.bottomCenter),
          gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFA5EFB0),
              ],
              begin: FractionalOffset(0.1, 1.0),
              end: FractionalOffset(0.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            child: CustomTextField(
              controller: _roomController,
              isObscreen: false,
              hintText:AppLocalizations.of(context)!.addyourgardentitle,
              height: 30,
            ),
          ),
          const SizedBox(height: 20,),
          CustomPrimaryButton(
            text: AppLocalizations.of(context)!.save,
            radius: 15,
            function:(){
              formValidation(context);
            },
          ),
        ],
      ),
      ),
    );
  }
}
