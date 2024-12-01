import 'package:flutter/material.dart';

class NavBarBottom extends StatelessWidget {
  const NavBarBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF2B6777),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
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