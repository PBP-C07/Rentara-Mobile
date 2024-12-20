import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/main/screens/profile.dart';
import 'pending.dart'; // Import the PendingPage
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here
import 'package:pbp_django_auth/pbp_django_auth.dart';

void main() {
  runApp(const RegisterPartnerApp());
}

class RegisterPartnerApp extends StatelessWidget {
  const RegisterPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RegisterPartnerPage(),
      theme: ThemeData(
        primaryColor: const Color(0xFF5F8D6C),
        fontFamily: 'Poppins',
      ),
    );
  }
}

class RegisterPartnerPage extends StatefulWidget {
  const RegisterPartnerPage({super.key});

  @override
  _RegisterPartnerPageState createState() => _RegisterPartnerPageState();
}

class _RegisterPartnerPageState extends State<RegisterPartnerPage> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> _registerPartner() async {
    String storeName = _storeNameController.text;
    String address = _addressController.text;
    String phoneNumber = _phoneNumberController.text;

    if (storeName.isEmpty || address.isEmpty || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final partnerData = {
      'store_name': storeName,
      'address': address,
      'phone_number': phoneNumber,
    };

    try {
      final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
      final response = await request.post(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/create_partner_flutter/',
        jsonEncode(partnerData),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Partner registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _storeNameController.clear();
        _addressController.clear();
        _phoneNumberController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PendingPage()),
        );
      } else {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to register partner: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Register Partner',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D524C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter your store details',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF7B8F8E),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _storeNameController,
                          decoration: const InputDecoration(
                            labelText: 'Store name',
                            labelStyle: TextStyle(color: Color(0xFF5F8D6C)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color: Color(0xFF5F8D6C)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(color: Color(0xFF5F8D6C)),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Column(
                            children: [
                              ElevatedButton(
                                onPressed: _registerPartner,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5F8D6C),
                                  fixedSize: Size(screenWidth * 0.8, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5F8D6C),
                                  fixedSize: Size(screenWidth * 0.8, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Back',
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: NavBarBottom(),
          ),
        ],
      ),
    );
  }
}
