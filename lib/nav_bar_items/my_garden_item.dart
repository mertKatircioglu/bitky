import 'dart:convert';
import 'dart:io';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/models/plant_data_model.dart';
import 'package:bitky/widgets/add_room_widgets/add_room.dart';
import 'package:bitky/widgets/add_room_widgets/plant_item_widget.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../models/bitky_data_model.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/custom_error_dialog.dart';

class MyGarden extends StatefulWidget {
  const MyGarden({Key? key}) : super(key: key);

  @override
  State<MyGarden> createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  bool isLoading = false;
  final _headerStyle =  GoogleFonts.sourceSansPro(
      color: const Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.bold);
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  TextEditingController nameController = TextEditingController();
  List<String> imagesPaths = [];
  List<XFile>_imagesXfile=[];
   BitkyDataModel _bitkyDataModel = BitkyDataModel();
  List<String> base64ImgList = [];




  _addFromGallery(String title, String id){
    _addImageFromGallery().whenComplete(() {
      setState(() {
        isLoading = true;
      });
      if(base64ImgList.isNotEmpty){
        _bitkyViewModel!.plantIdentifyFromUi(base64ImgList).then((value) {
          _bitkyDataModel = value;
        }).then((value) {
          base64ImgList.clear();
          showDialog(context: context, builder: (ctx){
            nameController.text = _bitkyDataModel.suggestions![0].plantDetails!.commonNames![0].toString().toCapitalized();

            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              title:Center(child: Text(title)) ,
              content:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    elevation: 4,
                    child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: kPrymaryColor,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          image:  DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(_bitkyDataModel.images![0].url!.toString())
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 5,),
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
                  const SizedBox(height: 5,),
                  CustomPrimaryButton(
                    text: AppLocalizations.of(context)!.save,
                    radius: 15,
                    function:(){
                      formValidation(context,id,title,_bitkyDataModel.images![0].url!.toString());
                    },
                  ),
                ],
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
      }

    });
  }

  Future<void> formValidation(BuildContext context, String id, String title, String url) async {
    final plantId = UniqueKey().hashCode;

    if (nameController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("users/${authUser.currentUser!.uid}/gardens")
          .doc(id).collection(title).doc(plantId.toString())
          .set({
        "plantName": nameController.text.toCapitalized().trim(),
        "plantId": plantId,
        "location": title,
        "reminder":false,
        "image": url,
        "createDate": DateTime.now()
      }).whenComplete(() {
        showDialog(
            context: context,
            builder: (c) {
              return CustomErrorDialog(
                message: AppLocalizations.of(context)!.addplantmessage,
              );
            }).whenComplete(() =>   Navigator.of(context, rootNavigator: true).pop("Discard")
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
  }

  _addFromCamera(String title, String id){
    _imagePickerSourceCamera().whenComplete(() {
      setState(() {
        isLoading = true;
      });
      if(base64ImgList.isNotEmpty){
        _bitkyViewModel!.plantIdentifyFromUi(base64ImgList).then((value) {
          _bitkyDataModel = value;
        }).then((value) {
          base64ImgList.clear();
          showDialog(context: context, builder: (ctx){
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 0,
              title:Center(child: Text(title)) ,
              content:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    elevation: 4,
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        imageUrl: _bitkyDataModel.images![0].url!.toString(),
                        placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        fadeOutDuration: const Duration(seconds: 1),
                        fadeInDuration: const Duration(seconds: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
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
                  const SizedBox(height: 5,),
                  CustomPrimaryButton(
                    text: AppLocalizations.of(context)!.save,
                    radius: 15,
                    function:(){
                      formValidation(context,id,title,_bitkyDataModel.images![0].url!.toString());
                    },
                  ),
                ],
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

      }

    });
  }
  openImages(String title, String id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
            title:  Center(
                child: Text(
                  AppLocalizations.of(context)!.addpicture,
                )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kPrymaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: kPrymaryColor,
                    ),
                    onPressed: () {
                      _addFromCamera(title,id);
                      Navigator.pop(context);
                    },
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kPrymaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: const Icon(
                      Icons.photo_library_outlined,
                      color: kPrymaryColor,
                    ),
                    onPressed: () {
                      _addFromGallery(title, id);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future _addImageFromGallery() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(imageQuality: 90);
      if(pickedfiles.length>5){
        showDialog(context: context, builder: (context){
          return AlertDialog(content: Text(AppLocalizations.of(context)!.addpictureerror),);
        });
      }else{
        if (pickedfiles.isNotEmpty) {
          imagefiles = pickedfiles;
          pickedfiles.forEach((element) async {
            imagesPaths.add(element.path);
          });
          for (var element in pickedfiles) {
            var bytes = await element.readAsBytes();
            var base64img = base64Encode(bytes);
            base64ImgList.add(base64img);
          }
          setState(() {});
          //  print("GALLERYYYY: " + base64ImgList.length.toString());
        } else {
          // print("No image is selected.");
        }
      }

    } catch (e) {
      // print("error while picking file.");
    }
  }

  Future _imagePickerSourceCamera() async {
    try {
      XFile? photos = await imgpicker.pickImage(
          source: ImageSource.camera, imageQuality: 90);
      if (photos != null) {
        var bytes = await photos.readAsBytes();
        var base64img = base64Encode(bytes);
        imagesPaths.add(photos.path);
        base64ImgList.add(base64img);
      }
      setState(() {});
    } catch (e) {
    }
  }


  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/plant1.png'),alignment: Alignment.bottomCenter),
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.mygardentitle,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  /*  IconButton(
                        onPressed: (){
                          showSearch(context: context,
                              delegate: SearchDelegatee());
                        },
                        icon: const Icon(Icons.search_sharp))*/
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              isLoading == true
                  ? Center(
                  child: SizedBox(
                    child: Padding(
                      padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CupertinoActivityIndicator(
                          ),
                          WavyAnimatedTextKit(
                            textStyle: GoogleFonts.sourceSansPro(
                                fontSize: 18),
                            text: [AppLocalizations.of(context)!.plswait],
                            isRepeatingAnimation: true,
                            speed: const Duration(milliseconds: 150),
                          ),
                        ],
                      ),
                    ),
                  ))
                  : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users/${authUser.currentUser!.uid}/gardens')
                      .orderBy("createDate", descending: true)
                      .snapshots(),
                  builder: (ctx, recentSnapshot) {
                    if(recentSnapshot.connectionState == ConnectionState.waiting){
                      return const CupertinoActivityIndicator(color: Colors.transparent,);
                    }else if(recentSnapshot.data!.docs.isEmpty){
                      return Padding(
                        padding: EdgeInsets.only(top:MediaQuery.of(context).size.height/3  ),
                        child:  Center(
                          child: Text(AppLocalizations.of(context)!.youdonthaveanyroomyet, style: GoogleFonts.sourceSansPro(),),
                        ),
                      );
                    }
                    final recentDocs = recentSnapshot.data!.docs;
                    return Expanded(
                      child: FutureBuilder(
                        builder: (context, futureSnapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: recentDocs.length,
                              itemBuilder: (context, index) {
                                var date = DateTime.now().day - DateTime.parse(recentDocs[index]["createDate"].toDate().toString()).day;
                                return Accordion(
                                  maxOpenSections: 2,
                                  headerBackgroundColorOpened: Colors.black54,
                                  scaleWhenAnimating: true,
                                  openAndCloseAnimation: true,
                                  headerPadding:
                                  const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                                  sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                                  sectionClosingHapticFeedback: SectionHapticFeedback.light,
                                  children: [
                                    AccordionSection(
                                      isOpen: false,
                                      leftIcon: const Icon(CupertinoIcons.leaf_arrow_circlepath, color: Colors.white),
                                      headerBackgroundColor: Colors.black54,
                                      headerBackgroundColorOpened: kPrymaryColor,
                                      header: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(recentDocs[index]["roomName"], style: _headerStyle),
                                          IconButton(onPressed: (){
                                            openImages(recentDocs[index]["roomName"],recentDocs[index]["roomId"].toString());
                                          }, icon: const Icon(Icons.add, color: Colors.white, )),
                                        ],
                                      ),
                                      content: PlantItemWidget(roomName: recentDocs[index]["roomName"], roomId:  recentDocs[index]["roomId"],),
                                      contentHorizontalPadding: 5,
                                      contentBorderWidth: 1,

                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                    );
                  }),
            ],
          ),
        ) ,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: FloatingActionButton(
          backgroundColor: kPrymaryColor,
          onPressed: (){
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: AddRoomWidget(),
              withNavBar: false,
              pageTransitionAnimation:PageTransitionAnimation.cupertino,
            );
          },
          child: const Icon(Icons.add,color: Colors.white,),
        ),
      ),
    );

  }
}
/*
* DataTable(
                                        sortAscending: true,
                                        sortColumnIndex: 1,
                                        dataRowHeight: 40,
                                        showBottomBorder: false,
                                        columns: [
                                          DataColumn(
                                              label: Text('Image', style: _contentStyleHeader),
                                              numeric: true),
                                          DataColumn(
                                              label: Text('Plant Name', style: _contentStyleHeader)),
                                          DataColumn(
                                              label: Text('Action', style: _contentStyleHeader),
                                              numeric: true),
                                        ],
                                        rows:[

                                        ],
                                      )*/