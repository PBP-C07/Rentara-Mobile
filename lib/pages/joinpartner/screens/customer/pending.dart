import 'package:flutter/material.dart';
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here

void main() {
  runApp(const PendingPageApp());
}

class PendingPageApp extends StatelessWidget {
  const PendingPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Primary color for the app
        fontFamily: 'Poppins',
      ),
      home: const PendingPage(),
    );
  }
}

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Light gray background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Increased height for the app bar
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF387478), // Background color of app bar
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30), // Adjusted top padding for better vertical centering
              child: const Text(
                'PENDING APPROVAL', // Title text
                style: TextStyle(
                  fontSize: 24, // Font size increased for prominence
                  fontWeight: FontWeight.bold, // Bold text
                  color: Colors.white, // White text color
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color(0xFF387478), // Greenish color for container
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Akun Anda sedang dalam proses persetujuan.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Silakan tunggu hingga admin menyetujui pendaftaran Anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    // OK Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White button color
                        fixedSize: const Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF387478), // Green text
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: NavBarBottom(),
          ),
        ],
      ),
    );
  }
}
