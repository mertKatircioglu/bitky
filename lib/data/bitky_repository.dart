
import 'dart:typed_data';

import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import '../models/bitky_data_model.dart';
import 'bitky_api_client.dart';

class PlanetRepository{

  BitkyApiClient planetApiClient = locator<BitkyApiClient>();

/*  Future<BitkyDataModel> getPlanetFromRepository(List<XFile> images) async{
    return await planetApiClient.getPlanet(images);
  }*/

  Future<HealthDataModel> getPlantHealthFromRepository(List<String> images, BuildContext context) async{
    return await planetApiClient.getPlanetHealth(images, context);
  }

  Future<BitkyDataModel> plantIdentifyFromRepository(List<String> images) async{
    return await planetApiClient.plantIdentify(images);
  }

  Future<WeatherDataModel> weatherFromRepository(double lat, double lon) async{
    return await planetApiClient.getWeather(lat, lon);
  }

}