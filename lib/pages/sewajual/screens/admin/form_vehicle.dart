import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class VehicleEntryFormPage extends StatefulWidget {
  const VehicleEntryFormPage({super.key});

  @override
  State<VehicleEntryFormPage> createState() => _VehicleEntryFormPageState();
}

class _VehicleEntryFormPageState extends State<VehicleEntryFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _store = "";
  String _brand = "";
  String _type = "";
  String _color = "";
  JenisKendaraan _vehicleType = JenisKendaraan.MOBIL;
  int _price = 0;
  Status _status = Status.SEWA;
  String _phone = "";
  BahanBakar _fuelType = BahanBakar.BENSIN;
  String _locationLink = "";
  String _photoLink = "";

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.teal[700],
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.grey[50],
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade200),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade200),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
    );
  }

  Widget _buildDropdownDecoration(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.teal[700],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.teal.shade200),
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: _photoLink.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera, size: 48, color: Colors.grey[400]),
                  SizedBox(height: 8),
                  Text(
                    'No image preview',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                _photoLink,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image,
                          size: 48, color: Colors.grey[400]),
                      SizedBox(height: 8),
                      Text(
                        'Invalid image URL',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.teal[700],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'ADD NEW VEHICLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enter vehicle details',
                          style: TextStyle(
                            color: Colors.teal[700],
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        _buildImagePreview(),
                        const SizedBox(height: 24),
                        TextFormField(
                          decoration: _buildInputDecoration('Store Name'),
                          onChanged: (value) => setState(() => _store = value),
                          validator: (value) =>
                              value?.isEmpty ?? true ? "Required" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Brand'),
                          onChanged: (value) => setState(() => _brand = value),
                          validator: (value) =>
                              value?.isEmpty ?? true ? "Required" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Type'),
                          onChanged: (value) => setState(() => _type = value),
                          validator: (value) =>
                              value?.isEmpty ?? true ? "Required" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Color'),
                          onChanged: (value) => setState(() => _color = value),
                          validator: (value) =>
                              value?.isEmpty ?? true ? "Required" : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownDecoration(
                          'Vehicle Type',
                          DropdownButtonHideUnderline(
                            child: DropdownButton<JenisKendaraan>(
                              isExpanded: true,
                              value: _vehicleType,
                              items: JenisKendaraan.values.map((type) {
                                return DropdownMenuItem<JenisKendaraan>(
                                  value: type,
                                  child: Text(
                                      jenisKendaraanValues.reverse[type] ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() =>
                                  _vehicleType = value ?? JenisKendaraan.MOBIL),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Price'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              setState(() => _price = int.tryParse(value) ?? 0),
                          validator: (value) {
                            if (value?.isEmpty ?? true) return "Required";
                            if (int.tryParse(value!) == null)
                              return "Must be a number";
                            if (int.parse(value) < 1) return "Must be positive";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownDecoration(
                          'Status',
                          DropdownButtonHideUnderline(
                            child: DropdownButton<Status>(
                              isExpanded: true,
                              value: _status,
                              items: Status.values.map((status) {
                                return DropdownMenuItem<Status>(
                                  value: status,
                                  child:
                                      Text(statusValues.reverse[status] ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) => setState(
                                  () => _status = value ?? Status.SEWA),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Phone Number'),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) => setState(() => _phone = value),
                          validator: (value) {
                            if (value?.isEmpty ?? true) return "Required";
                            if (!RegExp(r'^\d{10,13}$').hasMatch(value!))
                              return "Invalid format";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownDecoration(
                          'Fuel Type',
                          DropdownButtonHideUnderline(
                            child: DropdownButton<BahanBakar>(
                              isExpanded: true,
                              value: _fuelType,
                              items: BahanBakar.values.map((fuel) {
                                return DropdownMenuItem<BahanBakar>(
                                  value: fuel,
                                  child: Text(
                                      bahanBakarValues.reverse[fuel] ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) => setState(
                                  () => _fuelType = value ?? BahanBakar.BENSIN),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Location Link'),
                          onChanged: (value) =>
                              setState(() => _locationLink = value),
                          validator: (value) {
                            if (value?.isEmpty ?? true) return "Required";
                            if (!Uri.parse(value!).isAbsolute)
                              return "Invalid URL";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: _buildInputDecoration('Photo Link'),
                          onChanged: (value) {
                            setState(() => _photoLink = value);
                          },
                          validator: (value) {
                            if (value?.isEmpty ?? true) return "Required";
                            if (!Uri.parse(value!).isAbsolute)
                              return "Invalid URL";
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final response = await request.postJson(
                                    "http://127.0.0.1:8000/vehicle/create-flutter/",
                                    jsonEncode({
                                      'toko': _store,
                                      'merk': _brand,
                                      'tipe': _type,
                                      'warna': _color,
                                      'jenis_kendaraan': jenisKendaraanValues
                                          .reverse[_vehicleType],
                                      'harga': _price.toString(),
                                      'status': statusValues.reverse[_status],
                                      'notelp': _phone,
                                      'bahan_bakar':
                                          bahanBakarValues.reverse[_fuelType],
                                      'link_lokasi': _locationLink,
                                      'link_foto': _photoLink,
                                    }),
                                  );

                                  if (context.mounted) {
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Vehicle saved successfully!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                      _formKey.currentState!.reset();
                                      Navigator.pop(context);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              "Error occurred. Try again."),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Error: ${e.toString()}"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'SUBMIT',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
