import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import '../../widgets/user/drawer_price.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatelessWidget {
  final VehicleEntry vehicle;

  const CarDetailScreen({Key? key, required this.vehicle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        child: Image.network(
                          vehicle.fields.linkFoto,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${vehicle.fields.merk} ${vehicle.fields.tipe}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2B6777),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                'RENT',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(' 4.5 (20 reviews)'),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'More Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFeatureItem(
                              title: vehicle.fields.warna,
                              icon: Icons.palette,
                            ),
                            _buildFeatureItem(
                              title: bahanBakarValues
                                  .reverse[vehicle.fields.bahanBakar]!,
                              icon: Icons.local_gas_station,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Store Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.store, color: Colors.grey[700]),
                                  const SizedBox(width: 12),
                                  Text(
                                    vehicle.fields.toko,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              InkWell(
                                onTap: () {},
                                child: Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Colors.grey[700]),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'View Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 90,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/001/214/732/original/black-and-yellow-stripes-pattern-vector.jpg'),
                    repeat: ImageRepeat.repeatX,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomPriceDrawer(
                price: 'Rp ${vehicle.fields.harga}/day',
                onContactPressed: () async {
                  final url =
                      'https://wa.me/${vehicle.fields.notelp.replaceAll(RegExp(r'[^\d+]'), '')}';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Couldn't launch WhatsApp"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({required String title, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
