import 'package:flutter/material.dart';

class NavBarBottom extends StatelessWidget {
  const NavBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFF2B6777),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: const SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.explore, color: Colors.white),
            Icon(Icons.favorite_border, color: Colors.white),
            Icon(Icons.directions_car, color: Colors.white),
            Icon(Icons.person_outline, color: Colors.white),
          ],
        ),
      ),
    );
  }
}