import 'dart:io';

import 'package:bitky/data/bitky_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import '../models/bitky_data_model.dart';

enum DataState{
  initialPlantState,
  loadingState,
  loadedState,
  errorState
}


class BitkyViewModel with ChangeNotifier{
  DataState? _state;

  PlanetRepository _repository= locator<PlanetRepository>();
  BitkyDataModel? _bitkyDataModel;

  BitkyViewModel(){
    _bitkyDataModel = BitkyDataModel();
    _state = DataState.initialPlantState;
  }

  BitkyDataModel get getPlanet => _bitkyDataModel!;

  DataState get state => _state!;

  set state(DataState value) {
    _state = value;
    notifyListeners();
  }

  Future<BitkyDataModel> getPlanetFromUi(List<XFile> images) async {
    try{
      state = DataState.loadingState;
      _bitkyDataModel = await _repository.getPlanetFromRepository(images);
      state = DataState.loadedState;
    }catch (e){
      state= DataState.errorState;
      print("Model View Hata: $e");
    }
    return _bitkyDataModel!;
  }

}