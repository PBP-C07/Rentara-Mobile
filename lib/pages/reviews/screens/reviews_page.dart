import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/reviews/widgets/reviews_card.dart';
import 'package:rentara_mobile/pages/sewajual/models/vehicle_model.dart';
import '../models/reviews_model.dart';

class ReviewsPage extends StatelessWidget {
  final List<Reviews> reviewEntries;
  final VehicleEntry vehicleEntry;
  final String currentUser;

  const ReviewsPage({super.key, required this.reviewEntries, required this.vehicleEntry, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: const Color(0xFF387478),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.5,
                ),
                itemCount: reviewEntries.length,
                itemBuilder: (context, index) {
                  final review = reviewEntries[index];
                  return GestureDetector(
                    onTap: () {
                      // Ketika review ditekan, navigate ke halaman ReviewDetailPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewDetailPage(
                            reviews: review,
                            vehicle: vehicleEntry,  // Pastikan review memiliki informasi kendaraan
                            currentUser: currentUser,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.fields.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    index < review.fields.rating ? Icons.star : Icons.star_border,
                                    color: const Color(0xFFFFDE4D),
                                    size: 20,
                                  );
                                }),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Description
                          Text(
                            review.fields.description,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          // User and Vehicle Info
                          Text(
                            '${review.fields.user} • ${review.fields.time}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            '${vehicleEntry.fields.merk} ${vehicleEntry.fields.tipe} ${vehicleEntry.fields.warna}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addReview'); // Ganti dengan route halaman tambah review
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF387478),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const SizedBox(
                width: 140,
                child: Text(
                  'Add Review',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}