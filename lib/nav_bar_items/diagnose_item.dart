import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../globals/globals.dart';
import '../view_models/planet_view_model.dart';
import '../widgets/primary_button_widget.dart';
import '../widgets/settings_button_widget.dart';

class DiagnosePage extends StatefulWidget {
  const DiagnosePage({Key? key}) : super(key: key);

  @override
  State<DiagnosePage> createState() => _DiagnosePageState();
}

class _DiagnosePageState extends State<DiagnosePage> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  List? _response = [];
  List<String> imagesPaths = [];
  HealthDataModel _diseases = HealthDataModel();
  List<String> base64ImgList = [];
  List<Diseases> _diseasesList = [];
  bool isLoading = false;

  List<String> commonsList = [
    "Deneme1",
    "Deneme2",
    "Deneme3",
    "Deneme4",
    "Deneme5",
    "Deneme6",
    "Deneme7",
    "Deneme8",
  ];

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
        print("GALLERYYYY: " + base64ImgList.length.toString());
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
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

        print("SAYIIII: " + base64ImgList.length.toString());
      }
      setState(() {});

      print("AKMERAAA: " + imagefiles!.length.toString());
    } catch (e) {
      print("error while picking file.");
    }
  }

/*
  Future commonsHealth() async {
    const finalUrl = "https://api.plant.id/v2/health_assessment";
    Map<String, String> requestHeaders = {
      'Api-Key': '0fcD9Gc8MZchH729J2YmWqjCEtIu2LPmCx5lAG7zOjHUB0O4IP',
      'content-type': 'application/json',
    };

    var request = http.post(Uri.parse(finalUrl), headers: requestHeaders);

    print(request.toString());
    var res = await request;
    //  final response = await http.Response.fromStream(request);

    final responseJson = (jsonDecode(res.body));
    if(res.statusCode == 200){
      debugPrint("SORGUDAN GELEN CEVAP**********: ${responseJson.toString()}", wrapWidth: 1024);
      return HealthDataModel.fromJson(responseJson);
    }else{
      throw Exception("Veri getirelemedi");
    }

  }
*/


  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
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
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Diagnose',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                CustomSettingsButton(),
              ],
            ),
            const SizedBox(
              height: 40,
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
                    height: 10,
                  ),
                  const Text("Identify a plant problem"),
                  const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: imagesPaths.length >= 5 ? false : true,
                    child: CustomPrimaryButton(
                      text: "Take a photo",
                      function: () {
                        openImages();
                      },
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
                          (imagesPaths.isNotEmpty ? imagesPaths.length : 5),
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
                              icon: Icon(
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
                  /*Visibility(
                  visible: imagefiles != null ? true : false,
                  child: TextButton(
                      onPressed: (){
                        _bitkyViewModel!.getPlanetFromUi(imagefiles!).whenComplete(() {
                          setState(() {
                            datasContainer = true;
                          });
                          _response = _bitkyViewModel!.getPlanet.results!;
                          bestMatch = _bitkyViewModel!.getPlanet.bestMatch;

                        });

                      },child: Text((_bitkyViewModel!.state == DataState.loadingState) ? "Bilgiler getiriliyor..." :
                  (_bitkyViewModel!.state == DataState.loadedState) ?"Tekrar Sorgula": "Sorgula" ))),
              (_bitkyViewModel!.state == DataState.loadedState) ? getDatas(context) :
              (_bitkyViewModel!.state == DataState.loadingState) ? const Center(child: CupertinoActivityIndicator(),):
              (_bitkyViewModel!.state == DataState.errorState) ? const Center(child: Text("Bir Hata Meydana Geldi"),) : Container(),*/
                  Visibility(
                    visible: imagesPaths.length > 0 ? true : false,
                    child: Column(
                      children: [
                        imagesPaths.length > 0
                            ? Container(
                                height: 10,
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
                                .getPlantHealthFromUi(base64ImgList)
                                .then((value) {
                              _diseases = value;
                            }).whenComplete(() {
                              print(_diseases.isPlantProbability);

                              // print("GGGGGGGGGGGGG:    "+_response!.length.toString());
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
                      ],
                    ),
                  ),
                    const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.access_time_outlined,
                        color: kPrymaryColor,
                        size: 15,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Recent Snaps",
                        style: TextStyle(
                            color: kPrymaryColor, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ],
              ),
            ),

            (isLoading == true)
                ? Column(
                    children: const [
                      Center(child: CupertinoActivityIndicator()),
                      SizedBox(
                        height: 150,
                      )
                    ],
                  )
                : Container(),
            Visibility(
              visible: _diseases.id !=null,
              child: Expanded(
                  child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: [
                    Expanded(
                child: Container(
                padding:const EdgeInsets.all(12),
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
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               const Text("is healty: ", style: TextStyle(color: kPrymaryColor),),
                                Image.asset(_diseases.id !=null?_diseases.healthAssessment!.isHealthy == true?
                                "images/smile.png":"images/sad.png":"images/sad.png", width: 20,height: 20,)
                              ],
                            ),
                            const SizedBox(height: 3,),
                            const Divider(height: 0.2, color: Colors.deepOrange,)
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
                        children: const [
                          Text(
                            "Common problems",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          InkWell(
                              child: Text(
                            'See all',
                            style: TextStyle(color: kPrymaryColor),
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
                              itemCount:_diseases.id !=null ? _diseases.healthAssessment!.diseases!.length:0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (ctx, index) {
                                return InkWell(
                                  onTap: () {},
                                  child: Card(
                                    shadowColor: kPrymaryColor,
                                    elevation: 0.5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                       /*   Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0,
                                                right: 2.0,
                                                top: 1.0,
                                                bottom: 3.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(15),
                                                        topLeft:
                                                            Radius.circular(15)),
                                                child: _response![index] == null
                                                    ? Image.asset(
                                                        "images/leaf.png",
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover)
                                                    : Image.network(
                                                        _response![index],
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover,
                                                      )),
                                          ),*/
                                          Text(
                                            _diseases.healthAssessment!.diseases![index].name.toString(),
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
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
              height: 25,
            )
          ],
        ),
      ),
    );
  }

/*
  Visibility getDatas(BuildContext context) {
    return Visibility(
      visible: datasContainer!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: datasContainer == true
            ? Column(
                children: [
                  Text(
                    "En İyi Eşleşme: ${bestMatch!}",
                    style: const TextStyle(
                        color: Colors.pinkAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    height: 10,
                    color: Colors.amber,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Diğer Sonuçlar"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                        itemCount: _bitkyViewModel!.getPlanet.results!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "İsim: ${_response[index].species.commonNames.toString().replaceAll("]", " ").replaceAll("[", "")}"),
                                    Row(
                                      children: [
                                        const Text("Benzerlik: "),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          height: 7,
                                          width: _response[index].score * 100.2,
                                        ),
                                        Text(
                                          "% ${_response[index].score.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(
                                        "Bilimsel Adı: ${_response[index].species.scientificName}"),
                                    Text(
                                        "Familya: ${_response[index].species.family.scientificNameWithoutAuthor}"),
                                    Text(
                                        "Ortak İsmi: ${_response[index].species.commonNames.toString().replaceAll("]", " ").replaceAll("[", "")}"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
*/
}
