class WeatherDataModel{
  String? max;
  String? temp;
  String? placeName;
  String? date;
  String? wind;
  String? feels;
  String? wthr;
  String? icon;
  String? hummudity;

  WeatherDataModel(
      {this.max,
      this.temp,
      this.placeName,
      this.date,
      this.wind,
        this.icon,
      this.feels,
      this.wthr,
      this.hummudity});

  WeatherDataModel.fromJson(Map<String, dynamic> json) {
    max = json['tempMax'] ?? "0";
    temp = json['temperature'] ?? "0";
    date = json['date'] ?? "0";
    placeName = json['areaName'] ?? "-";
    wind = json['windSpeed'] ?? "0";
    icon = json['weatherIcon'] ?? "0";
    feels = json['tempFeelsLike'] ?? "0";
    wthr = json['weatherDescription'] ?? "-";
    hummudity = json['humidity'] ?? "0";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['plantName'] = max;
    data['createDate'] = temp;
    data['date'] = date;
    data['areaName'] = placeName;
    data['weatherIcon'] = icon;
    data['windSpeed'] = wind;
    data['tempFeelsLike'] = feels;
    data['weatherDescription'] = wthr;
    data['humidity'] = hummudity;

    return data;
  }


}