import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../../widgets/admin/edit_add_component.dart';

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

  Future<void> _handleSubmit(
      BuildContext context, CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      try {
        final requestData = {
          'toko': _store,
          'merk': _brand,
          'tipe': _type,
          'warna': _color,
          'jenis_kendaraan': jenisKendaraanValues.reverse[_vehicleType],
          'harga': _price.toString(),
          'status': statusValues.reverse[_status],
          'notelp': _phone,
          'bahan_bakar': bahanBakarValues.reverse[_fuelType],
          'link_lokasi': _locationLink,
          'link_foto': _photoLink,
        };

        final response = await request.postJson(
          "http://127.0.0.1:8000/vehicle/edit-flutter/${widget.vehicle.pk}/",
          jsonEncode(requestData),
        );

        if (context.mounted) {
          if (response['status'] == 'success') {
            VehicleFormComponents.showSuccessSnackBar(
                context, "Vehicle updated successfully!");
            Navigator.pop(context, true);
          } else {
            VehicleFormComponents.showErrorSnackBar(
                context, "Failed to update vehicle.");
          }
        }
      } catch (e) {
        if (context.mounted) {
          VehicleFormComponents.showErrorSnackBar(
              context, "Error: ${e.toString()}");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: VehicleFormComponents.mainColor,
      body: SafeArea(
        child: Column(
          children: [
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
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: VehicleFormComponents.cardColor,
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
                          Text(
                            'Vehicle Details',
                            style: TextStyle(
                              color: VehicleFormComponents.mainColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update your vehicle information below!',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          VehicleFormComponents.buildImagePreview(_photoLink),
                          const SizedBox(height: 24),
                          TextFormField(
                            initialValue: _store,
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Store Name',
                                    icon: Icons.store),
                            onChanged: (value) =>
                                setState(() => _store = value),
                            validator: VehicleFormComponents.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: _brand,
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Brand',
                                    icon: Icons.branding_watermark),
                            onChanged: (value) =>
                                setState(() => _brand = value),
                            validator: VehicleFormComponents.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: _type,
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Type',
                                    icon: Icons.category),
                            onChanged: (value) => setState(() => _type = value),
                            validator: VehicleFormComponents.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: _color,
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Color',
                                    icon: Icons.color_lens),
                            onChanged: (value) =>
                                setState(() => _color = value),
                            validator: VehicleFormComponents.validateRequired,
                          ),
                          const SizedBox(height: 16),
                          VehicleFormComponents.buildDropdownDecoration(
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
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Price',
                                    icon: Icons.attach_money),
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(
                                () => _price = int.tryParse(value) ?? 0),
                            validator: VehicleFormComponents.validatePrice,
                          ),
                          const SizedBox(height: 16),
                          VehicleFormComponents.buildDropdownDecoration(
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
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Phone Number',
                                    icon: Icons.phone),
                            keyboardType: TextInputType.phone,
                            onChanged: (value) =>
                                setState(() => _phone = value),
                            validator: VehicleFormComponents.validatePhone,
                          ),
                          const SizedBox(height: 16),
                          VehicleFormComponents.buildDropdownDecoration(
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
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Location Link',
                                    icon: Icons.location_on),
                            onChanged: (value) =>
                                setState(() => _locationLink = value),
                            validator: VehicleFormComponents.validateUrl,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: _photoLink,
                            decoration:
                                VehicleFormComponents.buildInputDecoration(
                                    'Photo Link',
                                    icon: Icons.photo),
                            onChanged: (value) =>
                                setState(() => _photoLink = value),
                            validator: VehicleFormComponents.validateUrl,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: VehicleFormComponents
                                  .buildSubmitButtonStyle(),
                              onPressed: () => _handleSubmit(context, request),
                              child: const Text(
                                'UPDATE VEHICLE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
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
