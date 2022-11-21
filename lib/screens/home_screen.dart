import 'dart:io';

import 'package:bitky/globals/globals.dart';
import 'package:bitky/models/bitky_data_model.dart';
import 'package:bitky/view_models/planet_view_model.dart';
import 'package:flutter/material.dart';
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

  openImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage();
      if(pickedfiles != null){
        imagefiles = pickedfiles;
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
        title: const Text("Bitky guide", style: TextStyle(
          color: Colors.pinkAccent
        ),),
      ),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: (){
                openImages();
              },
              child:const Text("Foto Seç")
          ),

         const Divider(),
         const Text("Seçilen Fotolar:"),
         const Divider(),

          imagefiles != null?Wrap(
            children: imagefiles!.map((imageone){
              return Column(
                children: [
                  Container(
                      child:Card(
                        child: Container(
                          height: 200, width:200,
                          child: Image.file(File(imageone.path)),
                        ),
                      )
                  ),

                ],
              );
            }).toList(),
          ):Container(),
          Visibility(
              visible: imagefiles != null ? true : false,
              child: ElevatedButton(
              onPressed: (){
                _bitkyViewModel!.getPlanetFromUi(imagefiles!).whenComplete(() {
                  setState(() {
                    datasContainer = true;
                  });
                  print("HOME SCREEN GELEN VERİLER: ${_bitkyViewModel!.getPlanet.results!.length.toString()}");
                });
              },
              child:const Text("Sorgula"))),
          Visibility(
              visible: datasContainer!,
              child: Column(
                children: [

                ],
              ),

          )
        ],
      ),
    );
  }
}
