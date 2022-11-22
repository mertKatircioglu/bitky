class BitkyDataModel {
  BitkyDataModel({
     this.query,
     this.language,
     this.preferedReferential,
     this.results,
     this.bestMatch,
     this.remainingIdentificationRequests,
  });
  late final Query? query;
  late final String? language;
  late final String? bestMatch;
  late final String? preferedReferential;
  late final List<Results>? results;
  late final int? remainingIdentificationRequests;

  BitkyDataModel.fromJson(Map<String, dynamic> json){
    query = Query.fromJson(json['query']);
    language = json['language'];
    bestMatch = json['bestMatch'];
    preferedReferential = json['preferedReferential'];
    results = List.from(json['results']).map((e)=>Results.fromJson(e)).toList();
    remainingIdentificationRequests = json['remainingIdentificationRequests'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['query'] = query!.toJson();
    _data['language'] = language;
    _data['bestMatch'] = bestMatch;
    _data['preferedReferential'] = preferedReferential;
    _data['results'] = results!.map((e)=>e.toJson()).toList();
    _data['remainingIdentificationRequests'] = remainingIdentificationRequests;
    return _data;
  }
}

class Query {
  Query({
    required this.project,
    required this.images,
    required this.organs,
  });
  late final String project;
  late final List<String> images;
  late final List<String> organs;

  Query.fromJson(Map<String, dynamic> json){
    project = json['project'];
    images = List.castFrom<dynamic, String>(json['images']);
    organs = List.castFrom<dynamic, String>(json['organs']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['project'] = project;
    _data['images'] = images;
    _data['organs'] = organs;
    return _data;
  }
}

class Results {
  Results({
    required this.score,
    required this.species,
  });
  late final double score;
  late final Species species;

  Results.fromJson(Map<String, dynamic> json){
    score = json['score'];
    species = Species.fromJson(json['species']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['score'] = score;
    _data['species'] = species.toJson();
    return _data;
  }
}

class Species {
  Species({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
    required this.genus,
    required this.family,
    required this.scientificName,
    required this.commonNames,
  });
  late final String scientificNameWithoutAuthor;
  late final String scientificNameAuthorship;
  late final String scientificName;
  late final Genus genus;
  late final Family family;
  late final List<String> commonNames;

  Species.fromJson(Map<String, dynamic> json){
    scientificNameWithoutAuthor = json['scientificNameWithoutAuthor'];
    scientificNameAuthorship = json['scientificNameAuthorship'];
    scientificName = json['scientificName'];
    genus = Genus.fromJson(json['genus']);
    family = Family.fromJson(json['family']);
    commonNames = List.castFrom<dynamic, String>(json['commonNames']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['scientificNameWithoutAuthor'] = scientificNameWithoutAuthor;
    _data['scientificNameAuthorship'] = scientificNameAuthorship;
    _data['scientificName'] = scientificName;
    _data['genus'] = genus.toJson();
    _data['family'] = family.toJson();
    _data['commonNames'] = commonNames;
    return _data;
  }
}

class Genus {
  Genus({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
  });
  late final String scientificNameWithoutAuthor;
  late final String scientificNameAuthorship;

  Genus.fromJson(Map<String, dynamic> json){
    scientificNameWithoutAuthor = json['scientificNameWithoutAuthor'];
    scientificNameAuthorship = json['scientificNameAuthorship'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['scientificNameWithoutAuthor'] = scientificNameWithoutAuthor;
    _data['scientificNameAuthorship'] = scientificNameAuthorship;
    return _data;
  }
}

class Family {
  Family({
    required this.scientificNameWithoutAuthor,
    required this.scientificNameAuthorship,
  });
  late final String scientificNameWithoutAuthor;
  late final String scientificNameAuthorship;

  Family.fromJson(Map<String, dynamic> json){
    scientificNameWithoutAuthor = json['scientificNameWithoutAuthor'];
    scientificNameAuthorship = json['scientificNameAuthorship'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['scientificNameWithoutAuthor'] = scientificNameWithoutAuthor;
    _data['scientificNameAuthorship'] = scientificNameAuthorship;
    return _data;
  }
}