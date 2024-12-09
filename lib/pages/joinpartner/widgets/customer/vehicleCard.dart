import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/editVehicle.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class VehicleCard extends StatelessWidget {
  final String vehicleId; // Tambahkan parameter vehicleId
  final String name;
  final String color;
  final String price;
  final String imageUrl;
  final String status;

  const VehicleCard({
    Key? key,
    required this.vehicleId, // Terima vehicleId di konstruktor
    required this.name,
    required this.color,
    required this.price,
    required this.imageUrl,
    required this.status,
  }) : super(key: key);

  Future<void> deleteVehicle(String vehicleId, CookieRequest request, BuildContext context) async {
    try {
      // Memanggil endpoint API DELETE
      final response = await request.get(
        'http://127.0.0.1:8000/delete_vehicle_flutter/$vehicleId/',
      );

      if (response["message"]=="Vehicle deleted successfully") {
        // Jika penghapusan berhasil (status 200)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Kendaraan berhasil dihapus'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context); // Kembali ke halaman sebelumnya setelah delete
      } else {
        // Jika ada masalah dengan request
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menghapus kendaraan'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      // Tangani error jika koneksi gagal
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $error'),
        backgroundColor: Colors.red,
      ));
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final CookieRequest request = CookieRequest(); // Inisialisasi CookieRequest

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  imageUrl,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Icon(Icons.car_rental, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF629584),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      color,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditVehiclePage(vehicleId: vehicleId), // Pass vehicleId here
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF387478),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Panggil fungsi delete
                          deleteVehicle(vehicleId, request, context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF832424),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
