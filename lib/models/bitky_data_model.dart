class BitckyDataModel {
  Query? query;
  String? language;
  String? preferedReferential;
  List<Results>? results;
  int? remainingIdentificationRequests;

  BitckyDataModel(
      {this.query,
        this.language,
        this.preferedReferential,
        this.results,
        this.remainingIdentificationRequests});

  BitckyDataModel.fromJson(Map<String, dynamic> json) {
    query = json['query'] != null ?  Query.fromJson(json['query']) : null;
    language = json['language'];
    preferedReferential = json['preferedReferential'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add( Results.fromJson(v));
      });
    }
    remainingIdentificationRequests = json['remainingIdentificationRequests'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (query != null) {
      data['query'] = query!.toJson();
    }
    data['language'] = language;
    data['preferedReferential'] = preferedReferential;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['remainingIdentificationRequests'] =
        remainingIdentificationRequests;
    return data;
  }
}

class Query {
  String? project;
  List<String>? images;
  List<String>? organs;

  Query({this.project, this.images, this.organs});

  Query.fromJson(Map<String, dynamic> json) {
    project = json['project'];
    images = json['images'].cast<String>();
    organs = json['organs'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['project'] = project;
    data['images'] = images;
    data['organs'] = organs;
    return data;
  }
}

class Results {
  double? score;
  Species? species;

  Results({this.score, this.species});

  Results.fromJson(Map<String, dynamic> json) {
    score = json['score'];
    species =
    json['species'] != null ?  Species.fromJson(json['species']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['score'] = score;
    if (species != null) {
      data['species'] = species!.toJson();
    }
    return data;
  }
}

class Species {
  String? scientificNameWithoutAuthor;
  String? scientificNameAuthorship;
  Genus? genus;
  Genus? family;
  List<String>? commonNames;

  Species(
      {this.scientificNameWithoutAuthor,
        this.scientificNameAuthorship,
        this.genus,
        this.family,
        this.commonNames});

  Species.fromJson(Map<String, dynamic> json) {
    scientificNameWithoutAuthor = json['scientificNameWithoutAuthor'];
    scientificNameAuthorship = json['scientificNameAuthorship'];
    genus = json['genus'] != null ?  Genus.fromJson(json['genus']) : null;
    family = json['family'] != null ?  Genus.fromJson(json['family']) : null;
    commonNames = json['commonNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['scientificNameWithoutAuthor'] = scientificNameWithoutAuthor;
    data['scientificNameAuthorship'] = scientificNameAuthorship;
    if (genus != null) {
      data['genus'] = genus!.toJson();
    }
    if (family != null) {
      data['family'] = family!.toJson();
    }
    data['commonNames'] = commonNames;
    return data;
  }
}

class Genus {
  String? scientificNameWithoutAuthor;
  String? scientificNameAuthorship;

  Genus({this.scientificNameWithoutAuthor, this.scientificNameAuthorship});

  Genus.fromJson(Map<String, dynamic> json) {
    scientificNameWithoutAuthor = json['scientificNameWithoutAuthor'];
    scientificNameAuthorship = json['scientificNameAuthorship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['scientificNameWithoutAuthor'] = scientificNameWithoutAuthor;
    data['scientificNameAuthorship'] = scientificNameAuthorship;
    return data;
  }
}