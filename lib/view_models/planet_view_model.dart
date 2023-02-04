import 'package:bitky/data/bitky_repository.dart';
import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../locator.dart';
import '../models/bitky_data_model.dart';

enum DataState { initialPlantState, loadingState, loadedState, errorState }

class BitkyViewModel with ChangeNotifier {
  DataState? _state;

  var navigatorKey;
  PlanetRepository _repository = locator<PlanetRepository>();
  BitkyDataModel? _bitkyDataModel;
  HealthDataModel? _healthDataModel;
  WeatherDataModel? _weatherDataModel;
  List? _bitkyHealthList;

  BitkyViewModel() {
    _bitkyDataModel = BitkyDataModel();
    navigatorKey = GlobalKey<NavigatorState>().currentContext;
    _healthDataModel = HealthDataModel();
    _weatherDataModel = WeatherDataModel();
    _bitkyHealthList = [];
    _state = DataState.initialPlantState;
  }

  BitkyDataModel get getPlanet => _bitkyDataModel!;
  WeatherDataModel get getWeather => _weatherDataModel!;
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

  Future<HealthDataModel> getPlantHealthFromUi(List<String> images, BuildContext context) async {
    try {
      state = DataState.loadingState;
      _healthDataModel = await _repository.getPlantHealthFromRepository(images, context);
      state = DataState.loadedState;
    } catch (e) {
      state = DataState.errorState;
      print("Model View Hata: $e  GEThELATH");
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

  Future<WeatherDataModel> getWeatherFromUi(double lat, double lon, BuildContext context) async {
    try {
      state = DataState.loadingState;
      _weatherDataModel = await _repository.weatherFromRepository(lat,lon, context);
      state = DataState.loadedState;
    } catch (e) {
      state = DataState.errorState;
      print("Model View Hata: $e");
    }
    return _weatherDataModel!;
  }
}
