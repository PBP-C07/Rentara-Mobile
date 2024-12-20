import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../../main/widgets/navbar.dart';
import '../../models/vehicle_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_product.dart';
import '../../../main/screens/login.dart';
import '../../widgets/user/car_card.dart';

class CarCatalogueScreen extends StatefulWidget {
  const CarCatalogueScreen({Key? key}) : super(key: key);

  @override
  State<CarCatalogueScreen> createState() => _CarCatalogueScreenState();
}

class _CarCatalogueScreenState extends State<CarCatalogueScreen> {
  String _searchQuery = '';
  List<VehicleEntry> _vehicles = [];
  List<VehicleEntry> _filteredVehicles = [];
  bool _isLoading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final request = context.read<CookieRequest>();
    try {
      final vehicles = await fetchVehicles(request);
      setState(() {
        _vehicles = vehicles;
        _filteredVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    String url =
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/vehicle/json/';
    if (_searchQuery.isNotEmpty) {
      final encodedQuery = Uri.encodeQueryComponent(_searchQuery);
      url += '?search=$encodedQuery';
    }
    final response = await request.get(url);
    return vehicleEntryFromJson(jsonEncode(response));
  }

  void _filterVehicles(String query) {
    if (query.isEmpty) {
      _filteredVehicles = _vehicles;
      return;
    }

    final searchLower = query.toLowerCase();
    _filteredVehicles = _vehicles.where((vehicle) {
      final fields = vehicle.fields;

      final searchableStrings = [
        fields.merk.toLowerCase(),
        fields.tipe.toLowerCase(),
        fields.toko.toLowerCase(),
        fields.warna.toLowerCase(),
        jenisKendaraanValues.reverse[fields.jenisKendaraan]?.toLowerCase() ??
            '',
        bahanBakarValues.reverse[fields.bahanBakar]?.toLowerCase() ?? '',
      ];

      return searchableStrings.any((text) => text.contains(searchLower));
    }).toList();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      _searchQuery = query;
      _isLoading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterVehicles(query);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B6777),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'All Products',
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
                      Text(
                        'Find your perfect ride',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
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
                                    onChanged: _onSearchChanged,
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
                                      setState(() {
                                        _searchQuery = '';
                                        _filteredVehicles = _vehicles;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (_isLoading)
                          const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_filteredVehicles.isEmpty)
                          Expanded(
                            child: Center(
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
                            ),
                          )
                        else
                          Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        '${_filteredVehicles.length} Products Found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _filteredVehicles.length,
                                      itemBuilder: (context, index) {
                                        final vehicle =
                                            _filteredVehicles[index];
                                        return InkWell(
                                          onTap: () async {
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
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
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 80),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
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
