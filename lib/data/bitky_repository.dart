
import 'package:bitky/models/bitky_data_model.dart';
import 'package:image_picker/image_picker.dart';

import '../locator.dart';
import 'bitky_api_client.dart';

class PlanetRepository{

  BitkyApiClient planetApiClient = locator<BitkyApiClient>();

  Future<BitckyDataModel> getPlanetFromRepository(List<XFile> images) async{

    return await planetApiClient.getPlanet(images);
  }


}