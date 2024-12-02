import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/widgets/customer/vehicleCard.dart'; // Import VehicleCard widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2C8C8B), // Use teal color
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 4, // Slight elevation for AppBar
          color: Color(0xFF2C8C8B), // Set the app bar color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'YOUR PRODUCTS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4B7C6D),
          centerTitle: true,
          elevation: 2,
        ),
        body: Stack( // Stack widget to allow positioning elements freely
          children: [
            ListProduct(), // The list of products displayed on the screen
            Positioned(
              bottom: 20, // Distance from the bottom of the screen
              right: 20, // Distance from the right edge of the screen
              child: Draggable(
                feedback: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF387478), // Background color of the button
                    shape: BoxShape.circle, // Make it circular
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white, // Color of the icon
                    size: 30,
                  ),
                ),
                childWhenDragging: const SizedBox(), // When dragging, show nothing at the original position
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF387478), // Background color of the button
                    shape: BoxShape.circle, // Make it circular
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white, // Color of the icon
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListProduct extends StatelessWidget {
  final List<Map<String, String>> products = [
    {
      "id": "1",
      "tipe": "Sedan",
      "warna": "Red",
      "merk": "Honda",
      "link_foto": "https://autoepcservice.com/autoepc/wp-content/uploads/2022/03/Toyota-Camry-2020-Electrical-Wiring-Diagram-0-600x337.jpg",
      "harga": "500000",
      "status": "Available",
    },
    {
      "id": "2",
      "tipe": "SUV",
      "warna": "Blue",
      "merk": "Toyota",
      "link_foto": "https://autoepcservice.com/autoepc/wp-content/uploads/2022/03/Toyota-Camry-2020-Electrical-Wiring-Diagram-0-600x337.jpg",
      "harga": "600000",
      "status": "Rented",
    },
    // Add more products here...
  ];

  ListProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return VehicleCard(
          tipe: product['tipe']!,
          warna: product['warna']!,
          merk: product['merk']!,
          linkFoto: product['link_foto']!,
          harga: product['harga']!,
          status: product['status']!,
          vehicleId: product['id']!,
        );
      },
    );
  }
}
