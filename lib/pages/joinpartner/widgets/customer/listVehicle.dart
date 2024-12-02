import 'package:flutter/material.dart';
import 'vehicleCard.dart'; // Import the VehicleCard widget

class ListVehicle extends StatelessWidget {
  final List<Map<String, String>> vehicles = [
    {
      "id": "1",
      "tipe": "Sedan",
      "warna": "Red",
      "merk": "Honda",
      "link_foto": "https://www.qoala.app/id/blog/wp-content/uploads/2022/01/mobil-sedan-toyota-Ovu0ng-Via-Shutterstock.jpg",
      "harga": "50000000",
      "status": "Sewa",
    },
    {
      "id": "2",
      "tipe": "SUV",
      "warna": "Blue",
      "merk": "Toyota",
      "link_foto": "https://www.qoala.app/id/blog/wp-content/uploads/2022/01/mobil-sedan-toyota-Ovu0ng-Via-Shutterstock.jpg",
      "harga": "60000000",
      "status": "Jual",
    },
    // Add more vehicles here...
  ];

  ListVehicle({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: vehicles.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return VehicleCard(
          tipe: vehicle['tipe']!,
          warna: vehicle['warna']!,
          merk: vehicle['merk']!,
          linkFoto: vehicle['link_foto']!,
          harga: vehicle['harga']!,
          status: vehicle['status']!,
          vehicleId: vehicle['id']!,
        );
      },
    );
  }
}
