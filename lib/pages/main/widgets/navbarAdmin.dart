import 'package:flutter/material.dart';
import '../../joinpartner/screens/admin/managePartner.dart';
import '../../sewajual/screens/admin/form_vehicle.dart';
import '../../sewajual/screens/admin/catalgoue_admin.dart';

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
            IconButton(
              icon: const Icon(Icons.add_box_rounded, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        VehicleEntryFormPage(),
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
              onPressed: () {
                //placeholder
              },
            ),
          ],
        ),
      ),
    );
  }
}
