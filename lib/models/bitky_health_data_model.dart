class HealthDataModel {
  int? id;
  MetaData? metaData;
  double? uploadedDatetime;
  double? finishedDatetime;
  List<Images>? images;
  List<String>? modifiers;
  String? secret;
  bool? countable;
  double? isPlantProbability;
  bool? isPlant;
  HealthAssessment? healthAssessment;

  HealthDataModel(
      {this.id,
        this.metaData,
        this.uploadedDatetime,
        this.finishedDatetime,
        this.images,
        this.modifiers,
        this.secret,
        this.countable,
        this.isPlantProbability,
        this.isPlant,
        this.healthAssessment});

  HealthDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metaData = json['meta_data'] != null
        ? MetaData.fromJson(json['meta_data'])
        : null;
    uploadedDatetime = json['uploaded_datetime'];
    finishedDatetime = json['finished_datetime'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    modifiers = json['modifiers'].cast<String>();
    secret = json['secret'];
    countable = json['countable'];
    isPlantProbability = json['is_plant_probability'];
    isPlant = json['is_plant'];
    healthAssessment = json['health_assessment'] != null
        ? HealthAssessment.fromJson(json['health_assessment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (metaData != null) {
      data['meta_data'] = metaData!.toJson();
    }
    data['uploaded_datetime'] = uploadedDatetime;
    data['finished_datetime'] = finishedDatetime;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['modifiers'] = modifiers;
    data['secret'] = secret;
    data['countable'] = countable;
    data['is_plant_probability'] = isPlantProbability;
    data['is_plant'] = isPlant;
    if (healthAssessment != null) {
      data['health_assessment'] = healthAssessment!.toJson();
    }
    return data;
  }
}

class MetaData {
  String? date;
  String? datetime;

  MetaData({this.date, this.datetime});

  MetaData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['datetime'] = datetime;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_name'] = fileName;
    data['url'] = url;
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
        diseases!.add(Diseases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['is_healthy_probability'] = isHealthyProbability;
    data['is_healthy'] = isHealthy;
    if (diseases != null) {
      data['diseases'] = diseases!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diseases {
  int? entityId;
  String? name;
  double? probability;
  List<SimilarImages>? similarImages;
  DiseaseDetails? diseaseDetails;

  Diseases(
      {this.entityId,
        this.name,
        this.probability,
        this.similarImages,
        this.diseaseDetails});

  Diseases.fromJson(Map<String, dynamic> json) {
    entityId = json['entity_id'];
    name = json['name'];
    probability = json['probability'];
    if (json['similar_images'] != null) {
      similarImages = <SimilarImages>[];
      json['similar_images'].forEach((v) {
        similarImages!.add(SimilarImages.fromJson(v));
      });
    }
    diseaseDetails = json['disease_details'] != null
        ? DiseaseDetails.fromJson(json['disease_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['entity_id'] = entityId;
    data['name'] = name;
    data['probability'] = probability;
    if (similarImages != null) {
      data['similar_images'] =
          similarImages!.map((v) => v.toJson()).toList();
    }
    if (this.diseaseDetails != null) {
      data['disease_details'] = this.diseaseDetails!.toJson();
    }
    return data;
  }
}

class SimilarImages {
  String? id;
  double? similarity;
  String? url;
  String? urlSmall;

  SimilarImages({this.id, this.similarity, this.url, this.urlSmall});

  SimilarImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    similarity = json['similarity'];
    url = json['url'];
    urlSmall = json['url_small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['similarity'] = similarity;
    data['url'] = url;
    data['url_small'] = urlSmall;
    return data;
  }
}

class DiseaseDetails {
  String? cause;
  List<String>? classification;
  List<String>? commonNames;
  String? description;
  Treatment? treatment;
  String? url;
  String? localName;
  String? language;

  DiseaseDetails(
      {this.cause,
        this.classification,
        this.commonNames,
        this.description,
        this.treatment,
        this.url,
        this.localName,
        this.language});

  DiseaseDetails.fromJson(Map<String, dynamic> json) {
    cause = json['cause'];
    classification = json['classification'] != null ? json['classification'].cast<String>() : null;
    commonNames = json['common_names'] != null ? json['common_names'].cast<String>() : null;
    description = json['description'];
    treatment = json['treatment'] != null
        ? Treatment.fromJson(json['treatment'])
        : null;
    url = json['url'];
    localName = json['local_name'] ;
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cause'] = cause;
    data['classification'] = classification;
    data['common_names'] = commonNames;
    data['description'] = description;
    if (treatment != null) {
      data['treatment'] = treatment!.toJson();
    }
    data['url'] = url;
    data['local_name'] = localName;
    data['language'] = language;
    return data;
  }
}
class Treatment {
  List<String>? prevention;
  List<String>? biological;
  List<String>? chemical;

  Treatment({this.prevention, this.biological, this.chemical});

  Treatment.fromJson(Map<String, dynamic> json) {
    prevention = json['prevention'] != null ? json['prevention'].cast<String>() : null;
    biological = json['biological'] != null ? json['biological'].cast<String>() : null;
    chemical = json['chemical'] != null ? json['chemical'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['prevention'] = prevention;
    data['biological'] = biological;
    data['chemical'] = chemical;
    return data;
  }
}