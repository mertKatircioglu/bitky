import 'package:bitky/data/bitky_repository.dart';
import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:flutter/material.dart';

import '../locator.dart';
import '../models/bitky_data_model.dart';

enum DataState { initialPlantState, loadingState, loadedState, errorState }

class BitkyViewModel with ChangeNotifier {
  DataState? _state;

  PlanetRepository _repository = locator<PlanetRepository>();
  BitkyDataModel? _bitkyDataModel;
  HealthDataModel? _healthDataModel;
  List? _bitkyHealthList;

  BitkyViewModel() {
    _bitkyDataModel = BitkyDataModel();
    _healthDataModel = HealthDataModel();
    _bitkyHealthList = [];
    _state = DataState.initialPlantState;
  }

  BitkyDataModel get getPlanet => _bitkyDataModel!;
  HealthDataModel get getPlantHealth => _healthDataModel!;
  List get getBitkyHealths => _bitkyHealthList!;
  DataState get state => _state!;

  set state(DataState value) {
    _state = value;
    notifyListeners();
  }

/*
  Future<BitkyDataModel> getPlanetFromUi(List<XFile> images) async {
    try {
      state = DataState.loadingState;
      _bitkyDataModel = await _repository.getPlanetFromRepository(images);
      state = DataState.loadedState;
    } catch (e) {
      state = DataState.errorState;
      print("Model View Hata: $e");
    }
    return _bitkyDataModel!;
  }
*/

  Future<HealthDataModel> getPlantHealthFromUi(List<String> images) async {
    try {
      state = DataState.loadingState;
      _healthDataModel = await _repository.getPlantHealthFromRepository(images);
      state = DataState.loadedState;
    } catch (e) {
      state = DataState.errorState;
      print("Model View Hata: $e");
    }
    return _healthDataModel!;
  }

  Future<BitkyDataModel> plantIdentifyFromUi(List<String> images) async {
    try {
      state = DataState.loadingState;
      _bitkyDataModel = await _repository.plantIdentifyFromRepository(images);
      state = DataState.loadedState;
    } catch (e) {
      state = DataState.errorState;
      print("Model View Hata: $e");
    }
    return _bitkyDataModel!;
  }
}
