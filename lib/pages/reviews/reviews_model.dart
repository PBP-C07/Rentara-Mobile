import 'dart:convert';

List<Reviews> reviewsFromJson(String str) => List<Reviews>.from(json.decode(str).map((x) => Reviews.fromJson(x)));

String reviewsToJson(List<Reviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Reviews {
    String model;
    String pk;
    Fields fields;

    Reviews({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
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
    String title;
    int user;
    String vehicle;
    DateTime time;
    int rating;
    String description;

    Fields({
        required this.title,
        required this.user,
        required this.vehicle,
        required this.time,
        required this.rating,
        required this.description,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        user: json["user"],
        vehicle: json["vehicle"],
        time: DateTime.parse(json["time"]),
        rating: json["rating"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "user": user,
        "vehicle": vehicle,
        "time": time.toIso8601String(),
        "rating": rating,
        "description": description,
    };
}