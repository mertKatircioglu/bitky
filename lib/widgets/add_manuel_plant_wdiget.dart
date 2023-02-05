import 'dart:io';

import 'package:bitky/globals/globals.dart';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'add_room_widgets/add_room.dart';
import 'custom_error_dialog.dart';
import 'custom_loading_dialog.dart';


class AddPlantManuelWidget extends StatefulWidget {
  String? roomId="";
  String? roomName="";
   AddPlantManuelWidget({Key? key, this.roomId, this.roomName}) : super(key: key);

  @override
  State<AddPlantManuelWidget> createState() => _AddPlantManuelWidgetState();
}

class _AddPlantManuelWidgetState extends State<AddPlantManuelWidget> {

  TextEditingController nameController = TextEditingController();
  String plantImageUrl ="";
  XFile? imageXfile;
  final ImagePicker _picker = ImagePicker();
  String roomId="";
  String roomName="";
  int? selectedIndex;

  Future<void> _getImage() async{
    imageXfile = await _picker.pickImage(source: ImageSource.gallery);
    setState((){
      imageXfile;
    });
  }



  Future<void> formValidation() async{
    if(imageXfile == null){
      showDialog(context: context,
          builder: (c){
            return CustomErrorDialog(message: AppLocalizations.of(context)!.plsselectaphoto,);
          });
    }else{
        if(nameController.text.isNotEmpty ){
          //start uploading image
          showDialog(context: context, builder:(c){
            return CustomLoadingDialog(message: AppLocalizations.of(context)!.yourplantisadded,);
          });
          //Foto Yükleme işlemi
          String fileName=authUser.currentUser!.uid+DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("plants").
          child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXfile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((url) => {
            plantImageUrl = url,

            //Kullanıcı bilgilerinin kaydı
            savePlantToFirebase()
          });
        }else{
          showDialog(context: context,
              builder: (c){
                return CustomErrorDialog(message: AppLocalizations.of(context)!.fillallfields,);
              });
        }

    }
  }


/*  getRoomFromFirebase()async{
    await FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/gardens").doc()
        .get().then((value) {
          value.docs.forEach((element) {
           roomId= element.data()["roomId"];
          });
    });

  }*/


  void savePlantToFirebase() async{
    final plantId = UniqueKey().hashCode;
    if (nameController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("users/${authUser.currentUser!.uid}/gardens")
          .doc(widget.roomId).collection(roomName).doc(plantId.toString())
          .set({
        "plantName": nameController.text.toCapitalized().trim(),
        "plantId": plantId,
        "location": roomName,
        "reminderIsActive":false,
        "image": plantImageUrl,
        "createDate": DateTime.now()
      }).whenComplete(() {
        showDialog(
            context: context,
            builder: (c) {
              return CustomErrorDialog(
                message: AppLocalizations.of(context)!.addplantmessage,
              );
            }).whenComplete(() => Navigator.of(context, rootNavigator: true).pop("Discard")
        );
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
    Navigator.pop(context);

  }

  @override
  void initState() {
    super.initState();
    if(widget.roomId !=null){
      setState(() {
        roomName = widget.roomName!;
        roomId = widget.roomId!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(12.0),
        decoration:   BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
        image: AssetImage('images/bt_banner.png'),alignment: Alignment.bottomCenter),
              gradient: const LinearGradient(
              colors: [
              Color(0xFFFFFFFF),
              Color(0xFFA5EFB0),
              ],)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: (){
              _getImage();
            },
            child: DottedBorder(
              borderType: BorderType.Circle,
              padding: const EdgeInsets.all(1),
              color: kPrymaryColor,
              strokeCap: StrokeCap.butt,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                backgroundImage: imageXfile == null ? null : FileImage(File(imageXfile!.path)),
                child: imageXfile == null ? const Icon(Icons.add_a_photo_outlined,
                  size:50,
                  color: kPrymaryColor,
                ) : null,
              ),
            ),

          ),
          Visibility(
              visible: widget.roomId !=null ? false : true,
              child:const SizedBox(height: 15,)),
          Visibility(
              visible: widget.roomId !=null ? false : true,
              child: Text(AppLocalizations.of(context)!.plsselectthearearoomyourplant, style:  GoogleFonts.sourceSansPro(fontSize: 16),)),
          Visibility(
            visible: widget.roomId !=null ? false : true,
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                  'users/${authUser.currentUser!.uid}/gardens')
                  .snapshots(),
              builder: (ctx, recentSnapshot) {
                if (recentSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(
                      color: Colors.white,
                    ),
                  );
                } else if (recentSnapshot.data!.docs.isEmpty) {
                  showDialog(
                      context: context,
                      builder: (c) {
                        return CustomErrorDialog(
                          message: AppLocalizations.of(context)!.fillallfields,
                        );
                      }).whenComplete(() {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AddRoomWidget(),
                      withNavBar: false,
                      pageTransitionAnimation:PageTransitionAnimation.cupertino,
                    );
                  });
                }
                final recentDocs = recentSnapshot.data!.docs;
                return FutureBuilder(
                  builder: (ctx, futureSnap) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: recentDocs.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(recentDocs[index]["roomName"], style:  GoogleFonts.sourceSansPro(fontSize: 16),),
                              tileColor: selectedIndex == index ? kPrymaryColor : null,
                              textColor: selectedIndex == index ? Colors.white : null,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  roomId = recentDocs[index]["roomId"].toString();
                                  roomName = recentDocs[index]["roomName"];
                                });
                                print(roomId);

                              },
                            ),
                          );

                          /*CheckboxListTile(
                                value: selected,
                                title: Text(recentDocs[index]["roomName"]),
                                controlAffinity: ListTileControlAffinity.platform,
                                activeColor: kPrymaryColor,
                                checkColor: Colors.white,
                                onChanged: (val){
                                  setState((){
                                      selected = val!;
                                  });
                                  roomId = recentDocs[index]["roomId"].toString();
                                  roomName = recentDocs[index]["roomName"];
                                  print(roomId);
                                });*/

                          /*RadioListTile(
                                value: recentDocs[index]["roomId"],
                                groupValue: roomId,
                                  title: Text(recentDocs[index]["roomName"]),
                                  onChanged: (val){
                                    roomId = val.toString();
                                    roomName = recentDocs[index]["roomName"];
                                  print(roomId);
                                  },
                            )*/
                        });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 15,),
          Text(AppLocalizations.of(context)!.plsenterthenameofyourplant, style:  GoogleFonts.sourceSansPro(fontSize: 16),),
          DottedBorder(
            padding: const EdgeInsets.only(right: 5, left: 5),
            strokeCap: StrokeCap.butt,
            color: kPrymaryColor,
            child: TextFormField(
              controller: nameController,
              decoration:  const InputDecoration(
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(height: 15,),
          CustomPrimaryButton(
            text: AppLocalizations.of(context)!.save,
            radius: 15,
            function:(){
              formValidation();
            },
          ),

        ],
      ),
    );
  }
}
