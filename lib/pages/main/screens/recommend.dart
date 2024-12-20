import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sewajual/models/vehicle_model.dart';
import '../../sewajual/screens/user/detail_product.dart';
import '../screens/login.dart';
import '../../sewajual/widgets/user/car_card.dart';

class RecommendedVehiclesScreen extends StatefulWidget {
  final List<VehicleEntry> vehicles;

  const RecommendedVehiclesScreen({
    Key? key,
    required this.vehicles,
  }) : super(key: key);

  @override
  State<RecommendedVehiclesScreen> createState() =>
      _RecommendedVehiclesScreenState();
}

class _RecommendedVehiclesScreenState extends State<RecommendedVehiclesScreen> {
  String _searchQuery = '';
  List<VehicleEntry> _filteredVehicles = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeVehicles();
  }

  void _initializeVehicles() {
    final recommendedMobil = widget.vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOBIL)
        .skip(12)
        .take(12)
        .toList();
    final recommendedMotor = widget.vehicles
        .where((v) => v.fields.jenisKendaraan == JenisKendaraan.MOTOR)
        .skip(8)
        .take(8)
        .toList();

    setState(() {
      _filteredVehicles = [...recommendedMotor, ...recommendedMobil];
    });
  }

  void _filterVehicles(String query) {
    if (query.isEmpty) {
      _initializeVehicles();
      return;
    }

    final searchLower = query.toLowerCase();
    setState(() {
      _filteredVehicles = _filteredVehicles.where((vehicle) {
        final fields = vehicle.fields;
        return fields.merk.toLowerCase().contains(searchLower) ||
            fields.tipe.toLowerCase().contains(searchLower) ||
            fields.toko.toLowerCase().contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B6777),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommended',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3.0,
                              color: Color.fromARGB(50, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF2B6777).withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                    _filterVehicles(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search vehicles here...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                color: Colors.grey[600],
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _filterVehicles('');
                                  });
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        '${_filteredVehicles.length} Products Found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _filteredVehicles.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No vehicles found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Try different keywords',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: _filteredVehicles.length,
                              itemBuilder: (context, index) {
                                final vehicle = _filteredVehicles[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: InkWell(
                                    onTap: () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final username =
                                          prefs.getString('username');

                                      if (context.mounted) {
                                        if (username != null) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CarDetailScreen(
                                                      vehicle: vehicle),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: CarCard(vehicle: vehicle),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
