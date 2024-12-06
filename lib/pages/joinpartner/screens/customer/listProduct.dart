import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/addVehicle.dart';
import '../../widgets/customer/vehicleCard.dart'; // Ensure path is correct
import '../../../main/widgets/navbar.dart'; // Bottom navigation bar

class ListProductPage extends StatefulWidget {
  @override
  _ListProductPageState createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  List<Map<String, dynamic>> vehicles = [
    {
      'name': 'Vario 150',
      'color': 'Hitam',
      'price': 'Rp 125,000/day',
      'status': 'sewa',
      'imageUrl': 'https://p0.pikist.com/photos/914/869/mercedes-car-auto-transport-automotive-luxury-transportation-automobile-vehicle.jpg',
    },
    {
      'name': 'Car A',
      'color': 'Red',
      'price': 'Rp 500,000/day',
      'status': 'jual',
      'imageUrl': 'https://p0.pikist.com/photos/914/869/mercedes-car-auto-transport-automotive-luxury-transportation-automobile-vehicle.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light gray background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF387478), // App bar color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Padding(
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
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            name: vehicle['name'],
            color: vehicle['color'],
            price: vehicle['price'],
            imageUrl: vehicle['imageUrl'],
            status: vehicle['status'],
          );
        },
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
        backgroundColor: Color(0xFF387478), // Green color
        child: Icon(
          Icons.add,
          color: Colors.white, // White icon
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListProductPage(),
    ));
