import 'package:flutter/material.dart';
import 'registerPartner.dart'; // Import RegisterPartnerPage to navigate back for re-registration
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here

class RejectedPage extends StatelessWidget {
  const RejectedPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light background
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add spacing from top
                  const Text(
                    'Oops! Akun Anda belum disetujui oleh admin.',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D524C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Jangan khawatir! Silakan coba lagi untuk mendaftar. Kami siap menyambut Anda!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7B8F8E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPartnerPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F8D6C), // Green button color
                      fixedSize: Size(screenWidth * 0.8, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Mendaftar Kembali',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 50), // Add spacing to avoid overlapping with NavBar
                ],
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavBarBottom(),
          ),
        ],
      ),
    );
  }
}
