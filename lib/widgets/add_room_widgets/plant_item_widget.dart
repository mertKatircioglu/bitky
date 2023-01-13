import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../globals/globals.dart';
import '../../l10n/app_localizations.dart';

class PlantItemWidget extends StatefulWidget {
  String? roomName;
  int? roomId;
   PlantItemWidget({Key? key, this.roomName, this.roomId}) : super(key: key);

  @override
  State<PlantItemWidget> createState() => _PlantItemWidgetState();
}

class _PlantItemWidgetState extends State<PlantItemWidget> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AnimationController? localAnimationController;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}')
          .snapshots(),
        builder: (ctx,recentSnapshot){
          if(recentSnapshot.connectionState == ConnectionState.waiting){
            return const CupertinoActivityIndicator(color: Colors.transparent,);
          }else if(recentSnapshot.data!.docs.isEmpty){
            return Padding(
              padding: const EdgeInsets.only(top:0 ),
              child:  Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Text(AppLocalizations.of(context)!.noplant, style:GoogleFonts.sourceSansPro() ,),

                  ],
                ),
              ),
            );
          }
          final recentDocs = recentSnapshot.data!.docs;
          return FutureBuilder(
            builder: (ctx, futureSnap){
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: recentDocs.length,
                  itemBuilder: (context, index){
                    return DataTable(
                        sortAscending: true,
                        showCheckboxColumn: false,
                        sortColumnIndex: 0,
                        columnSpacing: 0.0,
                        headingRowHeight: 0.0,
                        dividerThickness: 0.0,
                        dataRowHeight: 50,
                        showBottomBorder: false,
                        columns:  [
                          DataColumn(
                            label: Text('Image', style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600), ),
                          ),
                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.plantname, style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600) ),
                          ),  DataColumn(
                            label: Text(AppLocalizations.of(context)!.plantname, style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600) ),
                          ),

                          DataColumn(
                            label: Text(AppLocalizations.of(context)!.plantname, style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontWeight: FontWeight.w600) ),
                          ),



                        ], rows: [
                      DataRow(
                        cells: [
                          DataCell(
                              Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: NetworkImage(recentDocs[index]["image"]),
                                  fit: BoxFit.cover
                              )
                            ),
                          )),
                          DataCell(Text(recentDocs[index]["plantName"])),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red,),
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return CupertinoAlertDialog(
                                      content:  Text(
                                          "${AppLocalizations.of(context)!.areyousuredoyouwanttodelete} ${recentDocs[index]["plantName"]}",
                                          textAlign: TextAlign.center),
                                      actions: [
                                        CupertinoButton(
                                          onPressed: ()  {
                                            String id = recentDocs[index]["plantId"].toString();
                                            FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}").doc(id)
                                                .delete();
                                            showTopSnackBar(
                                              Overlay.of(context)!,
                                              CustomSnackBar.error(
                                                message:
                                                "${recentDocs[index]["plantName"]}, ${AppLocalizations.of(context)!.isdeleted}",
                                              ),
                                              onAnimationControllerInit: (controller) =>
                                              localAnimationController = controller,
                                            );
                                            Navigator.of(context, rootNavigator: true).pop("Discard");
                                          },
                                          child: Text(AppLocalizations.of(context)!.yes),
                                        ),
                                        CupertinoButton(
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop("Discard");

                                          },
                                          child: Text(AppLocalizations.of(context)!.no),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )),
                          DataCell(IconButton(
                            icon: const Icon(Icons.add_alarm, color: kPrymaryColor,),
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (c) {
                                    return CupertinoAlertDialog(
                                      content:  Text(
                                          "${AppLocalizations.of(context)!.areyousuredoyouwanttodelete} ${recentDocs[index]["plantName"]}",
                                          textAlign: TextAlign.center),
                                      actions: [
                                        CupertinoButton(
                                          onPressed: ()  {
                                            String id = recentDocs[index]["plantId"].toString();
                                            FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}").doc(id)
                                                .delete();
                                            showTopSnackBar(
                                              Overlay.of(context)!,
                                              CustomSnackBar.error(
                                                message:
                                                "${recentDocs[index]["plantName"]}, ${AppLocalizations.of(context)!.isdeleted}",
                                              ),
                                              onAnimationControllerInit: (controller) =>
                                              localAnimationController = controller,
                                            );
                                            Navigator.of(context, rootNavigator: true).pop("Discard");
                                          },
                                          child: Text(AppLocalizations.of(context)!.yes),
                                        ),
                                        CupertinoButton(
                                          onPressed: () {
                                            Navigator.of(context, rootNavigator: true).pop("Discard");

                                          },
                                          child: Text(AppLocalizations.of(context)!.no),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          )),

                        ],
                      )
                    ]);
                  });
            },
          );
        },

    );
  }
}
