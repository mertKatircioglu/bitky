import 'dart:io';

import 'package:bitky/data/bitky_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import '../models/bitky_data_model.dart';



class BitkyViewModel with ChangeNotifier{

  PlanetRepository _repository= locator<PlanetRepository>();
  BitkyDataModel? _bitkyDataModel;

  BitkyViewModel(){
    _bitkyDataModel = BitkyDataModel();

  }
  BitkyDataModel get getPlanet => _bitkyDataModel!;


  Future<BitkyDataModel> getPlanetFromUi(List<XFile> images) async {
    try{

      _bitkyDataModel = await _repository.getPlanetFromRepository(images);

    }catch (e){
      print("Model View Hata: $e");
    }
    return _bitkyDataModel!;
  }

}