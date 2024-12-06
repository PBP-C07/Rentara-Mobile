import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/customer/listProduct.dart';
import 'registerPartner.dart';
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here

void main() {
  runApp(const ProfilePageApp());
}

class ProfilePageApp extends StatelessWidget {
  const ProfilePageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Updated color to match the palette
        fontFamily: 'Poppins',
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Increased height for the app bar
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF387478), // Background color of app bar
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30), // Adjusted top padding for better vertical centering
              child: const Text(
                'PROFILE', // Title of the app bar
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Profile Picture and Name Section
              Center(
                child: Column(
                  children: [
                    // Circle Avatar with green background
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF4B7C6D), // Green background
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Arka Bike', // Example name
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
              // List Options Section
              Column(
                children: [
                  buildOptionTile(
                    'Join Partner',
                    Icons.handshake,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPartnerPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('My Products', 
                                  Icons.shopping_cart,
                                  onTap: (){
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ListProductPage(),
                                    ),
                                  );
                                  }),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('Bookmark', Icons.bookmark),
                  const SizedBox(height: 16), // Add space between tiles
                  buildOptionTile('Report', Icons.report),
                ],
              ),
              const SizedBox(height: 30), // Add spacing before the logout button
              // Logout Button Section
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
      // Add NavBarBottom at the bottom
      bottomNavigationBar: const NavBarBottom(), // Add your NavBarBottom widget here
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
