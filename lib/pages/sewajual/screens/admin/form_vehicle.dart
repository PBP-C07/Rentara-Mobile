import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/vehicle_model.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../../main/widgets/navbarAdmin.dart';
import '../../widgets/admin/edit_add_component.dart';

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

  void _resetForm() {
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

    _formKey.currentState?.reset();
  }

  Future<List<VehicleEntry>> refreshVehicles(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/vehicle/json/');
    return vehicleEntryFromJson(jsonEncode(response));
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
        VehicleFormComponents.showErrorSnackBar(
            context, "Error loading stores: ${e.toString()}");
      }
    }
  }

  Widget _buildStoreDropdown() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_storeList.isEmpty) {
      return const Text("No stores available!",
          style: TextStyle(color: Colors.red));
    }

    return VehicleFormComponents.buildDropdownDecoration(
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
        validator: VehicleFormComponents.validateRequired,
        onChanged: (String? newValue) {
          setState(() {
            _store = newValue;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: VehicleFormComponents.mainColor,
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
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () async {
                                  final newVehicle =
                                      await refreshVehicles(request);
                                  Navigator.pop(context, newVehicle.last);
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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
                                            color: Color.fromARGB(50, 0, 0, 0))
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'List vehicle for rent and sell',
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
                          ],
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
                            Text(
                              'Vehicle Details',
                              style: TextStyle(
                                color: VehicleFormComponents.mainColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            VehicleFormComponents.buildImagePreview(_photoLink),
                            const SizedBox(height: 24),
                            _buildStoreDropdown(),
                            const SizedBox(height: 16),
                            VehicleFormComponents.buildFormField(
                              'Brand',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.branding_watermark),
                                  hintText: "Ex: Toyota",
                                ),
                                onChanged: (value) =>
                                    setState(() => _brand = value),
                                validator:
                                    VehicleFormComponents.validateRequired,
                              ),
                            ),
                            const SizedBox(height: 16),
                            VehicleFormComponents.buildFormField(
                              'Type',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.category),
                                  hintText: "Ex: Fortuner GR",
                                ),
                                onChanged: (value) =>
                                    setState(() => _type = value),
                                validator:
                                    VehicleFormComponents.validateRequired,
                              ),
                            ),
                            const SizedBox(height: 16),
                            VehicleFormComponents.buildFormField(
                              'Color',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.color_lens),
                                  hintText: "Ex: Black",
                                ),
                                onChanged: (value) =>
                                    setState(() => _color = value),
                                validator:
                                    VehicleFormComponents.validateRequired,
                              ),
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
                            VehicleFormComponents.buildFormField(
                              'Price',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.attach_money),
                                  hintText: "Ex: 1500000",
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) => setState(
                                    () => _price = int.tryParse(value) ?? 0),
                                validator: VehicleFormComponents.validatePrice,
                              ),
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
                            VehicleFormComponents.buildFormField(
                              'Phone Number',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.phone),
                                  hintText: "Ex 0812XXXXXXXX or 62812XXXXXXX",
                                ),
                                keyboardType: TextInputType.phone,
                                onChanged: (value) =>
                                    setState(() => _phone = value),
                                validator: VehicleFormComponents.validatePhone,
                              ),
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
                            VehicleFormComponents.buildFormField(
                              'Location Link',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.location_on),
                                  hintText: "Ex: https://maps.app.goo.gl/....",
                                ),
                                onChanged: (value) =>
                                    setState(() => _locationLink = value),
                                validator: VehicleFormComponents.validateUrl,
                              ),
                            ),
                            const SizedBox(height: 16),
                            VehicleFormComponents.buildFormField(
                              'Photo Link',
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.photo),
                                  hintText:
                                      "Ex: https://imgcdn.oto.com/...../abcd.jpg",
                                ),
                                onChanged: (value) =>
                                    setState(() => _photoLink = value),
                                validator: VehicleFormComponents.validateUrl,
                              ),
                            ),
                            const SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: VehicleFormComponents
                                    .buildSubmitButtonStyle(),
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

                                      if (!context.mounted) return;

                                      if (response['status'] == 'success') {
                                        VehicleFormComponents
                                            .showSuccessSnackBar(context,
                                                "Vehicle saved successfully!");

                                        setState(() {
                                          _resetForm();
                                        });

                                        return;
                                      }

                                      VehicleFormComponents.showErrorSnackBar(
                                          context,
                                          response['message'] ??
                                              "Error. Please try again.");
                                    } catch (e) {
                                      if (!context.mounted) return;

                                      VehicleFormComponents.showErrorSnackBar(
                                          context, "Error: ${e.toString()}");
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
