import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/reviews/models/reviews_model.dart';
import 'package:rentara_mobile/pages/reviews/screens/reviews_edit.dart';
import 'package:rentara_mobile/pages/sewajual/models/vehicle_model.dart';
import 'package:http/http.dart' as http;

class ReviewDetailPage extends StatelessWidget {
  final Reviews reviews;
  final VehicleEntry vehicle;
  final String currentUser;

  const ReviewDetailPage({super.key, required this.reviews, required this.vehicle, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 445,
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title and Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                reviews.fields.title,
                style: const TextStyle(
                  color: Color(0xFF243642),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < reviews.fields.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFFDE4D),
                    size: 24,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Description
          Container(
            constraints: const BoxConstraints(maxHeight: 56),
            child: Text(
              reviews.fields.description,
              style: const TextStyle(
                color: Color(0xFF243642),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          // User and Vehicle Information
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${reviews.fields.user} • ${reviews.fields.time.day}/${reviews.fields.time.month}/${reviews.fields.time.year}',
                style: const TextStyle(
                  color: Color(0xFF243642),
                  fontSize: 16,
                ),
              ),
              Text(
                '${vehicle.fields.merk} ${vehicle.fields.tipe} ${vehicle.fields.warna}',
                style: const TextStyle(
                  color: Color(0xFF243642),
                  fontSize: 16,
                ),
              ),
            ],
          ),
          // Edit and Delete buttons (if current user)
          if (reviews.fields.user.toString() == currentUser) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await onDelete(context, int.parse(reviews.pk)); // 'reviews.pk' adalah ID dari review
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFFC96868),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Delete'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => const EditReviewFormPage(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: const Color(0xFF629584),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Edit'),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

Future<void> onDelete(BuildContext context, int reviewId) async {
  final url = Uri.parse('https://127.0.0.1:8000/delete_reviews_flutter/');
  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token', // Ganti dengan token autentikasi jika diperlukan
      },
      body: '{"id": $reviewId}',
    );

    if (!context.mounted) return; // Cek apakah widget masih mounted sebelum menggunakan context

    if (response.statusCode == 200) {
      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } else {
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete review: ${response.body}'),
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return; // Pastikan widget masih mounted

    // Tangani error lainnya
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An error occurred: $e'),
      ),
    );
  }
}