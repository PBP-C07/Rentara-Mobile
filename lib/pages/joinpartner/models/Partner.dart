// To parse this JSON data, do
//
//     final partner = partnerFromJson(jsonString);

import 'dart:convert';

List<Partner> partnerFromJson(String str) => List<Partner>.from(json.decode(str).map((x) => Partner.fromJson(x)));

String partnerToJson(List<Partner> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Partner {
    String model;
    String pk;
    Fields fields;

    Partner({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Partner.fromJson(Map<String, dynamic> json) => Partner(
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
    int user;
    String toko;
    String linkLokasi;
    String notelp;
    String status;

    Fields({
        required this.user,
        required this.toko,
        required this.linkLokasi,
        required this.notelp,
        required this.status,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        toko: json["toko"],
        linkLokasi: json["link_lokasi"],
        notelp: json["notelp"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "toko": toko,
        "link_lokasi": linkLokasi,
        "notelp": notelp,
        "status": status,
    };
}
