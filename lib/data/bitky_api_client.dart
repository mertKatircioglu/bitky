
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../models/bitky_data_model.dart';
import '../models/bitky_health_data_model.dart';


class BitkyApiClient{
  static const baseUrl = "https://my-api.plantnet.org/v2/identify/";
  final http.Client httpClient = http.Client();


  Future<BitkyDataModel> getPlanet(List<XFile> images) async {
    const finalUrl = "${baseUrl}all?api-key=2b10GyjZGQHnv2pqhtXuztXPO";
    var request = http.MultipartRequest('POST', Uri.parse(finalUrl));
    images.forEach((element) {
      request.files.add(
          http.MultipartFile.fromBytes("images", File(element.path).readAsBytesSync(),filename: element.path));
    });
    var res = await request.send();
    final response = await http.Response.fromStream(res);
    //print("RESPONSE :"+res.toString());
    final responseJson = (jsonDecode(response.body));
    if(response.statusCode == 200){
      debugPrint("SORGUDAN GELEN CEVAP: ${responseJson.toString()}", wrapWidth: 1024);
      return BitkyDataModel.fromJson(responseJson);
    }else{
      throw Exception("Veri getirelemedi");
    }
  }

  Future<HealthDataModel> getPlanetHealth(List<String> images) async {
    const finalUrl = "https://api.plant.id/v2/health_assessment";
    Map<String, String> requestHeaders = {
      'Api-Key': '4FevuT7eMgLKdMqvSO8l6jdaNCixmhQQbNH1Ey7Ym57AHUMx86',
      'content-type': 'application/json',
    };
    var body = json.encode({
      "images": images,
    });
    var request = http.post(Uri.parse(finalUrl), headers: requestHeaders, body: body);
    var res = await request;
    final responseJson = (jsonDecode(res.body));
    if(res.statusCode == 200){
      debugPrint("SORGUDAN GELEN CEVAP**********: ${responseJson.toString()}", wrapWidth: 1024);
      var son = await responseJson;
      return HealthDataModel.fromJson(son);
    }else{
      throw Exception("Veri getirelemedi");
    }
  }
}


