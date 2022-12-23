
import 'dart:convert';
import 'dart:io';

import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/bitky_data_model.dart';
import 'package:bitky/screens/identify_result_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';


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
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  List? _response = [];
  List<String> imagesPaths = [];
  List<XFile>_imagesXfile=[];
  BitkyDataModel _bitkyDataModel = BitkyDataModel();
  bool isLoading = false;
  List<String> base64ImgList = [];


  openImages() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
            title: const Center(
                child: Text(
                  "Add Pictures",
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
      if (pickedfiles != null) {
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
      } else {
       // print("No image is selected.");
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

        //print("SAYIIII: " + base64ImgList.length.toString());
      }
      setState(() {});

     // print("AKMERAAA: " + imagefiles!.length.toString());
    } catch (e) {
     // print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: CurvePainter(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),

              const Text(
                "Find Perfect Plants & Veggies",
                style: TextStyle(
                    color: kPrymaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
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
                        hintText: "Type a plant name",
                        fillColor: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
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
              InkWell(
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

              const SizedBox(
                height: 10,
              ),
              (isLoading == true)
                  ? const Center(child: CupertinoActivityIndicator())
                  :Visibility(
                visible: imagesPaths.isNotEmpty,
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                    });
                    _bitkyViewModel!
                        .plantIdentifyFromUi(base64ImgList)
                        .then((value) {
                      _bitkyDataModel = value;
                    }).whenComplete(() {
                       //print("GGGGGGGGGGGGG:    "+_bitkyDataModel.bestMatch.toString());
                      base64ImgList.clear();
                      imagesPaths.clear();
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: IdentifyResultScreen(dataModel: _bitkyDataModel,),
                        withNavBar: false,
                        pageTransitionAnimation:PageTransitionAnimation.cupertino,
                      );
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search,
                        color: kPrymaryColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Search",
                        style: TextStyle(color: kPrymaryColor),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
