import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../../sewajual/models/vehicle_model.dart';
import '../widgets/photo_card.dart';
import '../widgets/header.dart';
import '../widgets/car_card.dart';
import '../widgets/navbar.dart';
import 'most_searched.dart';
import 'recommend.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<VehicleEntry> vehicles = [];
  bool isLoading = true;
  List<VehicleEntry> mostSearchedVehicles = [];
  List<VehicleEntry> recommendedVehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    if (!mounted) return;

    final request = context.read<CookieRequest>();
    try {
      final response = await request.get(
          'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/vehicle/json/');

      if (!mounted) return;

      final parsed = vehicleEntryFromJson(jsonEncode(response));

      final mobilVehicles = parsed
          .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
          .toList();
      final motorVehicles = parsed
          .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
          .toList();

      final mostSearchedMotor = motorVehicles.take(3).toList();
      final mostSearchedMobil = mobilVehicles.take(4).toList();
      mostSearchedVehicles = [...mostSearchedMotor, ...mostSearchedMobil];

      final recommendedMobil = mobilVehicles.skip(4).take(4).toList();
      final recommendedMotor = motorVehicles.skip(3).take(3).toList();
      recommendedVehicles = [...recommendedMobil, ...recommendedMotor];

      setState(() {
        vehicles = parsed;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load vehicles!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    final displayVehicles =
        isMostSearched ? mostSearchedVehicles : recommendedVehicles;

    if (isLoading) {
      return const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (displayVehicles.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(child: Text('No vehicles available')),
      );
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = displayVehicles[index];
          return Padding(
            padding: EdgeInsets.only(
              right: 16,
              left: index == 0 ? 16 : 0,
            ),
            child: CarCard(
              brand: vehicle.fields.merk,
              carName: vehicle.fields.tipe,
              rating: 4.5,
              pricePerDay: vehicle.fields.harga,
              fuelType: vehicle.fields.bahanBakar == BahanBakar.BENSIN
                  ? 'Bensin'
                  : 'Diesel',
              imageUrl: vehicle.fields.linkFoto,
            ),
          );
        },
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
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: HeaderSection(),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                  const SliverToBoxAdapter(
                    child: ShowPhotoCard(),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildSectionHeader(
                            'Most Searched Vehicle',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MostSearchedVehiclesScreen(
                                          vehicles: vehicles),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCarSection(true),
                          const SizedBox(height: 32),
                          _buildSectionHeader(
                            'Recommended For You',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RecommendedVehiclesScreen(
                                          vehicles: vehicles),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildCarSection(false),
                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ),
                ],
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

class ShowPhotoCard extends StatelessWidget {
  const ShowPhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = [
      {
        'image': 'lib/pages/main/assets/pantai.png',
        'title': 'Lombok Beach',
        'description': 'Discover pristine beaches with crystal clear waters',
      },
      {
        'image': 'lib/pages/main/assets/rinjani.jpg',
        'title': 'Mount Rinjani',
        'description': 'Experience the majestic beauty of Mount Rinjani',
      },
      {
        'image': 'lib/pages/main/assets/islam_center.jpg',
        'title': 'Islamic Center',
        'description': 'Visit the iconic Hubbul Wathan Islamic Center',
      },
    ];

    return SizedBox(
      height: 280,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final destination = photos[index];
          return PhotoCard(
            imagePath: destination['image']!,
            title: destination['title']!,
            description: destination['description']!,
          );
        },
      ),
    );
  }
}
