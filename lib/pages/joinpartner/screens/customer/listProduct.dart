import 'package:flutter/material.dart';
import 'package:rentara_mobile/main.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/addVehicle.dart';
import '../../widgets/customer/vehicleCard.dart'; // Ensure path is correct
import '../../../main/widgets/navbar.dart'; // Bottom navigation bar
import '../../../sewajual/models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ListProductPage extends StatefulWidget {
  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  late Future<List<VehicleEntry>> futureVehicles;
  List<VehicleEntry> allVehicles = [];
  List<VehicleEntry> filteredVehicles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final CookieRequest request = CookieRequest();
    futureVehicles = fetchVehicles(request);
    searchController.addListener(_filterVehicles);
  }

  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/json_by_partner/');
      if (response != null && response is List) {
        List<VehicleEntry> vehicleList = response.map((data) => VehicleEntry.fromJson(data)).toList();
        setState(() {
          allVehicles = vehicleList;
          filteredVehicles = vehicleList;
        });
        return vehicleList;
      } else {
        throw Exception('Failed to load vehicles.');
      }
    } catch (e) {
      debugPrint('Error fetching vehicles: $e');
      throw Exception('Error fetching vehicles.');
    }
  }

  void _filterVehicles() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredVehicles = allVehicles.where((vehicle) {
        return vehicle.fields.tipe.toLowerCase().contains(query) ||
               vehicle.fields.merk.toLowerCase().contains(query) ||
               vehicle.fields.warna.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF387478),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: const Text(
                  'YOUR PRODUCT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search your product...',
                prefixIcon: Icon(Icons.search, color: Color(0xFF387478)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<VehicleEntry>>(
              future: futureVehicles, // Gunakan futureVehicles yang sudah diinisialisasi
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final vehicles = filteredVehicles.isNotEmpty ? filteredVehicles : snapshot.data!;
                  return ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      final fields = vehicle.fields;
                      return VehicleCard(
                        vehicleId: vehicle.pk,
                        name: fields.tipe,
                        color: fields.warna,
                        price: fields.harga.toString(),
                        imageUrl: fields.linkFoto,
                        status: fields.status.toString().split('.').last,
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No vehicles found.'));
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBarBottom(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehiclePage(),
            ),
          );
        },
        backgroundColor: Color(0xFF387478),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}


void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListProductPage(),
    ));
