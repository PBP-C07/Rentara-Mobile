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
  // Variabel untuk nerima data untuk fitur search
  String _searchBar = ''; // Menyimpan text yang ada di search bar
  List<VehicleEntry> _allVehicles = []; // List semua kendaraan
  List<VehicleEntry> _filteredVehicles =
      []; // List kendaraan yang sudah difilter
  bool _isLoading = true; // Status loading saat searching
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<
      RefreshIndicatorState>(); // Key untuk fungsi refresh/reload data

  @override
  void initState() {
    super.initState();
    _initializeData(); // Inisialisasi data saat pertama dibuat
  }

  // Fungsi untuk menginisialisasi data kendaraan
  Future<void> _initializeData() async {
    final request = context.read<CookieRequest>();
    try {
      final vehicles = await fetchVehicles(request);
      setState(() {
        _allVehicles = vehicles;
        _filteredVehicles = vehicles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi asinkronus untuk mengambil data kendaraan dari API
  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/vehicle/json/');
    return vehicleEntryFromJson(jsonEncode(response));
  }

  // Filter kendaraan berdasarkan pencarian admin
  void _filterVehicles(String query) {
    // Kalau tidak search apapun di search bar
    if (query.isEmpty) {
      _filteredVehicles = _allVehicles;
      return;
    }

    final searchLower = query.toLowerCase();
    // Filter kendaraan berdasarkan beberapa field
    _filteredVehicles = _allVehicles.where((vehicle) {
      final fields = vehicle.fields;
      // Daftar field yang dapat dicari di search bar
      final searchableStrings = [
        fields.merk.toLowerCase(),
        fields.tipe.toLowerCase(),
        fields.toko.toLowerCase(),
        fields.warna.toLowerCase(),
        jenisKendaraanValues.reverse[fields.jenisKendaraan]?.toLowerCase() ??
            '',
        bahanBakarValues.reverse[fields.bahanBakar]?.toLowerCase() ?? '',
      ];
      // Mencari apakah query ada dalam salah satu field
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

  // Fungsi untuk refresh data kendaraan yang akan ditampilkan secara asinkronus
  Future<void> refreshData() async {
    setState(() {
      _isLoading = true;
    });
    final request = context.read<CookieRequest>();
    try {
      final vehicles = await fetchVehicles(request); // Fetch data dari server
      setState(() {
        _allVehicles = vehicles; // Update semua list berdasarkan hasil fetch
        _filterVehicles(_searchBar); // Filter kalau ada input di search bar
        _isLoading = false; // Menghilangkan tanda loading
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              // Main layout terdapat header dan list kendaraan
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan search bar
                CatalogueHeader(onSearchChanged: _handleSearch),
                // List kendaraan, bisa discroll
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
                                      'No vehicles available. Try different keywords.',
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
                                              vehicle:
                                                  _filteredVehicles[index]),
                                        ),
                                      );
                                    },
                                    child: VehicleCard(
                                      vehicle: _filteredVehicles[index],
                                      onDelete: (String id) {
                                        setState(() {
                                          _allVehicles.removeWhere((vehicle) =>
                                              vehicle.pk.toString() == id);
                                          _filterVehicles(_searchBar);
                                        });
                                      },
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
