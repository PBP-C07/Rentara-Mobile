import 'package:flutter/material.dart';
import 'registerPartner.dart';

void main() {
  runApp(ProfilePageApp());
}

class ProfilePageApp extends StatelessWidget {
  const ProfilePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B7C6D),
        fontFamily: 'Poppins',
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B7C6D),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Profile Picture and Name
              Center(
                child: Column(
                  children: [
                    // Circle Avatar with green background
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4B7C6D),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Arka Bike',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B7C6D),
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Edit Profile Button
                    ElevatedButton(
                      onPressed: () {
                        // Action to edit profile
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B7C6D),
                        fixedSize: Size(screenWidth * 0.8, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30), // Adjust the gap between profile and menu items
              // List Options
              Column(
                children: [
                  buildOptionTile(
                    'Join Partner',
                    Icons.handshake,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPartnerPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('My Products', Icons.shopping_cart),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('Bookmark', Icons.bookmark),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('Report', Icons.report),
                ],
              ),
              const SizedBox(height: 30), // Add spacing before the logout button
              // Logout Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF832424),
                  fixedSize: Size(screenWidth * 0.8, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for ListTile options
  ListTile buildOptionTile(String title, IconData icon, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF4B7C6D),
        size: 28,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: 20,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
