import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/admin/listPartner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PartnerCard extends StatelessWidget {
  final String partnerId;
  final String toko;
  final String linkLokasi;
  final String notelp;
  final String status;

  const PartnerCard({
    Key? key,
    required this.toko,
    required this.linkLokasi,
    required this.notelp,
    required this.status,
    required this.partnerId,
  }) : super(key: key);

  static Future<void> deletePartner(String partnerId, CookieRequest request, BuildContext context) async {
    try {
      final response = await request.get(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/delete_partner_flutter/$partnerId/',
      );
      print(response);

      if (response["message"] == "Partner deleted successfully") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Partner berhasil dihapus', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF629584),
        ));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PartnerListApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal menghapus partner'),
          backgroundColor: const Color(0xFF832424),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan: $error'),
        backgroundColor: const Color(0xFF832424),
      ));
      print('Terjadi kesalahan: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final CookieRequest request = CookieRequest();
    return ListView(
      padding: const EdgeInsets.all(16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F1F1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
              ),
            ],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFF629584),
                      ),
                      child: Text(
                        toko,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF832424),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: () {
                        deletePartner(partnerId, request, context);
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                ],
              ),
              _buildActionButton(context, linkLokasi, 'Location'),
              _buildActionButton(context, 'tel:$notelp', 'Call'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String url, String buttonLabel) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF629584),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            print('Could not launch $url');
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
