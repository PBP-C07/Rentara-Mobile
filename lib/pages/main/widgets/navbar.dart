import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/bookmark/favorite.dart';
import 'package:rentara_mobile/pages/rentdriver/screens/customer/list_rentdriver.dart';
import '../../sewajual/screens/user/catalogue.dart';
import '../../main/screens/home.dart';
import '../../main/screens/profile.dart';

class NavBarBottom extends StatelessWidget {
  const NavBarBottom({super.key});

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
                        MyHomePage(),
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        CarCatalogueScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                  FavoritesPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                ),
              );
              },
            ),
            IconButton(
              icon: const Icon(Icons.drive_eta_outlined, color: Colors.white),
              onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                  DriverListApp(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
                ),
              );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ProfilePage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
