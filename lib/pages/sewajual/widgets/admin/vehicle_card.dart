import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_model.dart';
import '../../screens/admin/edit_vehicle.dart';

class VehicleCard extends StatelessWidget {
  final VehicleEntry vehicle;
  final VoidCallback onEditComplete;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.onEditComplete,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(vehicle.fields.linkFoto),
                      fit: BoxFit.cover,
                      onError: (_, __) =>
                          const AssetImage('assets/placeholder.png'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.fields.merk} ${vehicle.fields.tipe}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Store: ${vehicle.fields.toko}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusValues.reverse[vehicle.fields.status]!,
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VehicleEditFormPage(
                            vehicle: vehicle,
                          ),
                        ),
                      ).then((_) => onEditComplete());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2B6777),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Edit',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text("Delete this product?"),
                                actions: [
                                  TextButton(
                                    child: Text("Yes",
                                        style:
                                            TextStyle(color: Colors.teal[700])),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ));

                      if (confirm) {
                        try {
                          final response = await request.postJson(
                            "http://127.0.0.1:8000/vehicles/adm/${vehicle.pk}/delete/",
                            "{}",
                          );
                          if (response['status'] == 'success') {
                            onEditComplete();
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Error, failed to delete.")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 200, 72, 72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
