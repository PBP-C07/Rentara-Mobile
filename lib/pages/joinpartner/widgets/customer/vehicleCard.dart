import 'package:flutter/material.dart';

class VehicleCard extends StatelessWidget {
  final String tipe;
  final String warna;
  final String merk;
  final String linkFoto;
  final String harga;
  final String status;
  final String vehicleId;

  const VehicleCard({
    super.key,
    required this.tipe,
    required this.warna,
    required this.merk,
    required this.linkFoto,
    required this.harga,
    required this.status,
    required this.vehicleId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Slightly more elevation for a sleek, shadowed effect
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with product name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Vehicle Type and Color
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tipe,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF656565),
                        overflow: TextOverflow.ellipsis, // Prevent overflow for long text
                      ),
                    ),
                    Text(
                      '$warna',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF656565),
                      ),
                    ),
                  ],
                ),
                // Vehicle Status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF629584), // Green for available, red for unavailable
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // Vehicle image with a clean, centered look
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                linkFoto,
                width: double.infinity,
                height: 180, // Membatasi tinggi gambar
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error, color: Colors.red));
                },
              ),
            ),
            const SizedBox(height: 2),

            // Vehicle brand with a label and value aligned
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🏷️Merk',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF656565),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    merk,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF656565),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0),

            // Pricing information with a clear highlight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💰Harga',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF656565),
                  ),
                ),
                const SizedBox(width: 0),
                Text(
                  'Rp$harga,-',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF656565), // Updated green color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

            // Edit and Delete buttons aligned closer and with modern style
            Row(
              children: [
                // Tombol Edit yang mengisi seluruh lebar Row
                Expanded(
                  child: _buildActionButton(context, 'Edit', const Color(0xFF387478), vehicleId),
                ),
                const SizedBox(width: 8), // Memberikan jarak antar tombol
                // Tombol Delete yang mengisi seluruh lebar Row
                Expanded(
                  child: _buildActionButton(context, 'Delete', const Color(0xFF832424), vehicleId, isDelete: true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget to build the buttons with shadow effects and modern look
  Widget _buildActionButton(BuildContext context, String text, Color color, String vehicleId, {bool isDelete = false}) {
    return GestureDetector(
      onTap: () {
        if (isDelete) {
          confirmDelete(context, vehicleId);
        } else {
          Navigator.pushNamed(context, '/edit_product', arguments: vehicleId);
        }
      },
      child: Material(
        elevation: 3, // Slight elevation for modern button effect
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 2, // Consistent padding to adjust button height
            horizontal: 10, // Horizontal padding for symmetry
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          // Center the text inside the button to prevent overflow
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14, // Adjust font size to prevent overflow
                overflow: TextOverflow.ellipsis, // Prevent text overflow
              ),
            ),
          ),
        ),
      ),
    );
  }

  void confirmDelete(BuildContext context, String vehicleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this vehicle?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Implement actual deletion logic here
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
