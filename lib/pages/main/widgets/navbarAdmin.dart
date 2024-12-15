import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../joinpartner/screens/admin/managePartner.dart';
import '../../sewajual/screens/admin/catalgoue_admin.dart';
import '../screens/home.dart';

void main() {
  runApp(const NavBarBottomAdmin());
}

class NavBarBottomAdmin extends StatelessWidget {
  const NavBarBottomAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF2B6777),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ManagePartnerApp(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (route) => false,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.explore, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ProductCatalogueAdmin(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (route) => false,
                );
              },
            ),
            const Icon(Icons.drive_eta_outlined, color: Colors.white),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () async {
                final request = context.watch<CookieRequest>();
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
                        content: Text("Logout gagal"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
