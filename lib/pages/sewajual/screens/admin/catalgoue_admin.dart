import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_model.dart';
import '../../widgets/admin/header_catalogue.dart';
import '../../widgets/admin/vehicle_card.dart';
import '../../../main/widgets/navbarAdmin.dart';

class ProductCatalogueAdmin extends StatefulWidget {
  const ProductCatalogueAdmin({super.key});

  @override
  State<ProductCatalogueAdmin> createState() => _ProductCatalogueAdminState();
}

class _ProductCatalogueAdminState extends State<ProductCatalogueAdmin> {
  late Future<List<VehicleEntry>> _vehiclesFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _vehiclesFuture = fetchVehicles(request);
  }

  Future<List<VehicleEntry>> fetchVehicles(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/vehicle/json/');
    return vehicleEntryFromJson(jsonEncode(response));
  }

  Future<void> refreshData() async {
    final request = context.read<CookieRequest>();
    setState(() {
      _vehiclesFuture = fetchVehicles(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CatalogueHeader(),
                Expanded(
                  child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: refreshData,
                    child: FutureBuilder<List<VehicleEntry>>(
                      future: _vehiclesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No vehicles found'));
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return VehicleCard(
                              vehicle: snapshot.data![index],
                              onEditComplete: refreshData,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2B6777),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: NavBarBottomAdmin(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
