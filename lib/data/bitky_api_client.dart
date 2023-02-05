
import 'dart:async';
import 'dart:convert';
import 'package:bitky/l10n/app_localizations.dart';
import 'package:bitky/models/weather_data_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather.dart';
import '../models/bitky_data_model.dart';
import '../models/bitky_health_data_model.dart';


class BitkyApiClient {

  //static const baseUrl = "https://my-api.plantnet.org/v2/identify/";
  final http.Client httpClient = http.Client();

  /*Future<BitkyDataModel> getPlanet(List<XFile> images) async {
    const finalUrl = "${baseUrl}all?api-key=IMbQyKlYsdqhMnQiiuSozAKUzb557rYOWaqYf1RHu1skX3tePm";
    var request = http.MultipartRequest('POST', Uri.parse(finalUrl));
    images.forEach((element) {
      request.files.add(
          http.MultipartFile.fromBytes("images", File(element.path).readAsBytesSync(),filename: element.path));
    });
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    print("RESPONSE :${response.body}");
    final responseJson = (jsonDecode(response.body));
    if(response.statusCode == 200){
      debugPrint("SORGUDAN GELEN CEVAP: ${responseJson.toString()}", wrapWidth: 1024);
      return BitkyDataModel.fromJson(responseJson);
    }else{
      throw Exception("Veri getirelemedi");
    }
  }*/
  Future<BitkyDataModel> plantIdentify(List<String> images) async {
    const finalUrl = "https://plant.id/api/v2/identify";
    Map<String, String> requestHeaders = {
      'Api-Key': 'IMbQyKlYsdqhMnQiiuSozAKUzb557rYOWaqYf1RHu1skX3tePm',
      'content-type': 'application/json',
    };
    var body = json.encode({
      "images": images,
      "modifiers": ["similar_images"],
      "plant_details": [
        "common_names",
        "watering",
        "url",
        "wiki_description",
        "taxonomy",
        "wiki_images"
      ],
    });
    var request = http.post(
        Uri.parse(finalUrl), headers: requestHeaders, body: body);
    var res = await request;
    final responseJson = (jsonDecode(res.body));
    // debugPrint(res.body, wrapWidth: 1024);
    if (res.statusCode == 200) {
      // debugPrint("SORGUDAN GELEN CEVAP**********: ${responseJson.toString()}", wrapWidth: 1024);
      var son = await responseJson;
      return BitkyDataModel.fromJson(son);
    } else {
      throw Exception("Veri getirelemedi");
    }
  }


  Future<HealthDataModel> getPlanetHealth(List<String> images,
      BuildContext context) async {
    const finalUrl = "https://api.plant.id/v2/health_assessment";
    Map<String, String> requestHeaders = {
      'Api-Key': 'IMbQyKlYsdqhMnQiiuSozAKUzb557rYOWaqYf1RHu1skX3tePm',
      'content-type': 'application/json',
    };
    var body = json.encode({
      "images": images,
      "modifiers": ["similar_images"],
      "disease_details": [
        "common_names",
        "taxonomy",
        "url",
        "wiki_description",
        "wiki_images",
        "treatment"
      ],
    });

    var request = http.post(
        Uri.parse(finalUrl), headers: requestHeaders, body: body);
    var res = await request;
    final responseJson = (jsonDecode(res.body));
    if (res.statusCode == 200) {
      // debugPrint("SORGUDAN GELEN CEVAP**********: ${responseJson.toString()}", wrapWidth: 1024);
      var son = await responseJson;
      return HealthDataModel.fromJson(son);
    } else {
      throw Exception("Veri getirelemedi");
    }
  }

  Future<WeatherDataModel> getWeather(double lat, double lon,
      BuildContext context) async {
    String baseUrl = "http://api.weatherapi.com/v1/forecast.json?key=6724a24c2cf144b0b89165929230502&q=$lat,$lon&days=4&aqi=yes&alerts=yes&lang=tr";

    Map<String, String> requestHeaders = {
      'Api-Key': '6724a24c2cf144b0b89165929230502',
      'content-type': 'application/json',
    };

    var request = http.post(Uri.parse(baseUrl), headers: requestHeaders);
    var res = await request;
    final responseJson = (jsonDecode(utf8.decode(res.bodyBytes)));
    if (res.statusCode == 200) {
       debugPrint("SORGUDAN GELEN CEVAP**********: ${responseJson.toString()}", wrapWidth: 1024);
      var son = await responseJson;
      // print("GELEN: "+response.weatherIcon.toString());
      return WeatherDataModel.fromJson(son);
    }else {
      throw Exception("Veri getirelemedi");
    }

  }

}
