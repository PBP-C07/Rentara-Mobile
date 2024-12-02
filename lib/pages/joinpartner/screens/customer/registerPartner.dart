import 'package:flutter/material.dart';
import 'pending.dart'; // Import the PendingPage

void main() {
  runApp(RegisterPartnerApp());
}

class RegisterPartnerApp extends StatelessWidget {
  const RegisterPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPartnerPage(),
      theme: ThemeData(
        primaryColor: const Color(0xFF5F8D6C), // Define primary color
        primarySwatch: const MaterialColor(0xFF5F8D6C, {
          50: const Color(0xFFE1F0E5),
          100: const Color(0xFFC3E2CC),
          200: const Color(0xFFA5D5B2),
          300: const Color(0xFF87C79A),
          400: const Color(0xFF6AB685),
          500: const Color(0xFF5F8D6C), // Actual primary color
          600: const Color(0xFF4D7A5D),
          700: const Color(0xFF3B654C),
          800: const Color(0xFF2A513D),
          900: const Color(0xFF193A2F),
        }), // Define primarySwatch using primary color
        fontFamily: 'Poppins', // Use the Poppins font
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
  // Form controllers
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Method to handle form submission
  void _registerPartner() {
    String storeName = _storeNameController.text;
    String address = _addressController.text;
    String phoneNumber = _phoneNumberController.text;

    // Validation or backend call logic
    if (storeName.isEmpty || address.isEmpty || phoneNumber.isEmpty) {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Simulate a successful registration
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Partner registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the fields
      _storeNameController.clear();
      _addressController.clear();
      _phoneNumberController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive design
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Light background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                style: const TextStyle(color: Colors.black), // Ensure the text color is black
                decoration: const InputDecoration(
                  labelText: 'Store name',
                  labelStyle: TextStyle(color: Color(0xFF5F8D6C)), // Color for the label text
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                style: const TextStyle(color: Colors.black), // Ensure the text color is black
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Color(0xFF5F8D6C)), // Color for the label text
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneNumberController,
                style: const TextStyle(color: Colors.black), // Ensure the text color is black
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: TextStyle(color: Color(0xFF5F8D6C)), // Color for the label text
                  border: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5F8D6C)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center, // Center the buttons vertically
                    children: [
                      ElevatedButton(
                        onPressed: () {
                           Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PendingPage(),
                        ),
                      );
                        } ,// Call the registration handler
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F8D6C), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          fixedSize: Size(screenWidth * 0.8, 50), // Make button responsive
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 16, color: Colors.white), // White text color
                        ),
                      ),
                      const SizedBox(height: 16), // Add space between the buttons
                      ElevatedButton(
                        onPressed: () {
                          // Pop to the previous page (ProfilePage)
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5F8D6C), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          fixedSize: Size(screenWidth * 0.8, 50), // Make button responsive
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 16, color: Colors.white), // White text color
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
