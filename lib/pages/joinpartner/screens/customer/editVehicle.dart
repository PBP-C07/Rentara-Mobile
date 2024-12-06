import 'package:flutter/material.dart';
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here

class EditVehiclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Increased height for the app bar
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF387478), // Background color of app bar
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30), // Adjusted top padding for better vertical centering
              child: Text(
                'EDIT VEHICLE',
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Update your vehicle details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF629584),
                ),
              ),
              SizedBox(height: 16),
              _buildTextField(label: 'Nama Kendaraan'),
              SizedBox(height: 12),
              _buildTextField(label: 'Tipe Kendaraan'),
              SizedBox(height: 12),
              _buildTextField(label: 'Warna Kendaraan'),
              SizedBox(height: 12),
              _buildTextField(label: 'Merk Kendaraan'),
              SizedBox(height: 12),
              _buildTextField(label: 'Harga Sewa per Hari'),
              SizedBox(height: 12),
              _buildTextField(label: 'Status Kendaraan'),
              SizedBox(height: 12),
              _buildTextField(label: 'Bahan Bakar Kendaraan'),
              SizedBox(height: 12),
              Text(
                'Preview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF629584)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Image.network(
                    'https://via.placeholder.com/150',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission for edit
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF629584), // Updated color
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 16, color: Colors.white), // Text color set to white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Add NavBarBottom widget at the bottom
      bottomNavigationBar: NavBarBottom(),
    );
  }

  Widget _buildTextField({required String label, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF629584)),
            ),
            hintText: 'Update $label',
            hintStyle: TextStyle(color: Color(0xFF387478)),
          ),
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditVehiclePage(),
    ));
