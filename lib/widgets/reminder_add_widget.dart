import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timezone/timezone.dart' as tz;
import '../helpers/notification_service.dart';
import 'custom_error_dialog.dart';

class ReminderAddWidget extends StatefulWidget {
  final String? name;
  final String? image;
  final String? location;
  final int? plantId;
  final int? roomId;
  final String? roomName;
  ReminderAddWidget(
      {Key? key,
      this.name,
      this.image,
      this.location,
      this.plantId,
      this.roomId,
      this.roomName}) : super(key: key);

  @override
  State<ReminderAddWidget> createState() => _ReminderAddWidgetState();
}

class _ReminderAddWidgetState extends State<ReminderAddWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.name !=
        null) {
      nameController.text = widget
          .name!.toCapitalized()
          .toString();
    }
    if (widget.location !=
        null) {
      locationController.text = widget
          .location!.toCapitalized()
          .toString();
    }
  }

  clearMenusUploadForm() {
    setState(() {
      nameController.clear();
      locationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.darken),
                        image: NetworkImage(
                            widget.image!))),
                width: MediaQuery.of(context).size.width,
                height: 150,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.name!
                            .toCapitalized()
                            .toString(),
                        style: GoogleFonts.sourceSansPro(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DottedBorder(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      strokeCap: StrokeCap.butt,
                      color: kPrymaryColor,
                      child: TextFormField(
                        controller: nameController,
                        decoration:  InputDecoration(
                            border: InputBorder.none, hintText: AppLocalizations.of(context)!.plantname),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  widget.location == null ?  DottedBorder(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      color: kPrymaryColor,
                      child: TextFormField(
                        controller: locationController,
                        decoration:  InputDecoration(
                            border: InputBorder.none, hintText: AppLocalizations.of(context)!.roomname),
                        textInputAction: TextInputAction.next,
                      ),
                    ) : Row(
                      children: [
                        Text("${AppLocalizations.of(context)!.roomname}: ",style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontSize: 14, fontWeight: FontWeight.w600)),
                        Text(locationController.text,style: GoogleFonts.sourceSansPro( fontSize: 14, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              )),
          SizedBox(
              height: 80,
              child: NoteThumbnail(
                  imagE: widget.image!,
                  plantName: nameController.text,
                  room: locationController.text ?? "Room 1",
                  color: Colors.transparent,
                  title: nameController.text,
                  plantId: widget.plantId!,
                  roomId: widget.roomId!,
                  roomName: widget.roomName!,
                  content: AppLocalizations.of(context)!.wateringtime)),
          const SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}

class NoteThumbnail extends StatefulWidget {
  final Color color;
  final String title;
  final String plantName;
  final String room;
  final String imagE;
  final String content;
  final int roomId;
  final String roomName;
  final int plantId;

  const NoteThumbnail(
      {Key? key,
        required this.plantId,
      required this.color,
      required this.plantName,
      required this.imagE,
        required this.roomName,
        required this.roomId,
      required this.room,
      required this.title,
      required this.content})
      : super(key: key);

  @override
  _NoteThumbnailState createState() => _NoteThumbnailState();
}

class _NoteThumbnailState extends State<NoteThumbnail> {
  DateTime selectedDate = DateTime.now();
  DateTime fullDate = DateTime.now();
  late final LocalNotificationService service;
  int? selectedDay;
  bool iosStyle = true;
  int? day;
  String? time;

  Future _daily(BuildContext context) async {
    final notificationId = UniqueKey().hashCode;
    DatePicker.showTimePicker(context,
        showTitleActions: true,
        showSecondsColumn: false,
        currentTime: DateTime.now(), onChanged: (date) {
      setState(() {
        time = "${date.hour.toString()}:${date.minute.toString()}";
      });
      print(time);
    }, onConfirm: (date) {
      time = "${date.hour.toString()}:${date.minute.toString()}";
      var tzTime = tz.TZDateTime.parse(tz.local, date.toString());
      formValidation(time!, 50, "daily", notificationId).whenComplete(() async {
        await service
            .showSchelduledNotificationDaily(
                id: notificationId,
                title: widget.title,
                body: widget.content,
                time: tzTime)
            .whenComplete(() {
          Navigator.pop(context);
          showDialog(
              context: context,
              builder: (c) {
                return CustomErrorDialog(
                  message: '${AppLocalizations.of(context)!.plant} ${widget.plantName} ${AppLocalizations.of(context)!.wateringalarmisset}',
                );
              });
        });
      });
    });
  }

  Future _monthly(BuildContext context) async {
    final notificationId = UniqueKey().hashCode;
    DatePicker.showDateTimePicker(context,
        showTitleActions: true,
        currentTime: DateTime.now(), onChanged: (date) {
          setState(() {
            time = "${date.hour.toString()}:${date.minute.toString()}";
          });
          print(time);
        }, onConfirm: (date) {
          time = "${date.hour.toString()}:${date.minute.toString()}";
          var tzTime = tz.TZDateTime.parse(tz.local, date.toString());
          formValidation(time!, date.day, "monthly", notificationId).whenComplete(() async {
            await service
                .showSchelduledNotificationmonthly(
                id: notificationId,
                title: widget.title,
                body: widget.content,
                time: tzTime,
                day: date.day)
                .whenComplete(() {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (c) {
                    return CustomErrorDialog(
                      message: '${AppLocalizations.of(context)!.plant} ${widget.plantName} ${AppLocalizations.of(context)!.wateringalarmisset}',
                    );
                  });
            });
          });
        });
  }

  Future _weakly(BuildContext context) async {
    final notificationId = UniqueKey().hashCode;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title:  Text(
              AppLocalizations.of(context)!.selectday,
              style: const TextStyle(color: kPrymaryColor),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.sunday),
                  value: 1,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.monday),
                  value: 2,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.tuesday),
                  value: 3,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.wednesday),
                  value: 4,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.thursday),
                  value: 5,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.friday),
                  value: 6,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
                RadioListTile(
                  title: Text(AppLocalizations.of(context)!.saturday),
                  value: 7,
                  groupValue: day,
                  onChanged: (value) {
                    setState(() {
                      day = value;
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }).whenComplete(() async {
      DatePicker.showTimePicker(context,
          showTitleActions: true,
          showSecondsColumn: false,
          currentTime: DateTime.now(), onChanged: (date) {
        setState(() {
          time = "${date.hour.toString()}:${date.minute.toString()}";
        });
      }, onConfirm: (date) {
        print(date.toString());
        var tzTime = tz.TZDateTime.parse(tz.local, date.toString());
        formValidation(time!, day!, "weekly", notificationId)
            .whenComplete(() async {
          await service
              .showSchelduledNotificationWeakly(
                  id: notificationId,
                  title: widget.title,
                  body: widget.content,
                  time: tzTime,
                  day: day!)
              .whenComplete(() {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (c) {
                  return CustomErrorDialog(
                    message:
                        '${AppLocalizations.of(context)!.plant} ${widget.plantName} ${AppLocalizations.of(context)!.wateringalarmisset}',
                  );
                });
          });
        });
      });
    });
  }

  Future<void> formValidation(
      String time, int day, String type, int notificationId) async {
    if (widget.plantName.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("users/${authUser.currentUser!.uid}/gardens/${widget.roomId}/${widget.roomName}").doc(widget.plantId.toString())
          .update({
        "scheduleId": notificationId,
        "reminderIsActive": true,
        "image": widget.imagE,
        "scheduleType": type,
        "reminderTime": time,
        "reminderDay": day,
        "reminderCreateDate": DateTime.now()
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
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    time="${DateTime.now().hour}:${DateTime.now().second}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kPrymaryColor),
                onPressed: () => _daily(context),
                child: Text(AppLocalizations.of(context)!.adddailyreminderbutton)),
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: kPrymaryColor),
                onPressed: () => _monthly(context),
                child: Text("Aylık")),
          ),
          Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent),
                onPressed: () => _weakly(context),
                child: Text(AppLocalizations.of(context)!.addweeklyreminder)),
          )
        ],
      ),
    );
  }
}
