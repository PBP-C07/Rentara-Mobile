// To parse this JSON data, do
//
//     final vehicleEntry = vehicleEntryFromJson(jsonString);

import 'dart:convert';

List<VehicleEntry> vehicleEntryFromJson(String str) => List<VehicleEntry>.from(json.decode(str).map((x) => VehicleEntry.fromJson(x)));

String vehicleEntryToJson(List<VehicleEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleEntry {
    Model model;
    String pk;
    Fields fields;

    VehicleEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory VehicleEntry.fromJson(Map<String, dynamic> json) => VehicleEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String toko;
    String merk;
    String tipe;
    String warna;
    JenisKendaraan jenisKendaraan;
    int harga;
    Status status;
    String notelp;
    BahanBakar bahanBakar;
    String linkLokasi;
    String linkFoto;

    Fields({
        required this.toko,
        required this.merk,
        required this.tipe,
        required this.warna,
        required this.jenisKendaraan,
        required this.harga,
        required this.status,
        required this.notelp,
        required this.bahanBakar,
        required this.linkLokasi,
        required this.linkFoto,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        toko: json["toko"],
        merk: json["merk"],
        tipe: json["tipe"],
        warna: json["warna"],
        jenisKendaraan: jenisKendaraanValues.map[json["jenis_kendaraan"]]!,
        harga: json["harga"],
        status: statusValues.map[json["status"]]!,
        notelp: json["notelp"],
        bahanBakar: bahanBakarValues.map[json["bahan_bakar"]]!,
        linkLokasi: json["link_lokasi"],
        linkFoto: json["link_foto"],
    );

    Map<String, dynamic> toJson() => {
        "toko": toko,
        "merk": merk,
        "tipe": tipe,
        "warna": warna,
        "jenis_kendaraan": jenisKendaraanValues.reverse[jenisKendaraan],
        "harga": harga,
        "status": statusValues.reverse[status],
        "notelp": notelp,
        "bahan_bakar": bahanBakarValues.reverse[bahanBakar],
        "link_lokasi": linkLokasi,
        "link_foto": linkFoto,
    };
}

enum BahanBakar {
    BAHAN_BAKAR_BENSIN,
    BAHAN_BAKAR_DIESEL,
    BENSIN,
    DIESEL
}

final bahanBakarValues = EnumValues({
    "bensin": BahanBakar.BAHAN_BAKAR_BENSIN,
    "diesel": BahanBakar.BAHAN_BAKAR_DIESEL,
    "Bensin": BahanBakar.BENSIN,
    "Diesel": BahanBakar.DIESEL
});

enum JenisKendaraan {
    JENIS_KENDARAAN_MOBIL,
    MOBIL,
    MOTOR
}

final jenisKendaraanValues = EnumValues({
    "mobil": JenisKendaraan.JENIS_KENDARAAN_MOBIL,
    "Mobil": JenisKendaraan.MOBIL,
    "Motor": JenisKendaraan.MOTOR
});

enum Status {
    JUAL,
    SEWA,
    STATUS_SEWA
}

final statusValues = EnumValues({
    "Jual": Status.JUAL,
    "Sewa": Status.SEWA,
    "sewa": Status.STATUS_SEWA
});

enum Model {
    MAIN_VEHICLE
}

final modelValues = EnumValues({
    "main.vehicle": Model.MAIN_VEHICLE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
