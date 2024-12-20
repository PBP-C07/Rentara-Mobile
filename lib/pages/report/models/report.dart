
import 'dart:convert';

List<Report> reportFromJson(String str) => List<Report>.from(json.decode(str).map((x) => Report.fromJson(x)));

String reportToJson(List<Report> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Report {
    String model;
    String pk;
    Fields fields;

    Report({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
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
    String issueType;
    String description;
    DateTime time;
    int user;

    Fields({
        required this.vehicle,
        required this.issueType,
        required this.description,
        required this.time,
        required this.user,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        vehicle: json["vehicle"],
        issueType: json["issue_type"],
        description: json["description"],
        time: DateTime.parse(json["time"]),
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "vehicle": vehicle,
        "issue_type": issueType,
        "description": description,
        "time": time.toIso8601String(),
        "user": user,
    };
}
