
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/bitky_data_model.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:bitky/screens/identify_result_screen.dart';
import 'package:bitky/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../view_models/planet_view_model.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[50]!;
    paint.style = PaintingStyle.fill; // Change this to fill
    var path = Path();
    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height / 1.10, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Search extends StatefulWidget {
  WeatherDataModel? dataModel;
  Search({Key? key, this.dataModel}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  Timer? _timer;
  int _start = 8;
  List<String> imagesPaths = [];
  List<XFile>_imagesXfile=[];
  BitkyDataModel _bitkyDataModel = BitkyDataModel();
  bool isLoading = false;
  List<String> base64ImgList = [];
  bool messageShow = true;


  showMessage() async{
    Future.delayed(const Duration(milliseconds: 8000)).whenComplete(() {
      setState(() {
        messageShow = false;
      });
    });
  }

  openImages() async {
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

  Future _addImageFromCamera() async {
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

  @override
  void initState() {
    super.initState();
    showMessage();
    startTimer();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    imagefiles!.clear();
    _bitkyViewModel = BitkyViewModel();
    imagesPaths.clear();
    _bitkyDataModel = BitkyDataModel();
    base64ImgList.clear();
    isLoading = false;
    isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
   /*     image: DecorationImage(
            image: AssetImage('images/bt_banner.png'),alignment: Alignment.bottomCenter),*/
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
      child: Column(
          children: [
            CustomAppBarWidget(dataModel: widget.dataModel,),
            const SizedBox(height: 20,),
            Visibility(
              visible:messageShow == true ? false: true,
              child: InkWell(
                onTap: (){
                  setState(() {
                    messageShow = true;
                  });
                },
                child: const Icon(Icons.info_rounded, size:25
                  ,color: kPrymaryColor,),),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: AnimatedOpacity(
                opacity: messageShow ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 900),
                child: Container(
                  decoration:  BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  padding: const EdgeInsets.all(12.00),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.searchpagesubtitle,
                        style: GoogleFonts.sourceSansPro(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54
                        ),),
                      Text(
                        AppLocalizations.of(context)!.searchpagesubtitle2,
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

            const SizedBox(
              height: 0,
            ),
           /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Card(
                elevation: 10,
                shadowColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: TextField(
                  onSubmitted: (val){
                  },
                  decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.search,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      hintStyle: const TextStyle(color: Colors.grey),
                      hintText: AppLocalizations.of(context)!.typeaplantname,
                      fillColor: Colors.white70),
                ),
              ),
            ),*/
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              height: 80,
              child: Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                children: List.generate(
                    (imagesPaths.isNotEmpty ? imagesPaths.length : 0),
                        (index) {
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
                                      _imagesXfile.removeAt(index);
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
                            icon: const Icon(
                              Icons.add,
                              color: kPrymaryColor,
                            ),
                            onPressed: () {
                              openImages();
                            },
                          ),
                        );
                      }
                    }),
              ),
            ),
            Visibility(
              visible: imagesPaths.length >= 5 ? false : true,
              child: InkWell(
                onTap: (){
                  openImages();
                },
                child: Center(
                  child:Card(
                    elevation: 5,
                    shadowColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(70)
                    ),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(70),
                        gradient: const LinearGradient(colors: [Color(0xfff4FE58A),Color(0xfff19C179)]),
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 50,),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            (isLoading == true)
                ? Column(
              children: [
                const SizedBox(height: 20,),
                const CupertinoActivityIndicator(),
                SizedBox(
                  child: WavyAnimatedTextKit(
                    textStyle: GoogleFonts.sourceSansPro(
                        fontSize: 18,

                    ),
                    text:  [
                      AppLocalizations.of(context)!.plswait
                    ],
                    isRepeatingAnimation: true,
                    speed: const Duration(milliseconds: 150),
                  ),
                ),
              ],
            )
                :Visibility(
              visible: imagesPaths.isNotEmpty,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  _bitkyViewModel!
                      .plantIdentifyFromUi(base64ImgList).timeout(const Duration(seconds: 120),
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
                  ).then((value) {
                    _bitkyDataModel = value;
                  }).whenComplete(() {
                    base64ImgList.clear();
                    imagesPaths.clear();
                    if(_bitkyDataModel.id !=null){
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: IdentifyResultScreen(dataModel: _bitkyDataModel,),
                        withNavBar: false,
                        pageTransitionAnimation:PageTransitionAnimation.cupertino,
                      );
                    }
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
            ),
          ],
        ),

    );
  }
}
