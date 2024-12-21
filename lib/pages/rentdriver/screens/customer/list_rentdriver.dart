import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/main/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import "package:rentara_mobile/pages/rentdriver/models/rentdriver_models.dart";

class Driver {
  final String name;
  final String phoneNumber;
  final String vehicleType;
  final String experienceYears;

  Driver({
    required this.name,
    required this.phoneNumber,
    required this.vehicleType,
    required this.experienceYears,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      name: json['name'],
      phoneNumber: json['phone_number'],
      vehicleType: json['vehicle_type'],
      experienceYears: json['experience_years'],
    );
  }
}

class DriverListApp extends StatefulWidget {
  const DriverListApp({super.key});

  @override
  State<DriverListApp> createState() => _DriverListAppState();
}

class _DriverListAppState extends State<DriverListApp> {
  List<Driver> _drivers = [];
  List<Driver> _filteredDrivers = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDrivers();
  }

  Future<void> _fetchDrivers() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get('http://127.0.0.1:8000/driver/json/');
      
      // Parse the response
      if (response is String) {
        // If response is a string, parse it first
        final List<dynamic> decodedData = json.decode(response);
        final List<Driver> drivers = decodedData.map((data) => Driver.fromJson(data)).toList();
        setState(() {
          _drivers = drivers;
          _filteredDrivers = drivers;
          _isLoading = false;
        });
      } else if (response is List) {
        // If response is already a List
        final List<Driver> drivers = response.map((data) => Driver.fromJson(data)).toList();
        setState(() {
          _drivers = drivers;
          _filteredDrivers = drivers;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching drivers: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterDrivers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDrivers = _drivers;
      } else {
        _filteredDrivers = _drivers
            .where((driver) =>
                driver.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2B6777),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: const Text(
                'OUR DRIVERS',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                              'https://cdn.builder.io/api/v1/image/assets/TEMP/3dab21d4069c815882e8678437a035928b8559ae27d8e7d0968939b40c93cc37?placeholderIfAbsent=true&apiKey=282d9dcdc648433facda1b9dd9ebad2c', // Update with your image URL
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 200,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description Text
                      const Text(
                        'Need a trusted driver for your rented car?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF304858),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Rentara+ connects you with experienced drivers to ensure a safe and hassle-free journey across Mataram. Book now and travel with peace of mind!',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 20),

                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterDrivers,
                          decoration: const InputDecoration(
                            hintText: 'Search by name',
                            border: InputBorder.none,
                            icon: Icon(Icons.search, color: Color(0xFF2B6777)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Drivers List
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_filteredDrivers.isEmpty)
                        const Center(
                          child: Text('No drivers found'),
                        )
                      else
                        ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredDrivers.length,
                        itemBuilder: (context, index) {
                          final driver = _filteredDrivers[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF2B6777),
                                child: Icon(Icons.person, color: Colors.white.withOpacity(0.9)),
                              ),
                              title: Text(
                                driver.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('📞 ${driver.phoneNumber}'),
                                  Text('Vehicle: ${driver.vehicleType}'),
                                  Text('Experience: ${driver.experienceYears}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarBottom(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}