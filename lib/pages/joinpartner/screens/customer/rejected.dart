import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/main/screens/profile.dart';
import 'registerPartner.dart'; // Import RegisterPartnerPage to navigate back for re-registration
import '../../../main/widgets/navbar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class RejectedPage extends StatefulWidget {
  const RejectedPage({super.key});

  @override
  State<RejectedPage> createState() => _RejectedPageState();
}

class _RejectedPageState extends State<RejectedPage> {
  String? partnerId;

  @override
  void initState() {
    super.initState();
    final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    _fetchPartnerData(request);
  }

  // Fetch data partner
  void _fetchPartnerData(CookieRequest request) async {
    try {
      final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/get_partner/');
      print(response);

      if (response is Map<String, dynamic> && response['status'] == 'Rejected') {
        setState(() {
          partnerId = response['id'].toString();
        });
      } else {
        throw Exception('Unexpected response format: $response');
      }
    } catch (e) {
      print('Error fetching partner data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load partner data: ${e.toString()}')),
      );
    }
  }

  // Hapus partner berdasarkan ID
  void _deletePartner(BuildContext context, CookieRequest request, String partnerId) async {
    try {
      final response = await request.get(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/delete_partner_flutter/$partnerId/',
      );

      if (response["message"] == "Partner deleted successfully") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Partner berhasil dihapus', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFF629584),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Gagal menghapus partner'),
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
    double screenWidth = MediaQuery.of(context).size.width;
    final request = Provider.of<CookieRequest>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5F8D6C),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Oops! Akun Anda belum disetujui oleh admin.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Jangan khawatir! Silakan coba lagi untuk mendaftar. Kami siap menyambut Anda!',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);

                                // Fetch data dan hapus partner jika ada
                                if (partnerId != null) {
                                  _deletePartner(context, request, partnerId!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Partner ID not found!')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize: Size(screenWidth * 0.8, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Mendaftar Kembali',
                                style: TextStyle(fontSize: 16, color: Color(0xFF5F8D6C)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          const NavBarBottom(),
        ],
      ),
    );
  }
}
