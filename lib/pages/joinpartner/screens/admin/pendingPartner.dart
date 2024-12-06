import 'package:flutter/material.dart';
import '../../../main/widgets/navbarAdmin.dart'; // Assuming NavBarBottom is located here

void main() {
  runApp(const PendingPartnerApp());
}

class PendingPartnerApp extends StatelessWidget {
  const PendingPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Warna utama
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), // Height for the app bar
          child: AppBar(
            backgroundColor: const Color(0xFF387478), // Warna utama
            title: const Padding(
              padding: EdgeInsets.only(top: 30), // Padding for top space
              child: Text(
                'PENDING PARTNER',
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
              preferredSize: Size.fromHeight(10.0), // Extra space below app bar
              child: Container(),
            ),
          ),
        ),
        body: const PendingPartnerScreen(),
        bottomNavigationBar: NavBarBottomAdmin(),
      ),
    );
  }
}

class PendingPartnerScreen extends StatelessWidget {
  const PendingPartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar for filtering partners
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFA), // Warna latar belakang input
                hintText: 'Search pending partner',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF387478)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
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
                return const PendingPartnerCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PendingPartnerCard extends StatelessWidget {
  const PendingPartnerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA), // Background color for the card
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partner name with a different background color
          Container(
            width: double.infinity, // Full width of the card
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF387478), // Light green background for name
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Arka Bike',
              style: TextStyle(
                fontWeight: FontWeight.w600, // Semi-bold
                fontSize: 16,
                color: Colors.white, // White text
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          
          // Address and Phone number with matching Container widths
          Column(
            children: [
              Container(
                width: double.infinity, // Full width of the card
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F4F), // Dark green container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '123 Main Street',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity, // Full width of the card
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F4F), // Dark green container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+123 456 7890',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Accept/Reject buttons inside Expanded widgets
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832424), // Red color for reject button
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500 ), // White text for reject button
                    ),
                  ),
                ),
                const SizedBox(width: 3), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF387478), // Main color for accept button
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white), // White text for accept button
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
