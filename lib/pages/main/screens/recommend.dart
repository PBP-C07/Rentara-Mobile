import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sewajual/models/vehicle_model.dart';
import '../../sewajual/screens/user/detail_product.dart';
import '../screens/login.dart';

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

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: Container(
        color: const Color(0xFF2B6777),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button and Title Row
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Recommended Vehicles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
              // Subtitle
              const Padding(
                padding: EdgeInsets.only(left: 16, bottom: 8),
                child: Text(
                  'Find your perfect ride',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar (same as before)
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
          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '${_filteredVehicles.length} Products Found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Vehicle Grid
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
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68, // Adjusted aspect ratio
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = _filteredVehicles[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: InkWell(
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: Image.network(
                                  vehicle.fields.linkFoto,
                                  height: 120, // Reduced height
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, // Added this
                                  children: [
                                    Text(
                                      '${vehicle.fields.merk} ${vehicle.fields.tipe}',
                                      style: const TextStyle(
                                        fontSize: 14, // Reduced font size
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          size: 14, // Reduced size
                                          color: Colors.amber,
                                        ),
                                        Text(
                                          ' 4.5',
                                          style: TextStyle(
                                            fontSize: 12, // Reduced font size
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp${vehicle.fields.harga}/day',
                                      style: const TextStyle(
                                        fontSize: 13, // Reduced font size
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2B6777),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Fuel: ${vehicle.fields.bahanBakar == BahanBakar.BENSIN ? 'Bensin' : 'Diesel'}',
                                      style: TextStyle(
                                        fontSize: 11, // Reduced font size
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
