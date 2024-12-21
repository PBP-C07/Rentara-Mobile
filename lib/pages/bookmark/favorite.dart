import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/main/widgets/navbar.dart';
import 'package:rentara_mobile/pages/sewajual/models/vehicle_model.dart';
import 'package:rentara_mobile/pages/sewajual/screens/user/detail_product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main/screens/login.dart';

enum SortOption { hargaNaik, alphabetical, rentOnly, sellOnly }

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String _searchQuery = '';
  List<VehicleEntry> _vehicles = [];
  List<VehicleEntry> _filteredVehicles = [];
  bool _isLoading = true;
  SortOption? _currentSort;

  @override
  void initState() {
    super.initState();
    _initializeData();
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
    final response = await request.get('http://127.0.0.1:8000/vehicle/json/');
    return vehicleEntryFromJson(jsonEncode(response));
  }

  void _filterVehicles(String query) {
    if (query.isEmpty) {
      _filteredVehicles = List.from(_vehicles);
    } else {
      final searchLower = query.toLowerCase();
      _filteredVehicles = _vehicles.where((vehicle) {
        final fields = vehicle.fields;
        final searchableStrings = [
          fields.merk.toLowerCase(),
          fields.tipe.toLowerCase(),
          fields.toko.toLowerCase(),
          fields.warna.toLowerCase(),
          jenisKendaraanValues.reverse[fields.jenisKendaraan]?.toLowerCase() ?? '',
          bahanBakarValues.reverse[fields.bahanBakar]?.toLowerCase() ?? '',
        ];
        return searchableStrings.any((text) => text.contains(searchLower));
      }).toList();
    }
    _applySorting();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_currentSort != null)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _currentSort = null;
                            _filteredVehicles = List.from(_vehicles);
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: Color(0xFF2B6777)),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListView(
                shrinkWrap: true,
                children: [
                  _buildFilterOption(
                    title: 'Price: Low to High',
                    icon: Icons.arrow_upward,
                    option: SortOption.hargaNaik,
                    context: context,
                  ),
                  _buildFilterOption(
                    title: 'Name (A-Z)',
                    icon: Icons.sort_by_alpha,
                    option: SortOption.alphabetical,
                    context: context,
                  ),
                  _buildFilterOption(
                    title: 'Show Rental Only',
                    icon: Icons.car_rental,
                    option: SortOption.rentOnly,
                    context: context,
                  ),
                  _buildFilterOption(
                    title: 'Show Sell Only',
                    icon: Icons.sell,
                    option: SortOption.sellOnly,
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption({
    required String title,
    required IconData icon,
    required SortOption option,
    required BuildContext context,
  }) {
    final isSelected = _currentSort == option;
    return InkWell(
      onTap: () {
        setState(() {
          _currentSort = option;
          _filteredVehicles = List.from(_vehicles);
          _applySorting();
        });
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B6777).withOpacity(0.1) : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF2B6777) : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFF2B6777) : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check,
                color: Color(0xFF2B6777),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _applySorting() {
    List<VehicleEntry> tempList = List.from(_filteredVehicles);

    switch (_currentSort) {
      case SortOption.hargaNaik:
        tempList.sort((a, b) => a.fields.harga.compareTo(b.fields.harga));
        break;
      case SortOption.alphabetical:
        tempList.sort((a, b) =>
            a.fields.merk.toLowerCase().compareTo(b.fields.merk.toLowerCase()));
        break;
      case SortOption.rentOnly:
        tempList = tempList
            .where((vehicle) => vehicle.fields.status == Status.SEWA)
            .toList();
        break;
      case SortOption.sellOnly:
        tempList = tempList
            .where((vehicle) => vehicle.fields.status == Status.JUAL)
            .toList();
        break;
      default:
        break;
    }

    setState(() {
      _filteredVehicles = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBarBottom(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF2B6777),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'FAVORITES',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600]),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                      _filterVehicles(value);
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Search by name',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Stack(
                          children: [
                            Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 28,
                            ),
                            if (_currentSort != null)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () => _showFilterBottomSheet(context),
                      ),
                    ],
                  ),
                ],
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '${_filteredVehicles.length} Products Found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredVehicles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_border,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No favorites found',
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: _filteredVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = _filteredVehicles[index];
                            return _buildVehicleCard(vehicle);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleEntry vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(vehicle.fields.linkFoto),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: vehicle.fields.status == Status.SEWA
                          ? const Color(0xFF2B6777)
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vehicle.fields.status == Status.SEWA ? 'Sewa' : 'Jual',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  vehicle.fields.merk,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                  vehicle.fields.tipe,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                  'Rp ${vehicle.fields.harga}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                ],
                ),
              ),
              ],
            ),
            ),
          );
          
          }
        }

        