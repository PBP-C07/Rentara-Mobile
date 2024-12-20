import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/vehicle_model.dart';
import '../../screens/user/detail_product.dart';
import '../../../main/screens/login.dart';

class CarCard extends StatelessWidget {
  final VehicleEntry vehicle;

  const CarCard({
    Key? key,
    required this.vehicle,
  }) : super(key: key);

  String formatPrice(int price) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(price);
  }

  Widget _buildFeature(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(Status status) {
    final bool isRent = status == Status.SEWA;
    final Color statusColor = isRent
        ? const Color.fromARGB(255, 71, 132, 111)
        : const Color.fromARGB(255, 166, 48, 48);
    final String statusText = isRent ? 'Rent' : 'Sell';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isRent ? Icons.time_to_leave : Icons.sell,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        final username = prefs.getString('username');

        if (context.mounted) {
          if (username != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarDetailScreen(vehicle: vehicle),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    vehicle.fields.linkFoto,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.error_outline, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _buildStatusBadge(vehicle.fields.status),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${vehicle.fields.merk} ${vehicle.fields.tipe}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B6777),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formatPrice(vehicle.fields.harga),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            if (vehicle.fields.status == Status.SEWA)
                              const Text(
                                '/day',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vehicle.fields.toko,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildFeature(Icons.palette, vehicle.fields.warna),
                      const SizedBox(width: 16),
                      _buildFeature(
                        Icons.local_gas_station,
                        bahanBakarValues.reverse[vehicle.fields.bahanBakar]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
