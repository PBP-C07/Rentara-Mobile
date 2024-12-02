import 'package:flutter/material.dart';
import '../../sewajual/screens/catalogue.dart';
import '../../main/screens/home.dart';

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
      child: const SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
              child: Icon(Icons.home, color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarCatalogueScreen(),
                  ),
                );
              },
              child: const Icon(Icons.explore, color: Colors.white),
            ),
            const Icon(Icons.favorite_border, color: Colors.white),
            const Icon(Icons.directions_car, color: Colors.white),
            const Icon(Icons.person_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }
}