import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class VehicleEditFormPage extends StatefulWidget {
  final VehicleEntry vehicle;

  const VehicleEditFormPage({super.key, required this.vehicle});

  @override
  State<VehicleEditFormPage> createState() => _VehicleEditFormPageState();
}

class _VehicleEditFormPageState extends State<VehicleEditFormPage> {
  final _formKey = GlobalKey<FormState>();

  late String _store;
  late String _brand;
  late String _type;
  late String _color;
  late JenisKendaraan _vehicleType;
  late int _price;
  late Status _status;
  late String _phone;
  late BahanBakar _fuelType;
  late String _locationLink;
  late String _photoLink;

  @override
  void initState() {
    super.initState();
    _store = widget.vehicle.fields.toko;
    _brand = widget.vehicle.fields.merk;
    _type = widget.vehicle.fields.tipe;
    _color = widget.vehicle.fields.warna;
    _vehicleType = widget.vehicle.fields.jenisKendaraan;
    _price = widget.vehicle.fields.harga;
    _status = widget.vehicle.fields.status;
    _phone = widget.vehicle.fields.notelp;
    _fuelType = widget.vehicle.fields.bahanBakar;
    _locationLink = widget.vehicle.fields.linkLokasi;
    _photoLink = widget.vehicle.fields.linkFoto;
  }

  final mainColor = const Color(0xFF2B6777);
  final secondaryColor = const Color(0xFF52AB98);
  final backgroundColor = const Color(0xFFF2F2F2);
  final cardColor = Colors.white;

  InputDecoration _buildInputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null
          ? Icon(icon, color: mainColor.withOpacity(0.7), size: 22)
          : null,
      labelStyle: TextStyle(
        color: mainColor.withOpacity(0.8),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: backgroundColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mainColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildDropdownDecoration(String label, Widget child,
      {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: mainColor.withOpacity(0.8),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: mainColor.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: mainColor.withOpacity(0.7), size: 22),
                const SizedBox(width: 12),
              ],
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: mainColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: _photoLink.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera,
                      size: 48, color: mainColor.withOpacity(0.3)),
                  const SizedBox(height: 8),
                  Text(
                    'No image preview',
                    style: TextStyle(color: mainColor.withOpacity(0.5)),
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
                          size: 48, color: mainColor.withOpacity(0.3)),
                      const SizedBox(height: 8),
                      Text(
                        'Invalid image URL',
                        style: TextStyle(color: mainColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
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
      backgroundColor: mainColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Edit Vehicle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            // Form Content
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Text(
                            'Vehicle Details',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update your vehicle information below',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          _buildImagePreview(),
                          const SizedBox(height: 24),

                          // Form Fields
                          TextFormField(
                            initialValue: _store,
                            decoration: _buildInputDecoration('Store Name',
                                icon: Icons.store),
                            onChanged: (value) =>
                                setState(() => _store = value),
                            validator: (value) =>
                                value?.isEmpty ?? true ? "Required" : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _brand,
                            decoration: _buildInputDecoration('Brand',
                                icon: Icons.branding_watermark),
                            onChanged: (value) =>
                                setState(() => _brand = value),
                            validator: (value) =>
                                value?.isEmpty ?? true ? "Required" : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _type,
                            decoration: _buildInputDecoration('Type',
                                icon: Icons.category),
                            onChanged: (value) => setState(() => _type = value),
                            validator: (value) =>
                                value?.isEmpty ?? true ? "Required" : null,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _color,
                            decoration: _buildInputDecoration('Color',
                                icon: Icons.color_lens),
                            onChanged: (value) =>
                                setState(() => _color = value),
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
                                        jenisKendaraanValues.reverse[type] ??
                                            ''),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(() =>
                                    _vehicleType =
                                        value ?? JenisKendaraan.MOBIL),
                              ),
                            ),
                            icon: Icons.directions_car,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _price.toString(),
                            decoration: _buildInputDecoration('Price',
                                icon: Icons.attach_money),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(
                                () => _price = int.tryParse(value) ?? 0),
                            validator: (value) {
                              if (value?.isEmpty ?? true) return "Required";
                              if (int.tryParse(value!) == null)
                                return "Must be a number";
                              if (int.parse(value) < 1)
                                return "Must be positive";
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
                                    child: Text(
                                        statusValues.reverse[status] ?? ''),
                                  );
                                }).toList(),
                                onChanged: (value) => setState(
                                    () => _status = value ?? Status.SEWA),
                              ),
                            ),
                            icon: Icons.info_outline,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _phone,
                            decoration: _buildInputDecoration('Phone Number',
                                icon: Icons.phone),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) =>
                                setState(() => _phone = value),
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
                                onChanged: (value) => setState(() =>
                                    _fuelType = value ?? BahanBakar.BENSIN),
                              ),
                            ),
                            icon: Icons.local_gas_station,
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: _locationLink,
                            decoration: _buildInputDecoration('Location Link',
                                icon: Icons.location_on),
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
                            initialValue: _photoLink,
                            decoration: _buildInputDecoration('Photo Link',
                                icon: Icons.photo),
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

                          // Update Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [secondaryColor, mainColor],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: mainColor.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () async {
                                // ... existing onPressed logic ...
                              },
                              child: const Text(
                                'UPDATE VEHICLE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
