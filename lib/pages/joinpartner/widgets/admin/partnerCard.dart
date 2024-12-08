import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerCard extends StatelessWidget {
  final String toko;
  final String linkLokasi;
  final String notelp;
  final String status;

  const PartnerCard({
    Key? key,
    required this.toko,
    required this.linkLokasi,
    required this.notelp,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Light background color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row containing partner name and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Partner name in a container with rounded corners
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF629584), // Light green color
                  ),
                  child: Text(
                    toko,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Delete button inside a rounded container with red color
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF832424), // Red color
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    // Add your delete function here
                    print('Delete button pressed');
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8), // Space between partner name and action buttons

          // Location and Phone Buttons inside containers
          Column(
            children: [
              _buildActionButton(context, linkLokasi, 'Location'),
              const SizedBox(height: 8), // Space between buttons
              _buildActionButton(context, 'tel:$notelp', 'Call'),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to build the buttons inside containers
  Widget _buildActionButton(BuildContext context, String url, String buttonLabel) {
    return Container(
      width: double.infinity, // Ensures the button spans the full width
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF629584), // Light green color
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            print('Could not launch $url');
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
