import 'dart:convert';

class EarthquakeData {
  String type;
  Metadata metadata;
  List<Feature> features;
  List<double> bbox;

  EarthquakeData({
    required this.type,
    required this.metadata,
    required this.features,
    required this.bbox,
  });

  factory EarthquakeData.fromJson(Map<String, dynamic> json) => EarthquakeData(
        type: json['type'],
        metadata: Metadata.fromJson(json['metadata']),
        features: List<Feature>.from(json['features'].map((x) => Feature.fromJson(x))),
        bbox: List<double>.from(json['bbox'].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'metadata': metadata.toJson(),
        'features': List<dynamic>.from(features.map((x) => x.toJson())),
        'bbox': List<dynamic>.from(bbox.map((x) => x)),
      };
}

class Metadata {
  int generated;
  String url;
  String title;
  int status;
  String api;
  int count;

  Metadata({
    required this.generated,
    required this.url,
    required this.title,
    required this.status,
    required this.api,
    required this.count,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        generated: json['generated'],
        url: json['url'],
        title: json['title'],
        status: json['status'],
        api: json['api'],
       count: json['count'],
);

Map<String, dynamic> toJson() => {
'generated': generated,
'url': url,
'title': title,
'status': status,
'api': api,
'count': count,
};
}

class Feature {
String type;
Properties properties;
Geometry geometry;
String id;

Feature({
required this.type,
required this.properties,
required this.geometry,
required this.id,
});

factory Feature.fromJson(Map<String, dynamic> json) => Feature(
type: json['type'],
properties: Properties.fromJson(json['properties']),
geometry: Geometry.fromJson(json['geometry']),
id: json['id'],
);

Map<String, dynamic> toJson() => {
'type': type,
'properties': properties.toJson(),
'geometry': geometry.toJson(),
'id': id,
};
}

class Properties {
double mag;
String place;
int time;
int updated;
int tz;
String url;
String detail;
int? felt;
double? cdi;
double? mmi;
String alert;
String status;
int tsunami;
int sig;
String net;
String code;
String ids;
String sources;
String types;
int? nst;
double? dmin;
double? rms;
int? gap;
String magType;
String type;

Properties({
required this.mag,
required this.place,
required this.time,
required this.updated,
required this.tz,
required this.url,
required this.detail,
this.felt,
this.cdi,
this.mmi,
required this.alert,
required this.status,
required this.tsunami,
required this.sig,
required this.net,
required this.code,
required this.ids,
required this.sources,
required this.types,
this.nst,
this.dmin,
this.rms,
this.gap,
required this.magType,
required this.type,
});

factory Properties.fromJson(Map<String, dynamic> json) => Properties(
mag: json['mag'].toDouble(),
place: json['place'],
time: json['time'],
updated: json['updated'],
tz: json['tz'],
url: json['url'],
detail: json['detail'],
felt: json['felt'],
cdi: json['cdi'] == null ? null : json['cdi'].toDouble(),
mmi: json['mmi'] == null ? null : json['mmi'].toDouble(),
alert: json['alert'],
status: json['status'],
tsunami: json['tsunami'],
sig: json['sig'],
net: json['net'],
code: json['code'],
ids: json['ids'],
sources: json['sources'],
types: json['types'],
nst: json['nst'],
dmin: json['dmin'] == null ? null : json['dmin'].toDouble(),
rms: json['rms'] == null ? null : json['rms'].toDouble(),
gap: json['gap'],
magType: json['magType'],
type: json['type'],
);

Map<String, dynamic> toJson() => {
'mag': mag,
'place': place,
'time': time,
'updated': updated,
'tz': tz,
'url': url,
'detail': detail,
'felt': felt,
'cdi': cdi,
'mmi': mmi,
'alert': alert,
'status': status,
'tsunami': tsunami,
'sig': sig,
'net': net,
'code': code,
'ids': ids,
'sources': sources,
'types': types,
'nst': nst,
'dmin': dmin,
'rms': rms,
'gap': gap,
'magType': magType,
'type': type,
};
}

class Geometry {
String type;
List<double> coordinates;

Geometry({
required this.type,
required this.coordinates,
});

factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
type: json['type'],
coordinates: List<double>.from(json['coordinates'].map((x) => x.toDouble())),
);

Map<String, dynamic> toJson() => {
'type': type,
'coordinates': List<dynamic>.from(coordinates.map((x) => x)),
};
}
