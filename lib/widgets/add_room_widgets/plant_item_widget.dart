import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../globals/globals.dart';
import '../../l10n/app_localizations.dart';
import '../reminder_add_widget.dart';

class PlantItemWidget extends StatefulWidget {
  String? roomName;
  int? roomId;

  PlantItemWidget({Key? key, this.roomName, this.roomId}) : super(key: key);

  @override
  State<PlantItemWidget> createState() => _PlantItemWidgetState();
}

class _PlantItemWidgetState extends State<PlantItemWidget> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AnimationController? localAnimationController;
  String? day;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(
              'users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}')
          .snapshots(),
      builder: (ctx, recentSnapshot) {
        if (recentSnapshot.connectionState == ConnectionState.waiting) {
          return const CupertinoActivityIndicator(
            color: Colors.transparent,
          );
        } else if (recentSnapshot.data!.docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.noplant,
                    style: GoogleFonts.sourceSansPro(),
                  ),
                ],
              ),
            ),
          );
        }
        final recentDocs = recentSnapshot.data!.docs;
        return FutureBuilder(
          builder: (ctx, futureSnap) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: recentDocs.length,
                itemBuilder: (context, index) {
                if(recentDocs[index]["reminderIsActive"]==true){
                  switch(recentDocs[index]['reminderDay']){
                    case 1:{
                      day=AppLocalizations.of(context)!.sunday;
                    }
                    break;
                    case 2:{
                      day=AppLocalizations.of(context)!.monday;
                    }
                    break;
                    case 3:{
                      day=AppLocalizations.of(context)!.tuesday;

                    }
                    break;
                    case 4:{
                      day=AppLocalizations.of(context)!.wednesday;

                    }
                    break;
                    case 5:{
                      day=AppLocalizations.of(context)!.thursday;

                    }
                    break;
                    case 6:{
                      day=AppLocalizations.of(context)!.friday;

                    }
                    break;
                    case 7:{
                      day=AppLocalizations.of(context)!.saturday;

                    }
                    break;
                    default :{

                    }
                  };
                }
                  return DataTable(
                      sortAscending: true,
                      dataRowColor: MaterialStateProperty.all<Color>(Colors.black54),
                      showCheckboxColumn: false,
                      headingRowColor: MaterialStateProperty.all<Color>(Colors.black54),
                      sortColumnIndex: 1,
                      columnSpacing: 0.0,
                      headingRowHeight: 0.0,
                      dividerThickness: 0.0,
                      dataRowHeight: 50,
                      showBottomBorder: false,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Image',
                            style: GoogleFonts.sourceSansPro(
                                color: kPrymaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.plantname,
                              style: GoogleFonts.sourceSansPro(
                                  color: kPrymaryColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.plantname,
                              style: GoogleFonts.sourceSansPro(
                                  color: kPrymaryColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.plantname,
                              style: GoogleFonts.sourceSansPro(
                                  color: kPrymaryColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                        DataColumn(
                          label: Text(AppLocalizations.of(context)!.plantname,
                              style: GoogleFonts.sourceSansPro(
                                  color: kPrymaryColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                      rows: [
                        DataRow(
                          color: MaterialStateProperty.all<Color>(Colors.transparent),
                          cells: [
                            DataCell(
                                ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child:CachedNetworkImage(
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                                imageUrl: recentDocs[index]["image"],
                                placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                                errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                                fadeOutDuration: const Duration(seconds: 1),
                                fadeInDuration: const Duration(seconds: 1),
                              ),
                            )),
                            DataCell(Text("${recentDocs[index]["plantName"].toString().substring(0,9)}...",maxLines: 1, style: GoogleFonts.sourceSansPro(),)),
                            recentDocs[index]["reminderIsActive"] ==false ? DataCell(
                                InkWell(
                                  onTap: (){
                                    showModalBottomSheet(
                                        useRootNavigator: true,
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            )),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: ReminderAddWidget(
                                              name: recentDocs[index]["plantName"],
                                              image: recentDocs[index]["image"],
                                              plantId:recentDocs[index]["plantId"],
                                              location: recentDocs[index]["location"],
                                              roomName: widget.roomName,
                                              roomId: widget.roomId,
                                            ),
                                          );
                                        });
                                  },
                                  child: Row(
                                    children: [
                                       const Padding(
                                         padding: EdgeInsets.only(left: 7.0),
                                        child: Icon(
                                      Icons.add_alarm,
                                      color: kPrymaryColor,
                                        ),
                                       ),
                                      Text("Hatırlatıcı Ekle",style: GoogleFonts.sourceSansPro(fontSize: 9, color: kPrymaryColor)),
                                    ],
                                  ),
                                )):
                            DataCell(Row(
                              children: [
                                Lottie.asset("images/reminder.json",width: 25,height: 25),
                                InkWell(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (c) {
                                          return CupertinoAlertDialog(
                                            content:  Text(
                                                AppLocalizations.of(context)!.areyousurewanttodeletereminder,
                                                textAlign: TextAlign.center),
                                            actions: [
                                              CupertinoButton(
                                                onPressed: ()  {
                                                  flutterLocalNotificationsPlugin.cancel(recentDocs[index]["scheduleId"]).whenComplete(() {
                                                    String id = recentDocs[index]["plantId"].toString();
                                                    FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}").doc(id)
                                                        .update({
                                                      "reminderIsActive":false,
                                                      "scheduleId": "",
                                                      "scheduleType": "",
                                                      "reminderTime": "",
                                                      "reminderDay": 0,
                                                    });
                                                    showTopSnackBar(
                                                      Overlay.of(context),
                                                      CustomSnackBar.error(
                                                        message:
                                                        "${recentDocs[index]["plantName"]}, ${AppLocalizations.of(context)!.reminderisdeleted}.",
                                                      ),
                                                      onAnimationControllerInit: (controller) =>
                                                      localAnimationController = controller,
                                                    );
                                                  });
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(recentDocs[index]["scheduleType"].toString().toCapitalized(),style: GoogleFonts.sourceSansPro(fontSize: 9, color: kPrymaryColor)),
                                      Visibility(
                                          visible: recentDocs[index]["scheduleType"].toString() =="monthly",
                                          child: Text("${(30-recentDocs[index]["reminderDay"]).toString()} Gün kaldı",
                                              style: GoogleFonts.sourceSansPro(fontSize: 9, color: kPrymaryColor))),
                                      Visibility(
                                          visible: recentDocs[index]["scheduleType"].toString() =="weekly",
                                          child: Text("${(7-recentDocs[index]["reminderDay"]).toString()} Gün kaldı\n$day",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.sourceSansPro(fontSize: 9, color: kPrymaryColor))),
                                      Visibility(
                                          visible: recentDocs[index]["scheduleType"].toString() =="daily",
                                          child:Text("Her gün ${(recentDocs[index]["reminderTime"]).toString()}",
                                              style: GoogleFonts.sourceSansPro(fontSize: 8, color: kPrymaryColor))),
                                      Text("Silmek için dokun",style: GoogleFonts.sourceSansPro(fontSize: 7, color: Colors.red)),

                                    ],
                                  ),
                                )
                              ],
                            )),
                            DataCell(IconButton(
                              icon: const Icon(
                                Icons.remove_circle_sharp,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (c) {
                                      return CupertinoAlertDialog(
                                        content: Text(
                                            "${AppLocalizations.of(context)!.areyousuredoyouwanttodelete} ${recentDocs[index]["plantName"]}",
                                            textAlign: TextAlign.center),
                                        actions: [
                                          CupertinoButton(
                                            onPressed: () {
                                              String id = recentDocs[index]
                                              ["plantId"]
                                                  .toString();
                                              FirebaseFirestore.instance
                                                  .collection(
                                                  "users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}")
                                                  .doc(id)
                                                  .delete();
                                              showTopSnackBar(
                                                Overlay.of(context)!,
                                                CustomSnackBar.error(
                                                  message:
                                                  "${recentDocs[index]["plantName"]}, ${AppLocalizations.of(context)!.isdeleted}",
                                                ),
                                                onAnimationControllerInit:
                                                    (controller) =>
                                                localAnimationController =
                                                    controller,
                                              );
                                              Navigator.of(context,
                                                  rootNavigator: true)
                                                  .pop("Discard");
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .yes),
                                          ),
                                          CupertinoButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                  rootNavigator: true)
                                                  .pop("Discard");
                                            },
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .no),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            )),
                            const DataCell(Card(child: Icon(Icons.playlist_add_check_sharp, color: Colors.indigo,)))
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
