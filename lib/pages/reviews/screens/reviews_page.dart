import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/reviews/screens/reviews_form.dart';
import 'package:rentara_mobile/pages/reviews/widgets/reviews_card.dart';
import 'package:rentara_mobile/pages/sewajual/models/vehicle_model.dart';
import '../models/reviews_model.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPage();
}

class _ReviewPage extends State<ReviewPage> {
  Future<List<Reviews>> fetchReviews(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json/show-reviews/');

    // Decode response into JSON
    var data = response;

    // Convert JSON data into Review objects
    List<Reviews> reviewList = [];
    for (var d in data) {
      if (d != null) {
        reviewList.add(Reviews.fromJson(d));  // Assuming you have a Review model with fromJson method
      }
    }
    return reviewList;
  }

  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/json/vehicles/');

    // Decode response into JSON
    var data = response;

    // Convert JSON data into Vehicle objects
    List<VehicleEntry> vehicleList = [];
    for (var d in data) {
      if (d != null) {
        vehicleList.add(VehicleEntry.fromJson(d));  // Assuming you have a Vehicle model with fromJson method
      }
    }
    return vehicleList;
  }

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
        child: FutureBuilder(
          future: Future.wait([
            fetchReviews(context.watch<CookieRequest>()),
            fetchVehicles(context.watch<CookieRequest>()),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No reviews available.',
                    style: TextStyle(fontSize: 20, color: Color(0xFF7EACB5)),
                  ),
                );
              } else {
                List<Reviews> reviews = snapshot.data![0];
                List<VehicleEntry> vehicles = snapshot.data![1];

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    final vehicle = vehicles.firstWhere(
                      (v) => v.pk == review.pk,  // Assuming you have a way to match the vehicle to the review
                    );
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewDetailPage(
                              reviews: review,
                              vehicle: vehicle,
                              currentUser: '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
                          ],
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
                            // User Info
                            Text(
                              '${review.fields.user} • ${review.fields.time}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            // Vehicle Info
                            Text(
                              '${vehicle.fields.merk} ${vehicle.fields.tipe} ${vehicle.fields.warna}',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
      // Add Review Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateReviewFormPage()), // Direct navigation
          );
        },
        backgroundColor: const Color(0xFF387478),
        child: const Icon(Icons.add),
      ),
    );
  }
}