import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../../main/widgets/navbarAdmin.dart';

class VehicleEntryFormPage extends StatefulWidget {
  const VehicleEntryFormPage({super.key});

  @override
  State<VehicleEntryFormPage> createState() => _VehicleEntryFormPageState();
}

class _VehicleEntryFormPageState extends State<VehicleEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> _storeList = [];
  bool _isLoading = true;

  String? _store;
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

  @override
  void initState() {
    super.initState();
    fetchApprovedStores();
  }

  Future<void> fetchApprovedStores() async {
    try {
      final request = context.read<CookieRequest>();
      final response =
          await request.get("http://127.0.0.1:8000/vehicle/get-stores/");

      if (mounted) {
        setState(() {
          _storeList = List<String>.from(
              response.map((store) => store['toko'].toString()));
          _isLoading = false;
          if (_storeList.isNotEmpty) {
            _store = _storeList[0];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading stores: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Color(0xFF2B6777),
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.grey[50],
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2B6777).withOpacity(0.2)),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: const Color(0xFF2B6777).withOpacity(0.2)),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF2B6777), width: 2),
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
          style: const TextStyle(
            color: Color(0xFF2B6777),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF2B6777).withOpacity(0.2),
              ),
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _buildStoreDropdown() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_storeList.isEmpty) {
      return const Text(
        "No approved stores available",
        style: TextStyle(color: Colors.red),
      );
    }

    return _buildDropdownDecoration(
      'Store Name',
      DropdownButtonFormField<String>(
        value: _store,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          border: InputBorder.none,
        ),
        items: _storeList.map((String store) {
          return DropdownMenuItem<String>(
            value: store,
            child: Text(store),
          );
        }).toList(),
        validator: (value) => value == null ? "Please select a store" : null,
        onChanged: (String? newValue) {
          setState(() {
            _store = newValue;
          });
        },
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFF2B6777).withOpacity(0.2),
        ),
      ),
      child: _photoLink.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 8),
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
                      const SizedBox(height: 8),
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
                      color: const Color(0xFF2B6777),
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
      backgroundColor: const Color(0xFF2B6777),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Add New Vehicle',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(50, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'List your vehicle for rent',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
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
                            const Text(
                              'Vehicle Details',
                              style: TextStyle(
                                color: Color(0xFF2B6777),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            _buildImagePreview(),
                            const SizedBox(height: 24),
                            _buildStoreDropdown(),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: _buildInputDecoration('Brand'),
                              onChanged: (value) =>
                                  setState(() => _brand = value),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: _buildInputDecoration('Type'),
                              onChanged: (value) =>
                                  setState(() => _type = value),
                              validator: (value) =>
                                  value?.isEmpty ?? true ? "Required" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: _buildInputDecoration('Color'),
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
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: _buildInputDecoration('Price'),
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
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: _buildInputDecoration('Phone Number'),
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
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration:
                                  _buildInputDecoration('Location Link'),
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
                                  backgroundColor: const Color(0xFF2B6777),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );

                                      final response = await request.postJson(
                                        "http://127.0.0.1:8000/vehicle/create-flutter/",
                                        jsonEncode({
                                          'toko': _store,
                                          'merk': _brand,
                                          'tipe': _type,
                                          'warna': _color,
                                          'jenis_kendaraan':
                                              jenisKendaraanValues
                                                  .reverse[_vehicleType],
                                          'harga': _price.toString(),
                                          'status':
                                              statusValues.reverse[_status],
                                          'notelp': _phone,
                                          'bahan_bakar': bahanBakarValues
                                              .reverse[_fuelType],
                                          'link_lokasi': _locationLink,
                                          'link_foto': _photoLink,
                                        }),
                                      );

                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }

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

                                          // Reset form
                                          _formKey.currentState!.reset();
                                          setState(() {
                                            _brand = "";
                                            _type = "";
                                            _color = "";
                                            _vehicleType = JenisKendaraan.MOBIL;
                                            _price = 0;
                                            _status = Status.SEWA;
                                            _phone = "";
                                            _fuelType = BahanBakar.BENSIN;
                                            _locationLink = "";
                                            _photoLink = "";
                                            if (_storeList.isNotEmpty) {
                                              _store = _storeList[0];
                                            }
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(response[
                                                      'message'] ??
                                                  "Error occurred. Please try again."),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      }
                                    } catch (e) {
                                      if (context.mounted &&
                                          Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      }

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text("Error: ${e.toString()}"),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                                child: const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
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
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: NavBarBottomAdmin(),
            ),
          ],
        ),
      ),
    );
  }
}
