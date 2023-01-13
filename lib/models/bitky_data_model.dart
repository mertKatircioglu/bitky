  class BitkyDataModel {
  int? id;
  MetaData? metaData;

  double? uploadedDatetime;
  double? finishedDatetime;
  List<Images>? images;
  List<Suggestions>? suggestions;
  List<String>? modifiers;
  String? secret;
  bool? countable;
  double? isPlantProbability;
  bool? isPlant;

  BitkyDataModel({this.id, this.metaData, this.uploadedDatetime, this.finishedDatetime, this.images, this.suggestions, this.modifiers,
    this.secret, this.countable, this.isPlantProbability, this.isPlant});

  BitkyDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    metaData = json['meta_data'] != null ? MetaData.fromJson(json['meta_data']) : null;
    uploadedDatetime = json['uploaded_datetime'];
    finishedDatetime = json['finished_datetime'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) { images!.add(Images.fromJson(v)); });
    }
    if (json['suggestions'] != null) {
      suggestions = <Suggestions>[];
      json['suggestions'].forEach((v) { suggestions!.add(Suggestions.fromJson(v)); });
    }
    modifiers = json['modifiers'].cast<String>();
    secret = json['secret'];
    countable = json['countable'];
    isPlantProbability = json['is_plant_probability'];
    isPlant = json['is_plant'];
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
    if (suggestions != null) {
      data['suggestions'] = suggestions!.map((v) => v.toJson()).toList();
    }
    data['modifiers'] = modifiers;
    data['secret'] = secret;
    data['countable'] = countable;
    data['is_plant_probability'] = isPlantProbability;
    data['is_plant'] = isPlant;
    return data;
  }
}

class MetaData {
  String? date;
  String? datetime;

  MetaData({ this.date, this.datetime});

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

  class Watering {
    int? max;
    int? min;

    Watering({ this.max, this.min});
    Watering.fromJson(Map<String, dynamic> json) {
      max = json['max'];
      min = json['min'];
    }

    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['max'] = max;
      data['min'] = min;
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

class Suggestions {
  int? id;
  String? plantName;

  PlantDetails? plantDetails;
  double? probability;
  bool? confirmed;
  List<SimilarImages>? similarImages;

  Suggestions({this.id, this.plantName, this.plantDetails, this.probability, this.confirmed, this.similarImages});

  Suggestions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plantName = json['plant_name'];
    plantDetails = json['plant_details'] != null ? PlantDetails.fromJson(json['plant_details']) : null;
    probability = json['probability'];
    confirmed = json['confirmed'];
    if (json['similar_images'] != null) {
      similarImages = <SimilarImages>[];
      json['similar_images'].forEach((v) { similarImages!.add(SimilarImages.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plant_name'] = plantName;
    if (plantDetails != null) {
      data['plant_details'] = plantDetails!.toJson();
    }

    data['probability'] = probability;
    data['confirmed'] = confirmed;
    if (similarImages != null) {
      data['similar_images'] = similarImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlantDetails {
  List<String>? commonNames;
  String? url;
  Watering? watering;
  WikiDescription? wikiDescription;
  Taxonomy? taxonomy;
  List<WikiImages>? wikiImages;
  String? language;
  String? scientificName;
  StructuredName? structuredName;

  PlantDetails({this.commonNames, this.url, this.wikiDescription, this.watering,
    this.taxonomy, this.wikiImages, this.language, this.scientificName, this.structuredName});

  PlantDetails.fromJson(Map<String, dynamic> json) {
    commonNames = json['common_names'].cast<String>();
    url = json['url'];
    wikiDescription = json['wiki_description'] != null ? WikiDescription.fromJson(json['wiki_description']) : null;
    watering = json['watering'] != null ? Watering.fromJson(json['watering']) : null;
    taxonomy = json['taxonomy'] != null ? Taxonomy.fromJson(json['taxonomy']) : null;
    if (json['wiki_images'] != null) {
      wikiImages = <WikiImages>[];
      json['wiki_images'].forEach((v) { wikiImages!.add(WikiImages.fromJson(v)); });
    }
    language = json['language'];
    scientificName = json['scientific_name'];
    structuredName = json['structured_name'] != null ? StructuredName.fromJson(json['structured_name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['common_names'] = commonNames;
    data['url'] = url;
    if (wikiDescription != null) {
      data['wiki_description'] = wikiDescription!.toJson();
    }
    if (watering != null) {
      data['watering'] = watering!.toJson();
    }
    if (taxonomy != null) {
      data['taxonomy'] = taxonomy!.toJson();
    }
    if (wikiImages != null) {
      data['wiki_images'] = wikiImages!.map((v) => v.toJson()).toList();
    }
    data['language'] = language;
    data['scientific_name'] = scientificName;
    if (structuredName != null) {
      data['structured_name'] = structuredName!.toJson();
    }
    return data;
  }
}

class WikiDescription {
  String? value;
  String? citation;
  String? licenseName;
  String? licenseUrl;

  WikiDescription({this.value, this.citation, this.licenseName, this.licenseUrl});

  WikiDescription.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    citation = json['citation'];
    licenseName = json['license_name'];
    licenseUrl = json['license_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['citation'] = citation;
    data['license_name'] = licenseName;
    data['license_url'] = licenseUrl;
    return data;
  }
}

class Taxonomy {
  String? clasS;
  String? family;
  String? genus;
  String? kingdom;
  String? order;
  String? phylum;

  Taxonomy({this.clasS, this.family, this.genus, this.kingdom, this.order, this.phylum});

  Taxonomy.fromJson(Map<String, dynamic> json) {
  clasS = json['class'];
  family = json['family'];
  genus = json['genus'];
  kingdom = json['kingdom'];
  order = json['order'];
  phylum = json['phylum'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['class'] = clasS;
  data['family'] = family;
  data['genus'] = genus;
  data['kingdom'] = kingdom;
  data['order'] = order;
  data['phylum'] = phylum;
  return data;
  }
}

class WikiImages {
  String? value;
  String? citation;
  String? licenseName;
  String? licenseUrl;
  String? licenseUrllicenseUrl;

  WikiImages({this.value, this.citation, this.licenseName, this.licenseUrl, this.licenseUrllicenseUrl});

  WikiImages.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    citation = json['citation'];
    licenseName = json['license_name'];
    licenseUrl = json['license_url'];
    licenseUrllicenseUrl = json['license_urllicense_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['citation'] = citation;
    data['license_name'] = licenseName;
    data['license_url'] = licenseUrl;
    data['license_urllicense_url'] = licenseUrllicenseUrl;
    return data;
  }
}

class StructuredName {
  String? genus;
  String? species;

  StructuredName({this.genus, this.species});

  StructuredName.fromJson(Map<String, dynamic> json) {
    genus = json['genus'];
    species = json['species'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['genus'] = genus;
    data['species'] = species;
    return data;
  }
}

class SimilarImages {
  String? id;
  double? similarity;
  String? url;
  String? urlSmall;
  String? citation;
  String? licenseName;
  String? licenseUrl;

  SimilarImages({this.id, this.similarity, this.url, this.urlSmall, this.citation, this.licenseName, this.licenseUrl});

  SimilarImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    similarity = json['similarity'];
    url = json['url'];
    urlSmall = json['url_small'];
    citation = json['citation'];
    licenseName = json['license_name'];
    licenseUrl = json['license_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['similarity'] = similarity;
    data['url'] = url;
    data['url_small'] = urlSmall;
    data['citation'] = citation;
    data['license_name'] = licenseName;
    data['license_url'] = licenseUrl;
    return data;
  }}
