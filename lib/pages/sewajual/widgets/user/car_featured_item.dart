import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const FeatureItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFCCE7E8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Color(0xFF2B6777)),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2B6777),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}