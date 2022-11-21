import 'dart:io';

import 'package:bitky/data/bitky_repository.dart';
import 'package:bitky/models/bitky_data_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';



class BitkyViewModel with ChangeNotifier{

  PlanetRepository _repository= locator<PlanetRepository>();
  BitckyDataModel? _bitkyDataModel;

  BitkyViewModel(){
    _bitkyDataModel = BitckyDataModel();

  }
  BitckyDataModel get getPlanet => _bitkyDataModel!;


  Future<BitckyDataModel> getPlanetFromUi(List<XFile> images) async {
    try{

      _bitkyDataModel = await _repository.getPlanetFromRepository(images);

    }catch (e){
      print("Model View Hata: $e");
    }
    return _bitkyDataModel!;
  }

}