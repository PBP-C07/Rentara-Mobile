import 'package:flutter/material.dart';
import '../../../main/widgets/navbarAdmin.dart'; // Assuming NavBarBottom is located here

void main() {
  runApp(const PartnerListApp());
}

class PartnerListApp extends StatelessWidget {
  const PartnerListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Primary color #387478
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.0, // Increased height for appBar
          backgroundColor: const Color(0xFF387478), // Header color #387478
          title: const Padding(
            padding: EdgeInsets.only(top: 30), // Padding for top of the title
            child: Text(
              'LIST PARTNER',
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.0), // Extra space between appBar and content
            child: Container(),
          ),
        ),
        body: const PartnerListScreen(),
        bottomNavigationBar: NavBarBottomAdmin(),
      ),
    );
  }
}

class PartnerListScreen extends StatelessWidget {
  const PartnerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Search bar for filtering partners
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF1F1F1), // Light grey background #FAFAFA
                  hintText: 'Search pending partner',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of partner cards
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const PartnerCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  const PartnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Light background #FAFAFA
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
        children: [
          // Row containing partner name and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Partner Name in a container with rounded corners
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF629584), // #629584 Light green
                  ),
                  child: const Text(
                    'Arka Bike',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Delete button inside a rounded container with red color
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF832424), // Red #832424
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4), // Space between partner name and buttons

          // Location and Phone Buttons inside containers that match card's width
          Column(
            children: [
              _buildActionButton(context, 'Lihat Lokasi'),
              const SizedBox(height: 4), // Space between buttons
              _buildActionButton(context, 'Nomor Telepon'),
            ],
          ),
        ],
      ),
    );
  }

  // Helper widget to build the buttons inside containers
  Widget _buildActionButton(BuildContext context, String label) {
    return Container(
      width: double.infinity, // Ensures the button spans the full width
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF629584), // #629584 Light green
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          padding: EdgeInsets.zero,
        ),
        child: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
