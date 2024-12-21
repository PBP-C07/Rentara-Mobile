import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_model.dart';
import '../../widgets/admin/header_catalogue.dart';
import '../../widgets/admin/vehicle_card.dart';
import '../../../main/widgets/navbarAdmin.dart';
import 'detail_product_admin.dart';

class ProductCatalogueAdmin extends StatefulWidget {
  const ProductCatalogueAdmin({super.key});

  @override
  State<ProductCatalogueAdmin> createState() => _ProductCatalogueAdminState();
}

class _ProductCatalogueAdminState extends State<ProductCatalogueAdmin> {
  String _searchBar = '';
  List<VehicleEntry> _allVehicles = [];
  List<VehicleEntry> _filteredVehicles = [];
  bool _isLoading = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _initializeData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshIndicatorKey.currentState?.show();
    });
  }

  Future<void> _initializeData() async {
    if (!mounted) return;

    final request = context.read<CookieRequest>();
    try {
      final vehicles = await fetchVehicles(request);

      if (!mounted) return;

      setState(() {
        _allVehicles = vehicles;
        _filteredVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/vehicle/json/');
      if (response is List) {
        return vehicleEntryFromJson(jsonEncode(response));
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      throw Exception('Failed to fetch vehicles: ${e.toString()}');
    }
  }

  void _filterVehicles(String query) {
    if (query.isEmpty) {
      _filteredVehicles = _allVehicles;
      return;
    }

    final searchLower = query.toLowerCase();
    _filteredVehicles = _allVehicles.where((vehicle) {
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

  void _handleSearch(String query) {
    setState(() {
      _searchBar = query;
      _isLoading = true;
    });

    _filterVehicles(query);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> refreshData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      final vehicles = await fetchVehicles(request);

      if (!mounted) return;

      setState(() {
        _allVehicles = vehicles;
        _filterVehicles(_searchBar);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing data: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleDelete(String id) {
    setState(() {
      _allVehicles.removeWhere((vehicle) => vehicle.pk.toString() == id);
      _filteredVehicles.removeWhere((vehicle) => vehicle.pk.toString() == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CatalogueHeader(
                  onSearchChanged: _handleSearch,
                  onVehicleAdded: () => refreshData(),
                ),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: refreshData,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _filteredVehicles.isEmpty
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
                                      'No vehicles available.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Try different keywords.',
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
                                    const EdgeInsets.fromLTRB(24, 24, 24, 100),
                                itemCount: _filteredVehicles.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CarDetailScreen(
                                            vehicle: _filteredVehicles[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: VehicleCard(
                                      vehicle: _filteredVehicles[index],
                                      onDelete: _handleDelete,
                                      onEditComplete: refreshData,
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2B6777),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: const NavBarBottomAdmin(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
