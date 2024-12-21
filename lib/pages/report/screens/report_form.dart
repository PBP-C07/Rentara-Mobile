import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({Key? key}) : super(key: key);

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? vehicle;
  String? issueType;
  String? description;

  final List<String> issueTypes = [
    'Mismatch', // Kendaraan tidak sesuai yang dipesan
    'Damaged',  // Kendaraan rusak
    'Service',  // Pelayanan tidak ramah
  ];

  Future<void> submitReport(CookieRequest request) async {
    if (!_formKey.currentState!.validate()) return;

    final response = await request.postJson(
      "http://127.0.0.1:8000/re/create-flutter/",
      jsonEncode(<String, dynamic>{
        'vehicle': vehicle,
        'issue_type': issueType,
        'description': description,
      }),
    );

    if (context.mounted) {
      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Report berhasil dibuat!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal membuat report."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Report Baru"),
        backgroundColor: const Color(0xFF557B83),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Tindakan bila tombol bantuan ditekan
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Bantuan untuk form ini.")),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(
                  label: "Nama Kendaraan",
                  onChanged: (value) {
                    vehicle = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama kendaraan tidak boleh kosong.";
                    }
                    return null;
                  },
                  icon: Icons.car_repair,
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  label: "Jenis Masalah",
                  value: issueType,
                  items: issueTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      issueType = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Jenis masalah harus dipilih.";
                    }
                    return null;
                  },
                  icon: Icons.error_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Deskripsi",
                  maxLines: 3,
                  onChanged: (value) {
                    description = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Deskripsi tidak boleh kosong.";
                    }
                    return null;
                  },
                  icon: Icons.description,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitReport(request);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87A8A1),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    int? maxLines,
    required IconData icon,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF557B83)),
        border: const OutlineInputBorder(),
      ),
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF557B83)),
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
