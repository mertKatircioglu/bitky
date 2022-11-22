
import 'dart:io';
import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/bitky_data_model.dart';
import 'package:bitky/view_models/planet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  BitkyViewModel? _bitkyViewModel;
  bool? datasContainer = false;
  List<Results> _response =[];
  List<String> imagesPaths= [];
  String? bestMatch;



  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(imageQuality: 90);
      if(pickedfiles != null){
        imagefiles = pickedfiles;
        pickedfiles.forEach((element) {
          imagesPaths.add(element.path);
        });
        print(imagesPaths.toString());
        setState(() {
        });

      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _bitkyViewModel = Provider.of<BitkyViewModel>(context);
    return Scaffold(
      backgroundColor: kBackGroundColor,
      appBar: AppBar(
        backgroundColor: kBackGroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Bitky", style: TextStyle(
          color: Colors.pinkAccent,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextButton(
                  onPressed: (){
                    imagesPaths.clear();
                    openImages();
                  },
                  child:const Text("Fotoğrafları Seç")
              ),
             const Divider(color: Colors.amber,),
              imagesPaths.isNotEmpty ?  Container(
                alignment: Alignment.center,
                height: 80,
                child:
                GridView.builder(
                      shrinkWrap: true,
                        itemCount: imagesPaths.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:5,),
                        itemBuilder: (context, index){
                          return Card(
                            color: kBackGroundColor,
                            elevation: 0,
                            child: Center(
                              child: imagesPaths.isNotEmpty ? Image.file(File(imagesPaths[index])): null,
                            ),
                          );
                        }),


              ) : Container() ,
              Visibility(
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
              (_bitkyViewModel!.state == DataState.errorState) ? const Center(child: Text("Bir Hata Meydana Geldi"),) : Container()
            ],
          ),
        ),
      ),
    );
  }

  Visibility getDatas(BuildContext context) {
    return Visibility(
                visible: datasContainer!,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child:
                      datasContainer == true ?
                      Column(
                        children: [
                        Text("En İyi Eşleşme: ${bestMatch!}", style:const TextStyle(
                          color: Colors.pinkAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                        ),),
                          const Divider(height: 10, color: Colors.amber,),
                          const SizedBox(height: 10,),
                          Text("Diğer Sonuçlar"),
                          SizedBox(
                            height:MediaQuery.of(context).size.height,
                            child: ListView.builder(
                              itemCount: _bitkyViewModel!.getPlanet.results!.length,
                                itemBuilder: (context, index){
                                return Container(
                                  height: 170,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Card(
                                    elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("İsim: ${_response[index].species.commonNames.toString().replaceAll("]", " ").replaceAll("[", "")}"),
                                          Row(
                                            children: [
                                             const Text("Benzerlik: "),
                                             Container(
                                               decoration: BoxDecoration(
                                                   color: Colors.green,
                                                   borderRadius: BorderRadius.circular(20)
                                               ),
                                               height: 7,
                                               width: _response[index].score * 100.2,
                                             ),
                                              Text("% ${_response[index].score.toStringAsFixed(2)}", style: TextStyle(fontSize: 10,),)
                                            ],
                                          ),
                                          Text("Bilimsel Adı: ${_response[index].species.scientificName}"),
                                          Text("Familya: ${_response[index].species.family.scientificNameWithoutAuthor}"),
                                          Text("Ortak İsmi: ${_response[index].species.commonNames.toString().replaceAll("]", " ").replaceAll("[", "")}"),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                }),
                          ),
                        ],
                      ) : Container(),

                ),

            );
  }
}
