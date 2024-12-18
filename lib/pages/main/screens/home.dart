import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sewajual/screens/user/detail_product.dart';
import '../widgets/deal_card.dart';
import '../widgets/header.dart';
import '../widgets/navbar.dart';
import '../widgets/car_card.dart';
import '../../sewajual/models/vehicle_model.dart';
import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<VehicleEntry> vehicles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/vehicle/json/');

      final parsed = vehicleEntryFromJson(jsonEncode(response));
      setState(() {
        vehicles = parsed;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load vehicles'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<VehicleEntry> _getFirstVehicles() {
    final mobil = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
        .take(4)
        .toList();
    final motor = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
        .take(3)
        .toList();
    return [...motor, ...mobil];
  }

  List<VehicleEntry> _getRecommendedVehicles() {
    final mobil = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
        .skip(7)
        .take(4)
        .toList();
    final motor = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
        .take(3)
        .toList();
    return [...mobil, ...motor];
  }

  Widget _buildSectionHeader(String title, VoidCallback onViewAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF2B6777),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarSection(bool isMostSearched) {
    if (isLoading) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (vehicles.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(child: Text('No vehicles available')),
      );
    }

    final displayVehicles =
        isMostSearched ? _getFirstVehicles() : _getRecommendedVehicles();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: displayVehicles
            .map((vehicle) => Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CarCard(
                    brand: vehicle.fields.merk,
                    carName: vehicle.fields.tipe,
                    rating: 4.5,
                    pricePerDay: vehicle.fields.harga,
                    fuelType: vehicle.fields.bahanBakar == BahanBakar.BENSIN
                        ? 'Bensin'
                        : 'Diesel',
                    imageUrl: vehicle.fields.linkFoto,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final username = prefs.getString('username');

                      if (context.mounted) {
                        if (username != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CarDetailScreen(vehicle: vehicle),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: fetchVehicles,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(),
                    const SizedBox(height: 24),
                    const DealCard(),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            'Most Searched Vehicle',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MostSearchedVehiclesPage(
                                    vehicles: vehicles,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: _buildCarSection(true),
                          ),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'Recommended For You',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecommendedVehiclesPage(
                                    vehicles: vehicles,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: _buildCarSection(false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavBarBottom(),
            ),
          ],
        ),
      ),
    );
  }
}

class MostSearchedVehiclesPage extends StatelessWidget {
  final List<VehicleEntry> vehicles;

  const MostSearchedVehiclesPage({
    Key? key,
    required this.vehicles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mobilVehicles = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
        .take(12)
        .toList();
    final motorVehicles = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
        .take(8)
        .toList();

    final mostSearchedVehicles = [...motorVehicles, ...mobilVehicles];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Most Searched Vehicles'),
        backgroundColor: const Color(0xFF2B6777),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: mostSearchedVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = mostSearchedVehicles[index];
          return CarCard(
            brand: vehicle.fields.merk,
            carName: vehicle.fields.tipe,
            rating: 4.5,
            pricePerDay: vehicle.fields.harga,
            fuelType: vehicle.fields.bahanBakar == BahanBakar.BENSIN
                ? 'Bensin'
                : 'Diesel',
            imageUrl: vehicle.fields.linkFoto,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final username = prefs.getString('username');

              if (context.mounted) {
                if (username != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(vehicle: vehicle),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}

class RecommendedVehiclesPage extends StatelessWidget {
  final List<VehicleEntry> vehicles;

  const RecommendedVehiclesPage({
    Key? key,
    required this.vehicles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendedMobil = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
        .skip(7)
        .take(12)
        .toList();
    final recommendedMotor = vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
        .take(8)
        .toList();

    final recommendedVehicles = [...recommendedMobil, ...recommendedMotor];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Vehicles'),
        backgroundColor: const Color(0xFF2B6777),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: recommendedVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = recommendedVehicles[index];
          return CarCard(
            brand: vehicle.fields.merk,
            carName: vehicle.fields.tipe,
            rating: 4.5,
            pricePerDay: vehicle.fields.harga,
            fuelType: vehicle.fields.bahanBakar == BahanBakar.BENSIN
                ? 'Bensin'
                : 'Diesel',
            imageUrl: vehicle.fields.linkFoto,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              final username = prefs.getString('username');

              if (context.mounted) {
                if (username != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CarDetailScreen(vehicle: vehicle),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }
}
