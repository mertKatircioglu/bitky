import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/main.dart';
import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:bitky/screens/recent_snaps.dart';
import 'package:bitky/screens/see_all_screen.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:bitky/widgets/diagnose_solution_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../globals/globals.dart';
import '../l10n/app_localizations.dart';
import '../models/weather_data_model.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/primary_button_widget.dart';

class DiagnosePage extends StatefulWidget {
  WeatherDataModel? dataModel;
   DiagnosePage({Key? key, this.dataModel}) : super(key: key);

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
  bool messageShow = true;
  List<String> responseImages = [];
  Timer? _timer;
  int _start = 8;
  bool visibleInfo = true;

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    imagefiles!.clear();
    _bitkyViewModel = BitkyViewModel();
     imagesPaths.clear();
  _diseases = HealthDataModel();
    base64ImgList.clear();
   isLoading = false;
    responseImages.clear();
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
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
                      _addImageFromCamera().whenComplete(() {
                        setState(() {
                          isLoading = true;
                        });
                        _bitkyViewModel!
                            .getPlantHealthFromUi(base64ImgList, context).timeout(const Duration(seconds: 120),
                          onTimeout: ()async{
                            setState(() {
                              isLoading = false;
                            });
                            return await showDialog(context: navigatorKey.currentContext!,
                                builder: (context){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    content:
                                    Text(AppLocalizations.of(context)!.connectiontimeout,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.sourceSansPro(),),

                                  );
                                });

                          },
                        )
                            .then((value) {
                          _diseases = value;
                        }).whenComplete(() {
                          List<String> disasNames =[];
                          if(_diseases.healthAssessment !=null){
                            _diseases.healthAssessment!.diseases!.forEach((element) {
                              disasNames.add(element.name!);
                              responseImages.add(element.similarImages![0].url.toString());
                              //print("AÇIKLAMAAA: "+element.diseaseDetails!.toJson().toString());
                            });
                            // print(responseImages.toString());
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
                          }else{

                            setState(() {
                              isLoading = false;
                            });
                          }
                        });
                      });
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
                      _addImageFromGallery().whenComplete(() {
                        setState(() {
                          isLoading = true;
                        });
                          _bitkyViewModel!
                              .getPlantHealthFromUi(base64ImgList, context).timeout(const Duration(seconds: 120),
                            onTimeout: ()async{
                              setState(() {
                                isLoading = false;
                              });
                              return await showDialog(context: navigatorKey.currentContext!,
                                  builder: (context){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    content:
                                  Text(AppLocalizations.of(context)!.connectiontimeout,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.sourceSansPro(),),

                                  );
                                });

                            },
                          )
                              .then((value) {
                            _diseases = value;
                          }).whenComplete(() {

                            List<String> disasNames =[];
                            if(_diseases.healthAssessment !=null){
                              _diseases.healthAssessment!.diseases!.forEach((element) {
                                disasNames.add(element.name!);
                                responseImages.add(element.similarImages![0].url.toString());
                                //print("AÇIKLAMAAA: "+element.diseaseDetails!.toJson().toString());
                              });
                              // print(responseImages.toString());
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
                            }else{

                              setState(() {
                                isLoading = false;
                              });
                            }

                          });
                        });
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

  Widget _dialog(BuildContext context,String title, String url, List<String>bio, List<String>pre ){
    return AlertDialog(
      contentPadding:const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)),
      elevation: 0,
      content: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(15))),
          child:  DiagnoseSolutionItemWidget(title: title, imgUrl: url, biological: bio, prevention: pre,),
        ),
      ),

    );
  }

  void _scaleDialog(Widget dialog) {
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
          child:dialog,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  showMessage() async{
    Future.delayed(const Duration(milliseconds: 8000)).whenComplete(() {
      setState(() {
        messageShow = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    showMessage();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return  Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image:  AssetImage(widget.dataModel!.current!.isDay==0?'images/night.png':'images/day.png',),alignment: Alignment.bottomCenter),
      ),
      child: Column(
        children: [
          CustomAppBarWidget(dataModel: widget.dataModel,),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible:messageShow == true ? false: true,
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          messageShow = true;
                        });
                      },
                      child: const Icon(Icons.info_rounded, size:25
                        ,color: Colors.white,),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
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
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: AnimatedOpacity(
                      opacity: messageShow ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 900),
                      child: Visibility(
                        visible: visibleInfo,
                        child: Container(
                          decoration:  BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(20.0)
                          ),
                          padding: const EdgeInsets.all(12.00),
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.diagnosesubtitle,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54
                                ),),
                              Text(
                                AppLocalizations.of(context)!.diagnosesubtitle2,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.sourceSansPro(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54
                                ),),
                              Text(_start == 0 ? "" :_start.toString(),style: GoogleFonts.sourceSansPro())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: imagesPaths.length >= 5 ? false : true,
                    child: Container(
                      width: MediaQuery.of(context).size.width /1.5,
                      child: CustomPrimaryButton(
                        text: AppLocalizations.of(context)!.takeaphotobutton,
                        radius: 15.0,
                        function: () {
                          visibleInfo = false;
                          openImages();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                    child: const Icon(
                      Icons.access_time_outlined,
                      color: kPrymaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: List.generate(
                          (imagesPaths.length < 1 ? 1 : imagesPaths.length), (index) {
                        if (imagesPaths.isNotEmpty) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: kPrymaryColor, width: 1.0)),
                            elevation: 0,
                            color: Colors.transparent,
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              File(imagesPaths[index]),
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
               (isLoading == true)
              ? Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const CupertinoActivityIndicator(),
              SizedBox(
                child: WavyAnimatedTextKit(
                  textStyle: GoogleFonts.sourceSansPro(
                    fontSize: 18,
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
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.only(left: 50.0,right: 50.0),
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_diseases.id !=null?_diseases.healthAssessment!.isHealthy == false?
                            AppLocalizations.of(context)!.nothealthy : AppLocalizations.of(context)!.yourplantishealty : AppLocalizations.of(context)!.nothealthy, style: GoogleFonts.sourceSansPro(color: kPrymaryColor),),
                            const SizedBox(height: 5,),
                            Image.asset(_diseases.id !=null?_diseases.healthAssessment!.isHealthy == true?
                            "images/smile.png":"images/sad.png":"images/sad.png", width: 20,height: 20,),
                            const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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

                                      if(_diseases.healthAssessment!.diseases![index].diseaseDetails!.treatment!.prevention != null
                                      ){
                                        _scaleDialog(_dialog(context,
                                            _diseases.healthAssessment!.diseases![index].name.toString(),
                                            responseImages[index].toString(),
                                            _diseases.healthAssessment!.diseases![index].diseaseDetails!.treatment!.biological!,
                                            _diseases.healthAssessment!.diseases![index].diseaseDetails!.treatment!.prevention!
                                        ));
                                      }else{
                                        final imageProvider = Image.network(responseImages[index]).image;
                                        showImageViewer(context, imageProvider, onViewerDismissed: () {
                                          print("dismissed");
                                        });
                                      }

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
                                                  "${AppLocalizations.of(context)!.similarity}: %${_diseases.healthAssessment!.diseases![index].
                                                  probability!.toStringAsFixed(2).substring(2).toString()}",
                                                  textAlign: TextAlign.center,
                                                  style:  GoogleFonts.sourceSansPro(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),

                                              _diseases.healthAssessment!.diseases![index].diseaseDetails!.treatment!.prevention != null ?  Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: SizedBox(
                                                    height: 35,
                                                    width: 35,
                                                    child: Lottie.asset("images/info.json"),
                                                  )):Container(),
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

    );
  }
  
}
