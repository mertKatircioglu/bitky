import 'dart:convert';
import 'dart:io';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/widgets/add_room_widgets/add_room.dart';
import 'package:bitky/widgets/add_room_widgets/plant_item_widget.dart';
import 'package:bitky/widgets/my_garden_widgets/current_weather_info.dart';
import 'package:bitky/widgets/my_garden_widgets/future_weather_info_widget.dart';
import 'package:bitky/widgets/my_garden_widgets/user_info_widget.dart';
import 'package:bitky/widgets/primary_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../models/bitky_data_model.dart';
import '../models/weather_data_model.dart';
import '../restart_app.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/add_manuel_plant_wdiget.dart';
import '../widgets/custom_error_dialog.dart';

class MyGarden extends StatefulWidget {
  WeatherDataModel? dataModel;

  MyGarden({Key? key, this.dataModel}) : super(key: key);

  @override
  State<MyGarden> createState() => _MyGardenState();
}

class _MyGardenState extends State<MyGarden> {
  bool isLoading = false;
  final _headerStyle = GoogleFonts.sourceSansPro(
      color: const Color(0xffffffff),
      fontSize: 15,
      fontWeight: FontWeight.bold);
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  TextEditingController nameController = TextEditingController();
  List<String> imagesPaths = [];
  BitkyDataModel _bitkyDataModel = BitkyDataModel();
  List<String> base64ImgList = [];

  _addFromGallery(String title, String id) {
    _addImageFromGallery().whenComplete(() {
      setState(() {
        isLoading = true;
      });
      if (base64ImgList.isNotEmpty) {
        _bitkyViewModel!.plantIdentifyFromUi(base64ImgList).then((value) {
          _bitkyDataModel = value;
        }).then((value) {
          base64ImgList.clear();
          showDialog(
              context: context,
              builder: (ctx) {
                nameController.text = _bitkyDataModel
                    .suggestions![0].plantDetails!.commonNames![0]
                    .toString()
                    .toCapitalized();

                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  title: Center(child: Text(title)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
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
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_bitkyDataModel
                                      .images![0].url!
                                      .toString())),
                            )),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DottedBorder(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        strokeCap: StrokeCap.butt,
                        color: kPrymaryColor,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.plantname),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomPrimaryButton(
                        text: AppLocalizations.of(context)!.save,
                        radius: 15,
                        function: () {
                          formValidation(context, id, title,
                              _bitkyDataModel.images![0].url!.toString());
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
      } else {
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
          .doc(id)
          .collection(title)
          .doc(plantId.toString())
          .set({
        "plantName": nameController.text.toCapitalized().trim(),
        "plantId": plantId,
        "reminderIsActive": false,
        "location": title,
        "image": url,
        "createDate": DateTime.now()
      }).whenComplete(() {
        showDialog(
                context: context,
                builder: (c) {
                  return CustomErrorDialog(
                    message: AppLocalizations.of(context)!.addplantmessage,
                  );
                })
            .whenComplete(() =>
                Navigator.of(context, rootNavigator: true).pop("Discard"));
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
  _addFromCamera(String title, String id) {
    _imagePickerSourceCamera().whenComplete(() {
      setState(() {
        isLoading = true;
      });
      if (base64ImgList.isNotEmpty) {
        _bitkyViewModel!.plantIdentifyFromUi(base64ImgList).then((value) {
          _bitkyDataModel = value;
        }).then((value) {
          base64ImgList.clear();
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  title: Center(child: Text(title)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            height: 120,
                            width: 120,
                            fit: BoxFit.cover,
                            imageUrl:
                                _bitkyDataModel.images![0].url!.toString(),
                            placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fadeOutDuration: const Duration(seconds: 1),
                            fadeInDuration: const Duration(seconds: 2),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DottedBorder(
                        padding: const EdgeInsets.only(right: 5, left: 5),
                        strokeCap: StrokeCap.butt,
                        color: kPrymaryColor,
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  AppLocalizations.of(context)!.plantname),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomPrimaryButton(
                        text: AppLocalizations.of(context)!.save,
                        radius: 15,
                        function: () {
                          formValidation(context, id, title,
                              _bitkyDataModel.images![0].url!.toString());
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
      } else {
        setState(() {
          isLoading = false;
        });
      }
    });
  }
  openImages(BuildContext context, String title, String id) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
            title: Center(
                child: Text(
              AppLocalizations.of(context)!.addpicture,
              style: GoogleFonts.sourceSansPro(),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kPrymaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () {
                        _addFromCamera(title, id);
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            color: kPrymaryColor,
                          ),
                          Text(
                            AppLocalizations.of(context)!.camera,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSansPro(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kPrymaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: () async {
                      Future.delayed(const Duration(seconds: 0), () {
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: "go",
                          pageBuilder: (ctx, a1, a2) {
                            return Container();
                          },
                          transitionBuilder: (ctx, a1, a2, child) {
                            var curve = Curves.easeInOut.transform(a1.value);
                            return Transform.scale(
                              scale: curve,
                              child: AlertDialog(
                                contentPadding: const EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 0,
                                content: AddPlantManuelWidget(
                                  roomId: id,
                                  roomName: title,
                                ),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 300),
                        );
                      });

                      Navigator.of(context, rootNavigator: true).pop("Discard");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add,
                            color: kPrymaryColor,
                          ),
                          Text(
                            "Manuel",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSansPro(fontSize: 11),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kPrymaryColor, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: InkWell(
                      onTap: () {
                        _addFromGallery(title, id);
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            color: kPrymaryColor,
                          ),
                          Text(
                            AppLocalizations.of(context)!.gallery,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSansPro(fontSize: 11),
                          )
                        ],
                      ),
                    ),
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
      if (pickedfiles.length > 5) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(AppLocalizations.of(context)!.addpictureerror),
              );
            });
      } else {
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
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: widget.dataModel!.current!.isDay == 0? ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.dstATop):null,
              image: AssetImage(
                widget.dataModel!.current!.isDay == 0
                    ? 'images/night.png'
                    : 'images/day.png',
              ),
              alignment: Alignment.center),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 15,),
                   UserInfoWidget(day: widget.dataModel!.current!.isDay,),
                  const SizedBox(height: 5,),
                  CurrentWeatherInfoWidget(dataModel: widget.dataModel,),
                  FutureWeatherInfoWidget(dataModel: widget.dataModel,),
                  const SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            AppLocalizations.of(context)!.mygardentitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.sourceSansPro(
                                color: widget.dataModel!.current!.isDay == 0
                                    ? Colors.white
                                    : Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: (){
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: AddRoomWidget(),
                              withNavBar: false,
                              pageTransitionAnimation: PageTransitionAnimation.cupertino,
                            );
                          },
                          child:  Icon(Icons.add_home, size: 30,color:  widget.dataModel!.current!.isDay == 0
                              ? Colors.white
                              : Colors.black87,),
                        )
                      ],
                    ),
                  ),
                  isLoading == true
                      ? Center(
                          child: SizedBox(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 3),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CupertinoActivityIndicator(),
                                WavyAnimatedTextKit(
                                  textStyle:
                                      GoogleFonts.sourceSansPro(fontSize: 18),
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
                              .collection(
                                  'users/${authUser.currentUser!.uid}/gardens')
                              .orderBy("createDate", descending: true)
                              .snapshots(),
                          builder: (ctx, recentSnapshot) {
                            if (recentSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CupertinoActivityIndicator(
                                color: Colors.transparent,
                              );
                            } else if (recentSnapshot.data==null) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.height / 3),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .youdonthaveanyroomyet,
                                    style: GoogleFonts.sourceSansPro(
                                        color: Colors.black54),
                                  ),
                                ),
                              );
                            }
                            final recentDocs = recentSnapshot.data!.docs;
                            return FutureBuilder(
                              builder: (context, futureSnapshot) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: recentDocs.length,
                                    itemBuilder: (context, index) {
                                      var date = DateTime.now().day -
                                          DateTime.parse(recentDocs[index]
                                                      ["createDate"]
                                                  .toDate()
                                                  .toString())
                                              .day;
                                      return Accordion(
                                        paddingListBottom: 2.0,
                                        paddingListTop: 2.0,
                                        contentBackgroundColor: Colors.white24,
                                        contentBorderColor: Colors.transparent,
                                        disableScrolling: true,
                                        scrollIntoViewOfItems: ScrollIntoViewOfItems.fast,
                                        maxOpenSections: 5,
                                        headerBackgroundColorOpened:Colors.black54,
                                        scaleWhenAnimating: true,
                                        openAndCloseAnimation: true,
                                        headerPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 7, horizontal: 15),
                                        sectionOpeningHapticFeedback:
                                            SectionHapticFeedback.heavy,
                                        sectionClosingHapticFeedback:
                                            SectionHapticFeedback.light,
                                        children: [
                                          AccordionSection(
                                            isOpen: false,
                                            contentVerticalPadding: 2,
                                            leftIcon: const Icon(
                                                CupertinoIcons
                                                    .leaf_arrow_circlepath,
                                                color: Colors.white),
                                            headerBackgroundColor:
                                                Colors.black54,
                                            headerBackgroundColorOpened:
                                                Colors.black54,
                                            header: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    recentDocs[index]
                                                        ["roomName"],
                                                    style: _headerStyle),
                                                IconButton(
                                                    onPressed: () {
                                                      openImages(
                                                          context,
                                                          recentDocs[index]
                                                              ["roomName"],
                                                          recentDocs[index]
                                                                  ["roomId"]
                                                              .toString());
                                                    },
                                                    icon: const Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                            content: PlantItemWidget(
                                              roomName: recentDocs[index]
                                                  ["roomName"],
                                              roomId: recentDocs[index]
                                                  ["roomId"],
                                            ),
                                            contentHorizontalPadding: 0,
                                          ),
                                        ],
                                      );
                                    });
                              },
                            );
                          }),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      authUser.signOut();
                      SystemNavigator.pop();
                    },
                    child: Container(
                        margin: const EdgeInsets.all(3.0),
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white)
                        ),
                        child: Text(AppLocalizations.of(context)!.logoutt, style:GoogleFonts.sourceSansPro(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ))),
                  ),
                  const SizedBox(height: 50,),

                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}
