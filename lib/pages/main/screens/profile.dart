import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/editProfile.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/listProduct.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/pending.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/registerPartner.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/rejected.dart';
import 'package:rentara_mobile/pages/main/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../sewajual/screens/admin/catalgoue_admin.dart';
import 'login.dart';
import 'register.dart';
import '../widgets/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  bool isLoading = true;
  bool isPartner = false;
  bool isStaff = false;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      isLoading = false;
      isPartner = prefs.getBool('isPartner') ?? false;
      isStaff = prefs.getBool('isStaff') ?? false;
    });
  }

  Future<bool> checkPartnerStatus(CookieRequest request) async {
    try {
      // Mengirimkan permintaan GET ke server
      final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/check_status/');
      print(response);

      return response['is_partner'] ?? false;
    } catch (e) {
      // Menangani kesalahan
      print('Error: $e');
      return false; // Mengembalikan false jika terjadi kesalahan
    }
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF87A8A1),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF87A8A1),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.chevron_right,
            color: Color(0xFF87A8A1),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF557B83),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildGuestView() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Color(0xFF87A8A1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Ready to surf more?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF557B83),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sign in to access all features and personalize your experience!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF557B83),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF557B83)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF557B83),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarBottom(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(CookieRequest request) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              username ?? "",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF557B83),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 120,
                              height: 120,
                              decoration: const BoxDecoration(
                                color: Color(0xFF87A8A1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  username != null && username!.isNotEmpty
                                      ? username![0].toUpperCase()
                                      : "U",
                                  style: const TextStyle(
                                    fontSize: 48,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          try {
                            final response = await request
                                .get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/check_status/');
                            bool isPartner = await checkPartnerStatus(request);
                            // String status = response['status'];
                            print(response);
                            // print('isPartner status: $isPartner'); // Debugging output
                            if (isPartner && response['status'] == 'Approved') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditPartnerApp(),
                                ),
                              );
                            } 
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                        },
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFF87A8A1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          try {
                            final response = await request
                                .get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/check_status/');
                            bool isPartner = await checkPartnerStatus(request);
                            // String status = response['status'];
                            print(response);
                            // print('isPartner status: $isPartner'); // Debugging output
                            if (isPartner && response['status'] == 'Approved') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListProductPage(),
                                ),
                              );
                            } else if (isPartner &&
                                response['status'] == 'Pending') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PendingPageApp(),
                                ),
                              );
                            } else if (isPartner &&
                                response['status'] == 'Rejected') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RejectedPage(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterPartnerApp(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: _buildMenuItem('Join Partner', Icons.handshake),
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            final response = await request
                                .get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/check_status/');
                            bool isPartner = await checkPartnerStatus(request);
                            // String status = response['status'];
                            print(response);
                            // print('isPartner status: $isPartner'); // Debugging output
                            if (isPartner && response['status'] == 'Approved') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListProductPage(),
                                ),
                              );
                            } else if (isPartner &&
                                response['status'] == 'Pending') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PendingPageApp(),
                                ),
                              );
                            } else if (isPartner &&
                                response['status'] == 'Rejected') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RejectedPage(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterPartnerApp(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child:
                            _buildMenuItem('My Products', Icons.shopping_bag),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _buildMenuItem('Bookmark', Icons.bookmark),
                      ),
                      InkWell(
                        onTap: () {},
                        child: _buildMenuItem('Report', Icons.flag),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: ElevatedButton(
                          onPressed: () async {
                            final response = await request.logout(
                              "https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/auth/logout/",
                            );
                            if (response['status'] == true) {
                              final prefs =
                                  await SharedPreferences.getInstance();
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
                                    content: Text("Logout gagal"),
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
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarBottom(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (isStaff) {
      return const ProductCatalogueAdmin();
    }

    return username == null ? _buildGuestView() : _buildUserProfile(request);
  }
}
