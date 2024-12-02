import 'package:flutter/material.dart';

void main() {
  runApp(PendingPageApp());
}

class PendingPageApp extends StatelessWidget {
  const PendingPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B7C6D), // Matching green color
        fontFamily: 'Poppins',
      ),
      home: PendingPage(),
    );
  }
}

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background color as before
      appBar: AppBar(
        title: const Text(
          'Pending Approval',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4B7C6D), // Green app bar to match the theme
        centerTitle: true,
        elevation: 2,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF4B7C6D), // Green box color
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and description text
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
                    Navigator.pop(context); // Close the page when tapped
                    Navigator.pop(context);
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
                      color: Color(0xFF4B7C6D), // Green text
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
