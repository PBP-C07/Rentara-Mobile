import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/main/screens/profile.dart';
import 'pending.dart'; // Import the PendingPage
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here
import 'package:pbp_django_auth/pbp_django_auth.dart';

void main() {
  runApp(const EditPartnerApp());
}

class EditPartnerApp extends StatelessWidget {
  const EditPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const EditPartnerPage(),
      theme: ThemeData(
        primaryColor: const Color(0xFF5F8D6C),
        fontFamily: 'Poppins',
      ),
    );
  }
}

class EditPartnerPage extends StatefulWidget {
  const EditPartnerPage({super.key});

  @override
  _EditPartnerPageState createState() => _EditPartnerPageState();
}

class _EditPartnerPageState extends State<EditPartnerPage> {
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? id;
  String? status;

  // Function to fetch partner data
  Future<void> _fetchPartnerData() async {
    try {
      final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
      final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/get_partner/');

      if (response['status'] == 'Approved') {
        // Populate the form fields with the fetched data
        setState(() {
          _storeNameController.text = response['toko'] ?? '';
          _addressController.text = response['link_lokasi'] ?? '';
          _phoneNumberController.text = response['notelp'] ?? '';
          id = response['id'].toString(); // Ensure `id` is being set correctly
          status = response['status'];
        });
      } else {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch partner data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editPartner() async {
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
      'toko': storeName,
      'link_lokasi': address,
      'notelp': phoneNumber,
      'status':status,
    };

    try {
      final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
      final response = await request.post(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/edit_partner_flutter/$id/',
        jsonEncode(partnerData),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Partner updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _storeNameController.clear();
        _addressController.clear();
        _phoneNumberController.clear();

        Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(),
                                ),
                              );
      } else {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit partner: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPartnerData(); // Fetch the partner data when the page is loaded
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
                          'Edit Partner',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D524C),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Update your store details',
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
                                onPressed: _editPartner,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5F8D6C),
                                  fixedSize: Size(screenWidth * 0.8, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Update',
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
