class Driver {
  final String id;
  final String name;
  final String phoneNumber;
  final String vehicleType;
  final String experienceYears;

  Driver({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.vehicleType,
    required this.experienceYears,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'].toString(),
      name: json['name'],
      phoneNumber: json['phone_number'],
      vehicleType: json['vehicle_type'],
      experienceYears: json['experience_years'],
    );
  }
}