/*
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

  BitkyDataModel({this.id, this.metaData, this.uploadedDatetime,
    this.finishedDatetime, this.images, this.suggestions, this.modifiers, this.secret,
    this.countable, this.isPlantProbability, this.isPlant});

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
    modifiers = json['modifiers']== null? [] : List<String>.from(json["modifiers"].map((x) => x));
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  List<String>? edibleParts;
  List<String>? propagationMethods;
  List<String>? synonyms;
  Taxonomy? taxonomy;
  String? url;
  WikiDescription? wikiDescription;
  WikiDescription? wikiImages;
  String? scientificName;
  StructuredName? structuredName;

  PlantDetails({this.commonNames, this.edibleParts, this.propagationMethods, this.synonyms, this.taxonomy, this.url, this.wikiDescription, this.wikiImages, this.scientificName, this.structuredName});

  PlantDetails.fromJson(Map<String, dynamic> json) {
    commonNames = json['common_names']== null? [] : List<String>.from(json["common_names"].map((x) => x));
    edibleParts = json['edible_parts']== null? [] : List<String>.from(json["edible_parts"].map((x) => x));
    propagationMethods = json['propagation_methods']== null? [] : List<String>.from(json["propagation_methods"].map((x) => x));
    synonyms = json['synonyms']== null? [] : List<String>.from(json["synonyms"].map((x) => x));
    taxonomy = json['taxonomy'] != null ? Taxonomy.fromJson(json['taxonomy']) : null;
    url = json['url'];
    wikiDescription = json['wiki_description'] != null ? WikiDescription.fromJson(json['wiki_description']) : null;
    wikiImages = json['wiki_image'] != null ? WikiDescription.fromJson(json['wiki_image']) : null;
    scientificName = json['scientific_name'];
    structuredName = json['structured_name'] != null ? StructuredName.fromJson(json['structured_name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['common_names'] = commonNames;
    data['edible_parts'] = edibleParts;
    data['propagation_methods'] = propagationMethods;
    data['synonyms'] = synonyms;
    if (taxonomy != null) {
      data['taxonomy'] = taxonomy!.toJson();
    }
    data['url'] = url;
    if (wikiDescription != null) {
      data['wiki_description'] = wikiDescription!.toJson();
    }
    if (wikiImages != null) {
      data['wiki_image'] = wikiImages!.toJson();
    }
    data['scientific_name'] = scientificName;
    if (structuredName != null) {
      data['structured_name'] = structuredName!.toJson();
    }
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
  }
}
*/

