import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:bitky/screens/recent_snaps.dart';
import 'package:bitky/screens/see_all_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/primary_button_widget.dart';

class DiagnosePage extends StatefulWidget {
  const DiagnosePage({Key? key}) : super(key: key);

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles=[];
  BitkyViewModel? _bitkyViewModel;
  List<String> imagesPaths = [];
  HealthDataModel _diseases = HealthDataModel();
  List<String> base64ImgList = [];
  bool isLoading = false;
  List<String> responseImages = [];


  @override
  void dispose() {
    super.dispose();
    imagefiles!.clear();
    _bitkyViewModel = BitkyViewModel();
     imagesPaths.clear();
  _diseases = HealthDataModel();
    base64ImgList.clear();
   isLoading = false;
    responseImages.clear();
  }


  openImages() async {
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
                      _addImageFromCamera();
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
                      _addImageFromGallery();
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
          return  AlertDialog(content: Text(AppLocalizations.of(context)!.addpictureerror),);
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

  Future _addImageFromCamera() async {
    try {
      XFile? photos = await imgpicker.pickImage(source: ImageSource.camera, imageQuality: 90);
      if (photos != null) {
        var bytes = await photos.readAsBytes();
        var base64img = base64Encode(bytes);
        imagesPaths.add(photos.path);
        base64ImgList.add(base64img);
       // print("SAYIIII: " + base64ImgList.length.toString());
      }
      setState(() {});
      //print("AKMERAAA: " + imagefiles!.length.toString());
    } catch (e) {
      // print("error while picking file.");
    }
  }



  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/banner.png'),alignment: Alignment.topCenter),
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                 Text(
                   AppLocalizations.of(context)!.diagnosetitle,
                  style: GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Visibility(
                  visible:_diseases.id !=null,
                  child: InkWell(
                    onTap: (){
                      isLoading = true;
                  setState(() {
                    _diseases.id = null;
                    _diseases = HealthDataModel();
                    imagefiles!.clear();
                    base64ImgList.clear();
                    imagesPaths.clear();
                    responseImages.clear();
                    isLoading = false;
                   });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.clear, size:
                        15,color: kPrymaryColor,),
                        const SizedBox(width: 2,),
                        Text(AppLocalizations.of(context)!.clear, style: GoogleFonts.sourceSansPro(color: kPrymaryColor),)
                      ],),),
                )

              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "images/diognasPageTopIcons.png",
                    width: 80,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                   Text(AppLocalizations.of(context)!.diagnosesubtitle, style: GoogleFonts.sourceSansPro(fontSize: 18),),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: imagesPaths.length >= 5 ? false : true,
                    child: Container(
                      width: MediaQuery.of(context).size.width /1.5,
                      child: CustomPrimaryButton(
                        text: AppLocalizations.of(context)!.takeaphotobutton,
                        radius: 15.0,
                        function: () {
                          openImages();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: List.generate(
                          (imagesPaths.isNotEmpty ? imagesPaths.length : 5), (index) {
                            if (imagesPaths.isNotEmpty) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: kPrymaryColor, width: 1.0)),
                                elevation: 0,
                                color: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                child: Stack(
                                  children: <Widget>[
                                    Image.file(
                                      File(imagesPaths[index]),
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                    ),
                                    Positioned(
                                      right: 5,
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.remove_circle_rounded,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            imagesPaths.removeAt(index);
                                            base64ImgList.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: kPrymaryColor, width: 1.0),
                                    borderRadius: BorderRadius.circular(10)),
                                child: IconButton(
                                  icon:const Icon(
                                    Icons.add,
                                    color: kPrymaryColor,
                                  ),
                                  onPressed: () {
                                    openImages();
                                  },
                                ),
                              );
                            }
                          }
                          ),
                    ),
                  ),
                  Visibility(
                    visible: imagesPaths.length > 0 ? true : false,
                    child: Column(
                      children: [
                        imagesPaths.length > 0
                            ? Container(
                          height: 6,
                          width: imagesPaths.length * 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(colors: [
                                Colors.white54,
                                imagesPaths.length >= 1
                                    ? Colors.yellowAccent
                                    : Colors.white54,
                                imagesPaths.length > 2
                                    ? Colors.yellow
                                    : Colors.yellowAccent,
                                imagesPaths.length > 3
                                    ? Colors.yellow
                                    : Colors.yellow,
                                imagesPaths.length >= 4
                                    ? Colors.greenAccent
                                    : Colors.greenAccent,
                                imagesPaths.length >= 5
                                    ? Colors.green
                                    : Colors.greenAccent
                              ])),
                        )
                            : Container(),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            _bitkyViewModel!
                                .getPlantHealthFromUi(base64ImgList, context)
                                .then((value) {
                              _diseases = value;
                            }).whenComplete(() {
                             List<String> disasNames =[];
                              _diseases.healthAssessment!.diseases!.forEach((element) {
                                disasNames.add(element.name!);
                                responseImages.add(element.similarImages![0].url.toString());
                                //print("A??IKLAMAAA: "+element.diseaseDetails!.toJson().toString());
                              });
                             print(responseImages.toString());
                          FirebaseFirestore.instance.collection("users/${authUser.currentUser!.uid}/recent_search").doc(DateTime.now().toString()).
                              set({
                                "uploadedImages": _diseases.images!.map((e) => e.toJson()).toList(),
                                "problemName":disasNames,
                                "createdAt": DateTime.now(),
                                "isHealty":_diseases.healthAssessment!.isHealthy
                              });

                              // print("GGGGGGGGGGGGG:    "+_response!.length.toString());
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search,
                                color: kPrymaryColor,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!.searchtitle,
                                style: GoogleFonts.sourceSansPro(color: kPrymaryColor, fontSize: 22),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: (){
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: RecentSnapsScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        const Icon(
                          Icons.access_time_outlined,
                          color: kPrymaryColor,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)!.recentsnaps,
                          style: GoogleFonts.sourceSansPro(
                              color: kPrymaryColor, fontWeight: FontWeight.w500, fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            (isLoading == true)
                ? Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const CupertinoActivityIndicator(color: kPrymaryColor,),
                SizedBox(
                  child: WavyAnimatedTextKit(
                    textStyle: GoogleFonts.sourceSansPro(
                        fontSize: 18,
                        color: kPrymaryColor
                    ),
                    text: [
                      AppLocalizations.of(context)!.plswait
                    ],
                    isRepeatingAnimation: true,
                    speed: const Duration(milliseconds: 150),
                  ),
                ),

              ],
            )
                : Container(
              height: 0,
            ),
            Visibility(
              visible: _diseases.id !=null,
              child: Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding:const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 30),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(AppLocalizations.of(context)!.nothealthy, style: GoogleFonts.sourceSansPro(color: kPrymaryColor),),
                                    const SizedBox(height: 5,),
                                    Image.asset(_diseases.id !=null?_diseases.healthAssessment!.isHealthy == true?
                                    "images/smile.png":"images/sad.png":"images/sad.png", width: 50,height: 50,),
                                    const SizedBox(height: 5,),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  [
                              Text(
                                AppLocalizations.of(context)!.commonprolems,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: (){
                                  PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: SeeAllScreen(responseImages: responseImages, diseases: _diseases,),
                                    withNavBar: false,
                                    pageTransitionAnimation:PageTransitionAnimation.cupertino,
                                  );

                                },
                                  child: Text(
                                    AppLocalizations.of(context)!.seeall,
                                    style: GoogleFonts.sourceSansPro(color: kPrymaryColor),
                                  ))
                            ],
                          ),
                        ),
                        const Divider(color: kPrymaryColor),
                      Visibility(
                          visible: true,
                          child: Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:responseImages.length,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 1,
                                      mainAxisSpacing: 10),
                                  itemBuilder: (ctx, index) {
                                    return Bounce(
                                      duration: const Duration(milliseconds: 200),
                                      onPressed: () {
                                        final imageProvider = Image.network(responseImages[index]).image;
                                        showImageViewer(context, imageProvider, onViewerDismissed: () {
                                          print("dismissed");
                                        });
                                      },
                                      child: Card(
                                        shadowColor: kPrymaryColor,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15.0)),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15),
                                                child: Container(
                                                    decoration:  BoxDecoration(
                                                        image: DecorationImage(
                                                            fit: BoxFit.fill,
                                                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4), BlendMode.darken),
                                                            image: NetworkImage(responseImages[index].toString()))
                                                    ),

                                                )),

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    _diseases.healthAssessment!.diseases![index].name.toString().toCapitalized(),
                                                    textAlign: TextAlign.center,
                                                    style:  GoogleFonts.sourceSansPro(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "${AppLocalizations.of(context)!.similarity}: %${_diseases.healthAssessment!.diseases![index].similarImages![0].similarity.toString().substring(0,1)}0",
                                                    textAlign: TextAlign.center,
                                                    style:  GoogleFonts.sourceSansPro(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
  
}
