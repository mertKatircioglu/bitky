class HealthDataModel {
  int? id;
  Null? customId;
  MetaData? metaData;
  double? uploadedDatetime;
  double? finishedDatetime;
  List<Images>? images;
  List<String>? modifiers;
  String? secret;
  Null? failCause;
  bool? countable;
  Null? feedback;
  double? isPlantProbability;
  bool? isPlant;
  HealthAssessment? healthAssessment;

  HealthDataModel(
      {this.id,
        this.customId,
        this.metaData,
        this.uploadedDatetime,
        this.finishedDatetime,
        this.images,
        this.modifiers,
        this.secret,
        this.failCause,
        this.countable,
        this.feedback,
        this.isPlantProbability,
        this.isPlant,
        this.healthAssessment});

  HealthDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customId = json['custom_id'];
    metaData = json['meta_data'] != null
        ? new MetaData.fromJson(json['meta_data'])
        : null;
    uploadedDatetime = json['uploaded_datetime'];
    finishedDatetime = json['finished_datetime'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    modifiers = json['modifiers'].cast<String>();
    secret = json['secret'];
    failCause = json['fail_cause'];
    countable = json['countable'];
    feedback = json['feedback'];
    isPlantProbability = json['is_plant_probability'];
    isPlant = json['is_plant'];
    healthAssessment = json['health_assessment'] != null
        ? new HealthAssessment.fromJson(json['health_assessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['custom_id'] = this.customId;
    if (this.metaData != null) {
      data['meta_data'] = this.metaData!.toJson();
    }
    data['uploaded_datetime'] = this.uploadedDatetime;
    data['finished_datetime'] = this.finishedDatetime;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['modifiers'] = this.modifiers;
    data['secret'] = this.secret;
    data['fail_cause'] = this.failCause;
    data['countable'] = this.countable;
    data['feedback'] = this.feedback;
    data['is_plant_probability'] = this.isPlantProbability;
    data['is_plant'] = this.isPlant;
    if (this.healthAssessment != null) {
      data['health_assessment'] = this.healthAssessment!.toJson();
    }
    return data;
  }
}

class MetaData {
  Null? latitude;
  Null? longitude;
  String? date;
  String? datetime;

  MetaData({this.latitude, this.longitude, this.date, this.datetime});

  MetaData.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    date = json['date'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['date'] = this.date;
    data['datetime'] = this.datetime;
    return data;
  }
}

class Images {
  String? fileName;
  String? url;

  Images({this.fileName, this.url});

  Images.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['url'] = this.url;
    return data;
  }
}

class HealthAssessment {
  double? isHealthyProbability;
  bool? isHealthy;
  List<Diseases>? diseases;

  HealthAssessment({this.isHealthyProbability, this.isHealthy, this.diseases});

  HealthAssessment.fromJson(Map<String, dynamic> json) {
    isHealthyProbability = json['is_healthy_probability'];
    isHealthy = json['is_healthy'];
    if (json['diseases'] != null) {
      diseases = <Diseases>[];
      json['diseases'].forEach((v) {
        diseases!.add(new Diseases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_healthy_probability'] = this.isHealthyProbability;
    data['is_healthy'] = this.isHealthy;
    if (this.diseases != null) {
      data['diseases'] = this.diseases!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diseases {
  int? entityId;
  String? name;
  double? probability;
  bool? redundant;
  DiseaseDetails? diseaseDetails;

  Diseases(
      {this.entityId,
        this.name,
        this.probability,
        this.redundant,
        this.diseaseDetails});

  Diseases.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    name = json['name'];
    probability = json['probability'];
    redundant = json['redundant'];
    diseaseDetails = json['disease_details'] != null
        ? new DiseaseDetails.fromJson(json['disease_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entity_id'] = this.entityId;
    data['name'] = this.name;
    data['probability'] = this.probability;
    data['redundant'] = this.redundant;
    if (this.diseaseDetails != null) {
      data['disease_details'] = this.diseaseDetails!.toJson();
    }
    return data;
  }
}

class DiseaseDetails {
  String? localName;
  String? language;

  DiseaseDetails({this.localName, this.language});

  DiseaseDetails.fromJson(Map<String, dynamic> json) {
    localName = json['local_name'];
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['local_name'] = this.localName;
    data['language'] = this.language;
    return data;
  }
}