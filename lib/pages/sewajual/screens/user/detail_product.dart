import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/reviews/screens/reviews_page.dart';
import '../../models/vehicle_model.dart';
import '../../widgets/user/drawer_price.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatelessWidget {
  final VehicleEntry vehicle;

  const CarDetailScreen({Key? key, required this.vehicle}) : super(key: key);

  Future<void> _launchMaps(BuildContext context) async {
    try {
      final Uri url = Uri.parse(vehicle.fields.linkLokasi);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar(context, "Couldn't open maps");
      }
    } catch (e) {
      _showErrorSnackBar(context, "Error opening maps");
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: const Color.fromARGB(255, 138, 38, 31),
        ),
      );
    }
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
    Color? backgroundColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor ?? Colors.black87,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildMoreInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF2B6777).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF2B6777),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isRent = vehicle.fields.status == Status.SEWA;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        vehicle.fields.linkFoto,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildButton(
                                icon: Icons.arrow_back,
                                onPressed: () => Navigator.pop(context),
                              ),
                              _buildButton(
                                icon: Icons.favorite_border,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                                backgroundColor: isRent
                                    ? const Color.fromARGB(255, 71, 132, 111)
                                    : const Color.fromARGB(255, 166, 48, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                isRent ? 'RENT' : 'SELL',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            const Text(
                              '4.5',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                text: ' (20 reviews)', // The main text
                                style: const TextStyle(color: Colors.grey), // The text style
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ReviewPage()),
                                    );
                                  },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('More Information'),
                        _buildInfoContainer(
                          Row(
                            children: [
                              Expanded(
                                child: _buildMoreInfo(
                                  icon: Icons.palette,
                                  label: 'Color',
                                  value: vehicle.fields.warna,
                                ),
                              ),
                              Container(
                                height: 80,
                                width: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),
                              Expanded(
                                child: _buildMoreInfo(
                                  icon: Icons.local_gas_station,
                                  label: 'Fuel Type',
                                  value: bahanBakarValues
                                      .reverse[vehicle.fields.bahanBakar]!,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Store Information'),
                        _buildInfoContainer(
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2B6777)
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.store,
                                      color: Color(0xFF2B6777),
                                      size: 24,
                                    ),
                                  ),
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
                                onTap: () => _launchMaps(context),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Color(0xFF2B6777),
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'View Location',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.grey,
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
          ),
          BottomPriceDrawer(
            price: '${vehicle.fields.harga}',
            phoneNumber: vehicle.fields.notelp,
            isRent: isRent,
          ),
        ],
      ),
    );
  }
}
