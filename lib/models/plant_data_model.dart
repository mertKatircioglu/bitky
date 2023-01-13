class PlantModel {
  String? plantName;
  String? createDate;
  String? image;
  String? location;
  int? plantId;

  PlantModel(
      {this.plantName,
        this.createDate,
        this.image,
        this.location,
        this.plantId});

  PlantModel.fromJson(Map<String, dynamic> json) {
    plantName = json['plantName'];
    createDate = json['createDate'];
    image = json['image'];
    location = json['location'];
    plantId = json['plantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['plantName'] = plantName;
    data['createDate'] = createDate;
    data['image'] = image;
    data['location'] = location;
    data['plantId'] = plantId;
    return data;
  }
}