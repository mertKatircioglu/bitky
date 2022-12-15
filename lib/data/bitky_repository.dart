
import 'dart:typed_data';

import 'package:bitky/models/bitky_health_data_model.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import '../models/bitky_data_model.dart';
import 'bitky_api_client.dart';

class PlanetRepository{

  BitkyApiClient planetApiClient = locator<BitkyApiClient>();

  Future<BitkyDataModel> getPlanetFromRepository(List<XFile> images) async{
    return await planetApiClient.getPlanet(images);
  }

  Future<HealthDataModel> getPlantHealthFromRepository(List<String> images) async{
    return await planetApiClient.getPlanetHealth(images);
  }

}