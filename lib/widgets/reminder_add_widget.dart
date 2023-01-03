
import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/bitky_data_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/notification_service.dart';
import 'custom_error_dialog.dart';

class ReminderAddWidget extends StatefulWidget {
  BitkyDataModel? bitkyDataModel;
   ReminderAddWidget({Key? key, this.bitkyDataModel}) : super(key: key);

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
    if(widget.bitkyDataModel?.suggestions?[0].plantDetails?.commonNames?[0] != null) {
      nameController.text = widget.bitkyDataModel!.suggestions![0].plantDetails!.commonNames![0]
        .toCapitalized().toString();
    }
  }



  clearMenusUploadForm(){
    setState((){
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
                decoration:  BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                        image: NetworkImage(widget.bitkyDataModel!.images![0].url!))
                ),
                width: MediaQuery.of(context).size.width,
                height: 150,

              ),
              Padding(
                padding:const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(widget.bitkyDataModel!.suggestions![0].plantDetails!.commonNames![0].toCapitalized().toString(),
                        style: GoogleFonts.sourceSansPro(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),),

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
                  children: [
                    DottedBorder(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      strokeCap: StrokeCap.butt,
                      color: kPrymaryColor,
                      child: TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Plant name'),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    DottedBorder(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      color: kPrymaryColor,
                      child: TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Room name'),
                        textInputAction: TextInputAction.next,
                      ),
                    ),


                  ],
                ),
              )),

          SizedBox(height:80,child: NoteThumbnail(imagE:widget.bitkyDataModel!.images![0].url!,
              plantName: nameController.text, room: locationController.text ?? "Room 1",
              color: Colors.transparent,
              title: widget.bitkyDataModel!.suggestions![0].plantDetails!.commonNames![0].toString(), content: "Watering Time"))
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

const NoteThumbnail(
{Key? key,
required this.color,
required this.plantName,
  required this.imagE,
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
  TimeOfDay _time = TimeOfDay.now().replacing(hour: 11, minute: 30);
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

   int? day;

  Future _daily(BuildContext context) async {
    final notificationId = UniqueKey().hashCode;
    Navigator.of(context).push(showPicker(
      context: context,
      value: _time,
      onChange: (val){
        Time _timee = Time(val.hour,val.minute,00);
        formValidation(_timee,50, "daily",notificationId).whenComplete(() async{
          await service.showSchelduledNotificationDaily(id: notificationId, title: widget.title,
              body:widget.content, time:_timee).whenComplete(() {
            Navigator.pop(context);
            showDialog(context: context,
                builder: (c){
                  return CustomErrorDialog(message: 'Plant ${widget.plantName} watering alarms is set.',);
                });

          });
        });
      },
    ));
  }

  Future _weakly(BuildContext context) async {
    final notificationId = UniqueKey().hashCode;

    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        title: const Text("Select Day", style: TextStyle(color: kPrymaryColor),),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: const Text("Sunday"),
                value: 1,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);
                },
              ),

              RadioListTile(
                title: const Text("Monday"),
                value: 2,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),

              RadioListTile(
                title: const Text("Tuesday"),
                value: 3,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),
              RadioListTile(
                title: const Text("Wednesday"),
                value: 4,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),   RadioListTile(
                title: const Text("Thursday"),
                value: 5,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),
              RadioListTile(
                title: const Text("Friday"),
                value: 6,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),
              RadioListTile(
                title: const Text("Saturday"),
                value: 7,
                groupValue: day,
                onChanged: (value){
                  setState(() {
                    day = value;
                  });
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        ),
      );
    }).whenComplete(() async{
      Navigator.of(context).push(showPicker(
        context: context,
        value: _time,
        onChange: (val){
          Time _timee = Time(val.hour,val.minute,00);
          formValidation(_timee,day!, "weakly",notificationId).whenComplete(() async{
            await service.showSchelduledNotificationWeakly(id: notificationId, title: widget.title,
                body:widget.content, time:_timee, day: Day(day!)).whenComplete(() {
              Navigator.pop(context);
              showDialog(context: context,
                  builder: (c){
                    return CustomErrorDialog(message: 'Plant ${widget.plantName} watering alarms is set.',);

                  });


            });
          });
        },
      ));
    });


  }
  Future<void> formValidation(Time time, int day, String type, int notificationId) async{
    if(widget.plantName.isNotEmpty){

      FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/reminders").doc(notificationId.toString()).
      set({
        "scheduleId":notificationId,
        "isActive":true,
        "image": widget.imagE,
        "scheduleTipe":type,
        "plantName": widget.plantName,
        "room": widget.room ?? "Oda-1",
        "hour":time.hour,
        "day": day,
        "minute": time.minute,
        "createDate": DateTime.now()
      });
    }else{
      showDialog(context: context,
          builder: (c){
            return CustomErrorDialog(message: 'Please fill all fields.',);
          });
    }
  }


  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();

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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrymaryColor
            ),
              onPressed: () => _daily(context),
              child: const Text("Add daily reminder")),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent
              ),
              onPressed: () => _weakly(context),
              child: const Text("Add weakly reminder"))
        ],
      ),
    );
  }
}