import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/reminder_add_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../models/bitky_data_model.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  @override
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  bool isLoading = false;
  List<String> base64ImgList = [];
  BitkyViewModel? _bitkyViewModel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  BitkyDataModel _bitkyDataModel = BitkyDataModel();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  AnimationController? localAnimationController;
  bool notificationState = true;


  _addFromCamera(){
    _imagePickerSourceCamera().whenComplete(() {
      setState(() {
        isLoading = true;
      });
      if(base64ImgList.isNotEmpty){
        _bitkyViewModel!.plantIdentifyFromUi(base64ImgList).then((value) {
          _bitkyDataModel = value;
        }).then((value) {
          base64ImgList.clear();
          showModalBottomSheet(
              useRootNavigator: true,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  )),
              context: context,
              builder: (context) {
                return  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: ReminderAddWidget(
                        bitkyDataModel: _bitkyDataModel,
                      ),
                    );
              });
          setState(() {
            isLoading = false;
          });
        });
      }else{
        setState(() {
          isLoading = false;
        });
        showDialog(context: context, builder: (c){
          return CustomErrorDialog(message: "Something went wrong.");
        });
      }

    });
  }
   _openDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                  onPressed: () {

                    Navigator.pop(context);
                  _addFromCamera();

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_sharp,
                        color: kPrymaryColor,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(AppLocalizations.of(context)!.scanyourplant,
                          style: GoogleFonts.sourceSansPro(
                              color: kPrymaryColor, fontSize: 18)),
                    ],
                  )),
              const Divider(
                height: 2,
                color: kPrymaryColor,
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.games_sharp,
                        color: kPrymaryColor,
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(AppLocalizations.of(context)!.addyourgarden,
                          style: GoogleFonts.sourceSansPro(
                              color: kPrymaryColor, fontSize: 18)),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }


  Future _imagePickerSourceCamera() async {
    try {
      XFile? photos = await imgpicker.pickImage(
          source: ImageSource.camera, imageQuality: 90);
      if (photos != null) {
        var bytes = await photos.readAsBytes();
        var base64img = base64Encode(bytes);
        base64ImgList.add(base64img);
      }
    } catch (e) {

    }
  }

  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Text(
                    AppLocalizations.of(context)!.remindertitle,
                    style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                ],
              ),
              const SizedBox(
                height: 40,
              ),
              isLoading == true
                  ?    Center(
                child: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CupertinoActivityIndicator(color: kPrymaryColor,),
                      WavyAnimatedTextKit(
                        textStyle: GoogleFonts.sourceSansPro(
                          fontSize: 18,
                          color: kPrymaryColor
                        ),
                        text: const [
                          "Please wait..."
                        ],
                        isRepeatingAnimation: true,
                        speed: const Duration(milliseconds: 150),
                      ),
                    ],
                  ),
                )
              ):StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users/${authUser.currentUser!.uid}/reminders').
                  orderBy('createDate', descending: true).snapshots(),
                  builder:(ctx, reminderSnapshot){
                    if(reminderSnapshot.connectionState == ConnectionState.waiting){
                      return Center(child:SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CupertinoActivityIndicator(color: kPrymaryColor,),
                            WavyAnimatedTextKit(
                              textStyle: GoogleFonts.sourceSansPro(
                                  fontSize: 18,
                                  color: kPrymaryColor
                              ),
                              text:  [
                                AppLocalizations.of(context)!.plswait
                              ],
                              isRepeatingAnimation: true,
                              speed: const Duration(milliseconds: 150),
                            ),
                          ],
                        ),
                      ),) ;
                    } else if(reminderSnapshot.data!.docs.isEmpty){
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Text("No reminder. Add your first.")
                          ],
                        ),
                      );
                    }
                    final reminderDocs = reminderSnapshot.data!.docs;
                    return FutureBuilder(
                      builder:(context, futureSnapshot){
                        return ListView.builder(
                          shrinkWrap: true,
                            itemCount: reminderDocs.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: Dismissible(
                                  key: UniqueKey(),
                                  resizeDuration: const Duration(milliseconds: 50),
                                  movementDuration: const Duration(milliseconds: 50),
                                  direction: DismissDirection.endToStart,
                                  background: Container(color: Colors.red),
                                  onDismissed: (val){
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

                                                  flutterLocalNotificationsPlugin.cancel(reminderDocs[index]["scheduleId"]).whenComplete(() {
                                                    String id = reminderDocs[index]["scheduleId"].toString();
                                                    FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/reminders").doc(id)
                                                        .delete();
                                                    showTopSnackBar(
                                                      Overlay.of(context)!,
                                                      CustomSnackBar.error(
                                                        message:
                                                        "${reminderDocs[index]["plantName"]}, ${AppLocalizations.of(context)!.reminderisdeleted}.",
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
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(reminderDocs[index]["room"],style:GoogleFonts.sourceSansPro(),),
                                        Row(
                                          children: [
                                            Expanded(child: Text("${AppLocalizations.of(context)!.plantname}: ", style: GoogleFonts.sourceSansPro(color: kPrymaryColor),)),
                                            Expanded(child: Text(reminderDocs[index]["plantName"], style:GoogleFonts.sourceSansPro(),)),
                                          ],
                                        ),
                                        reminderDocs[index]["scheduleType"] == "weekly" ?  Row(
                                          children: [
                                            Text("${AppLocalizations.of(context)!.day}: ", style: GoogleFonts.sourceSansPro(color: kPrymaryColor),),
                                            Text(reminderDocs[index]["day"].toString(), style:GoogleFonts.sourceSansPro(),),
                                          ],
                                        ):Container(),
                                        Row(
                                          children: [
                                            Text("${AppLocalizations.of(context)!.time}: ", style: GoogleFonts.sourceSansPro(color: kPrymaryColor),),
                                            Text(reminderDocs[index]["time"].toString(), style:GoogleFonts.sourceSansPro(),),

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("${AppLocalizations.of(context)!.schduletype}: ", style: GoogleFonts.sourceSansPro(color: kPrymaryColor),),
                                            Text(reminderDocs[index]["scheduleType"].toString().toCapitalized(), style:GoogleFonts.sourceSansPro(color: Colors.deepOrange),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      backgroundImage: NetworkImage(reminderDocs[index]["image"]),
                                      child: const CupertinoActivityIndicator(),
                                    ),
                                    trailing:const Icon(Icons.notifications_active_outlined, color: kPrymaryColor,),
                                  ),
                                ),
                              );
                            });
                      },
                    );

                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: FloatingActionButton(
          onPressed: () {
            _openDialog();


          },
          backgroundColor: kPrymaryColor,
          child: const Icon(
            Icons.add_alert_sharp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
