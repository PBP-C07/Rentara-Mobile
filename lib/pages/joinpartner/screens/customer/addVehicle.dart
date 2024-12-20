import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Pastikan ini diimport jika Anda menggunakan CookieRequest
import 'package:rentara_mobile/pages/joinpartner/screens/customer/listProduct.dart';
import 'dart:convert'; // Untuk encoding data JSON
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here
import 'package:provider/provider.dart';

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  // Controllers for input fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _urlController = TextEditingController(); // Controller for image URL

  // Dropdown selections
  String? _selectedStatus;
  String? _selectedFuel;
  String? _selectedVehicleType;

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Placeholder for partner data
  String? partnerid;
  String? partnerToko;
  String? partnerNotelp;
  String? partnerLinkLokasi;

  @override
  void initState() {
    super.initState();
    final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    _fetchPartnerData(request);
  }

  void _fetchPartnerData(CookieRequest request) async {
  try {
    final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/get_partner/');
    
    // Pastikan respons dapat di-decode sebagai JSON
    if (response is Map<String, dynamic> && response['status'] == 'Approved') {
      setState(() {
        partnerid = response['id'];
        partnerToko = response['toko'];
        partnerNotelp = response['notelp'];
        partnerLinkLokasi = response['link_lokasi'];
      });
    } else {
      throw Exception('Unexpected response format: $response');
    }
  } catch (e) {
    print('Error fetching partner data: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load partner data: ${e.toString()}')),
    );
  }
}


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, process the data
      final vehicleData = {
        'toko': partnerToko ?? _nameController.text,
        'merk': _nameController.text,
        'tipe': _brandController.text,
        'warna': _colorController.text,
        'jenis_kendaraan': _selectedVehicleType,
        'harga': int.tryParse(_priceController.text) ?? 0,
        'status': _selectedStatus,
        'notelp': partnerNotelp,
        'bahan_bakar': _selectedFuel,
        'link_lokasi': partnerLinkLokasi,
        'link_foto': _urlController.text,
        'partner': partnerToko,
      };

      print('Form submitted with data: $vehicleData');

      try {
        final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
        final response = await request.post(
          'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/create_vehicle_flutter/',
          jsonEncode(vehicleData),
        );

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vehicle added successfully!')),
          );

          // Clear the fields after submission
          _nameController.clear();
          _typeController.clear();
          _colorController.clear();
          _brandController.clear();
          _priceController.clear();
          _urlController.clear();
          setState(() {
            _selectedStatus = null;
            _selectedFuel = null;
            _selectedVehicleType = null;
          });
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListProductPage()),
        );
        } else {
          throw Exception('Failed to add vehicle: ${response['message']}');
        }
      } catch (e) {
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add vehicle: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF387478),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Text(
                'ADD VEHICLE',
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your vehicle details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF629584),
                  ),
                ),
                SizedBox(height: 16),
                _buildTextField(label: 'Nama Kendaraan', controller: _nameController),
                SizedBox(height: 12),
                _buildDropdown(
                  label: 'Jenis Kendaraan',
                  value: _selectedVehicleType,
                  items: ['Mobil', 'Motor'],
                  onChanged: (value) => setState(() => _selectedVehicleType = value),
                ),
                SizedBox(height: 12),
                _buildTextField(label: 'Warna Kendaraan', controller: _colorController),
                SizedBox(height: 12),
                _buildTextField(label: 'Merk Kendaraan', controller: _brandController),
                SizedBox(height: 12),
                _buildTextField(
                  label: 'Harga Sewa per Hari',
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 12),
                _buildDropdown(
                  label: 'Status Kendaraan',
                  value: _selectedStatus,
                  items: ['Sewa', 'Jual'],
                  onChanged: (value) => setState(() => _selectedStatus = value),
                ),
                SizedBox(height: 12),
                _buildDropdown(
                  label: 'Bahan Bakar Kendaraan',
                  value: _selectedFuel,
                  items: ['Bensin', 'Diesel'],
                  onChanged: (value) => setState(() => _selectedFuel = value),
                ),
                SizedBox(height: 12),
                _buildTextField(label: 'URL Gambar', controller: _urlController),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF629584),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavBarBottom(),
    );
  }


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF629584)),
            ),
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: Color(0xFF387478)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF629584)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
