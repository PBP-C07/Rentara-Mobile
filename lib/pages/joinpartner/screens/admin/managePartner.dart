import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/admin/listPartner.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/admin/pendingPartner.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:rentara_mobile/pages/main/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/Partner.dart';
import '../../../main/widgets/navbarAdmin.dart';

void main() {
  runApp(const ManagePartnerApp());
}

class ManagePartnerApp extends StatelessWidget {
  const ManagePartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.0,
          backgroundColor: const Color(0xFF387478),
          title: const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              'MANAGE PARTNER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        body: ManagePartnerScreen(),
        bottomNavigationBar: NavBarBottomAdmin(),
      ),
    );
  }
}

class ManagePartnerScreen extends StatelessWidget {
  ManagePartnerScreen({super.key});

  Future<Map<String, List<Partner>>> fetchPartners(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/partner_json/');

      if (response is List) {
        List<Partner> partners = response.map((json) => Partner.fromJson(json)).toList();
        List<Partner> approvedPartners =
            partners.where((partner) => partner.fields.status == 'Approved').toList();
        List<Partner> pendingPartners =
            partners.where((partner) => partner.fields.status == 'Pending').toList();

        return {
          'approved': approvedPartners,
          'pending': pendingPartners,
        };
      } else {
        throw Exception('Unexpected response format: ${response.runtimeType}');
      }
    } catch (e) {
      debugPrint('Error fetching partners: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);

    return FutureBuilder<Map<String, List<Partner>>>(
      future: fetchPartners(request),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        } else {
          final approvedPartners = snapshot.data!['approved'] ?? [];
          final pendingPartners = snapshot.data!['pending'] ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Display total number of partners
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Number of Partners',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2F635C),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF2F635C),
                        child: Text(
                          '${approvedPartners.length + pendingPartners.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Display partner details
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text(
                          'Accepted Partners',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2F635C),
                          ),
                        ),
                        trailing: Text(
                          '${approvedPartners.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2F635C),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PartnerListApp(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        title: const Text(
                          'Pending Partners',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2F635C),
                          ),
                        ),
                        trailing: Text(
                          '${pendingPartners.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF2F635C),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PendingPartnerApp(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Logout button
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        final response = await request.logout(
                          "http://127.0.0.1:8000/auth/logout/",
                        );
                        if (response['status'] == true) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(response['message']),
                                backgroundColor: const Color(0xFF557B83),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Logout failed"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Error: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4545),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
