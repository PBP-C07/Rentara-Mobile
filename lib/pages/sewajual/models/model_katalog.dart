// To parse this JSON data, do
//
//     final katalogEntry = katalogEntryFromJson(jsonString);

import 'dart:convert';

List<KatalogEntry> katalogEntryFromJson(String str) => List<KatalogEntry>.from(
    json.decode(str).map((x) => KatalogEntry.fromJson(x)));

String katalogEntryToJson(List<KatalogEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KatalogEntry {
  String model;
  int pk;
  Fields fields;

  KatalogEntry({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory KatalogEntry.fromJson(Map<String, dynamic> json) => KatalogEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String vehicle;
  String owner;

  Fields({
    required this.vehicle,
    required this.owner,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        vehicle: json["vehicle"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "vehicle": vehicle,
        "owner": owner,
      };
}
