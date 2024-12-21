import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/sewajual/models/vehicle_model.dart';
import 'package:rentara_mobile/pages/sewajual/screens/user/catalogue.dart';

class EditReviewFormPage extends StatefulWidget {
  const EditReviewFormPage({super.key});

  @override
  State<EditReviewFormPage> createState() => _EditReviewFormPage();
}

class _EditReviewFormPage extends State<EditReviewFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = "";
  int _rating = 0;
  final _vehicleController = TextEditingController();
  String _description = "";

  List<VehicleEntry> vehicles = [];

  Widget reviewHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF557B83),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: const Center(
        child: Text(
          'EDIT REVIEW', // Header text
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: reviewHeader(),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _title = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Title field cannot be blank.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: vehicles.isNotEmpty ? vehicles[0].fields.merk : null,
                      items: vehicles
                          .map((vehicle) => DropdownMenuItem<String>(
                                value: '${vehicle.fields.merk} ${vehicle.fields.tipe} (${vehicle.fields.warna})',
                                child: Text('${vehicle.fields.merk} ${vehicle.fields.tipe} (${vehicle.fields.warna})'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _vehicleController.text = value ?? '';
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rating',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                          child: Icon(
                            Icons.star,
                            size: 45,
                            color: _rating > index
                                ? Colors.yellow
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  maxLines: 5,
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Description field cannot be blank.";
                    }
                    return null;
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Send data to Django and wait for the response
                        final response = await request.postJson(
                          "http://127.0.0.1:8000/edit-reviews-flutter/",
                          jsonEncode(<String, String>{
                            'title': _title,
                            'vehicle': _vehicleController.text,
                            'rating': _rating.toString(),
                            'description': _description,
                          }),
                        );
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Review Successfully Edited!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => CarCatalogueScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              content: Text("Unable to Edit Review. Please Try Again Later"),
                            ));
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Edit Review",
                      style: TextStyle(color: Colors.white),
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
