import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:rentara_mobile/pages/joinpartner/models/Partner.dart'; 
import 'package:rentara_mobile/pages/joinpartner/screens/customer/listProduct.dart';
import '../../../main/widgets/navbar.dart'; // Assuming NavBarBottom is located here
import 'dart:convert'; // Add this import for jsonEncode if it's used

class EditVehiclePage extends StatefulWidget {
  final String vehicleId; // Changed type to String

  EditVehiclePage({required this.vehicleId});

  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final TextEditingController _namaKendaraanController = TextEditingController();
  final TextEditingController _tipeKendaraanController = TextEditingController();
  final TextEditingController _warnaKendaraanController = TextEditingController();
  final TextEditingController _merkKendaraanController = TextEditingController();
  final TextEditingController _hargaSewaController = TextEditingController();
  final TextEditingController _statusKendaraanController = TextEditingController();
  final TextEditingController _bahanBakarController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  String? partnerToko;
  String? partnerNotelp;
  String? partnerLinkLokasi;
  String? partnerid;

  @override
  void initState() {
    super.initState();
    final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    _loadVehicleData(request);
    _fetchPartnerData(request);
  }

  void _fetchPartnerData(CookieRequest request) async {
  try {
    final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/get_partner/');
    
    // Pastikan respons dapat di-decode sebagai JSON
    if (response is Map<String, dynamic> && response['status'] == 'Approved') {
      setState(() {
        partnerid = response['pk'];
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

  Future<void> _loadVehicleData(CookieRequest request) async {
    print(widget.vehicleId);
    String vehicleID = widget.vehicleId;
    print(partnerid);

    try {
      final response = await request.get(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/vehicle_detail_flutter/$vehicleID/',
      );
      print('Response: ${response.toString()}'); 

      if (response!=null) {
        final vehicleData = response;
        _namaKendaraanController.text = vehicleData['merk'];
        _tipeKendaraanController.text = vehicleData['jenis_kendaraan'];
        _warnaKendaraanController.text = vehicleData['warna'];
        _merkKendaraanController.text = vehicleData['tipe'];
        _hargaSewaController.text = vehicleData['harga'].toString();
        _statusKendaraanController.text = vehicleData['status'];
        _bahanBakarController.text = vehicleData['bahan_bakar'];
        _urlController.text = vehicleData['link_foto'];
        partnerToko = vehicleData['toko'];
        partnerNotelp = vehicleData['notelp'];
        partnerLinkLokasi = vehicleData['link_lokasi'];
      } else {
        throw Exception('Failed to load vehicle data: ${response['message']}');
      }
    } catch (e) {
      print('Error loading vehicle data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vehicle data: $e')),
      );
    }
  }

  void _submitForm() {
    final updatedData = {
      'toko': partnerToko,
      'merk': _merkKendaraanController.text,
      'tipe': _namaKendaraanController.text,
      'warna': _warnaKendaraanController.text,
      'jenis_kendaraan': _tipeKendaraanController.text,
      'harga': int.tryParse(_hargaSewaController.text),
      'status': _statusKendaraanController.text,
      'notelp': partnerNotelp,
      'bahan_bakar': _bahanBakarController.text,
      'link_lokasi': partnerLinkLokasi,
      'link_foto': _urlController.text,
      'partner' : partnerid,
    };
    
    _editVehicle(widget.vehicleId, updatedData);
  }

  Widget _buildTextField({required String label, required TextEditingController controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
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

  void _editVehicle(String vehicleId, Map<String, dynamic> updatedData) async {
    try {
      final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
      final response = await request.post(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/edit_vehicle_flutter/$vehicleId/',
        jsonEncode(updatedData),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vehicle updated successfully!')),
        );
        Navigator.pop(context);
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ListProductPage()),
        );
      } else {
        throw Exception('Failed to update vehicle: ${response['message']}');
      }
    } catch (e) {
      print('Error updating vehicle: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update vehicle: $e')),
      );
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
              _buildTextField(label: 'Nama Kendaraan', controller: _namaKendaraanController),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _tipeKendaraanController.text.isNotEmpty ? _tipeKendaraanController.text : null,
                items: ['Motor', 'Mobil']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipeKendaraanController.text = value ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tipe Kendaraan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF629584)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              _buildTextField(label: 'Warna Kendaraan', controller: _warnaKendaraanController),
              SizedBox(height: 12),
              _buildTextField(label: 'Merk Kendaraan', controller: _merkKendaraanController),
              SizedBox(height: 12),
              _buildTextField(label: 'Harga Sewa per Hari', controller: _hargaSewaController),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _statusKendaraanController.text.isNotEmpty ? _statusKendaraanController.text : null,
                items: ['Jual', 'Sewa']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _statusKendaraanController.text = value ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Status Kendaraan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF629584)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _bahanBakarController.text.isNotEmpty ? _bahanBakarController.text : null,
                items: ['Bensin', 'Diesel']
                    .map((fuel) => DropdownMenuItem(value: fuel, child: Text(fuel)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _bahanBakarController.text = value ?? '';
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Bahan Bakar Kendaraan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Color(0xFF629584)),
                  ),
                ),
              ),
              SizedBox(height: 12),
              _buildTextField(label: 'URL Gambar Kendaraan', controller: _urlController),
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
                    _urlController.text,
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
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF629584),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
      bottomNavigationBar: NavBarBottom(),
    );
  }
}
