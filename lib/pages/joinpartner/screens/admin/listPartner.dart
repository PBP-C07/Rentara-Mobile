import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert'; // Untuk konversi JSON
import 'package:rentara_mobile/pages/joinpartner/models/Partner.dart';
import '../../../main/widgets/navbarAdmin.dart'; // Assuming NavBarBottom is located here
import '../../widgets/admin/partnerCard.dart';
import '../../models/Partner.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const PartnerListApp());
}

class PartnerListApp extends StatelessWidget {
  const PartnerListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Primary color #387478
        fontFamily: 'Poppins',
      ),
      home: const PartnerListScreen(),
    );
  }
}

class PartnerListScreen extends StatefulWidget {
  const PartnerListScreen({super.key});

  @override
  _PartnerListScreenState createState() => _PartnerListScreenState();
}

class _PartnerListScreenState extends State<PartnerListScreen> {
  late Future<List<Partner>> futurePartners;
  List<Partner> allPartners = [];
  List<Partner> filteredPartners = [];
  TextEditingController searchController = TextEditingController();
  
  List<Partner> get allPartnerList => allPartners;

  // Getter untuk menghitung jumlah partner pending
  int get total => allPartnerList.length;

  @override
  void initState() {
    super.initState();
    final CookieRequest request = Provider.of<CookieRequest>(context, listen: false);
    futurePartners = fetchPartners(request);
    searchController.addListener(_filterPartners);
  }

  Future<List<Partner>> fetchPartners(CookieRequest request) async {
  try {
    final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/partner_json/');

    // Pastikan tipe data response benar
    if (response is List) {
      // Memfilter data hanya untuk status 'Approved'
      List<Partner> partners = response.map((json) => Partner.fromJson(json)).toList();
      List<Partner> allPartners = partners.where((partner) => partner.fields.status == 'Approved').toList();
      return allPartners;
    } else {
      throw Exception('Unexpected response format: Expected a list but got ${response.runtimeType}');
    }
  } catch (e) {
    debugPrint('Error fetching partners: $e');
    rethrow; // Mengirim ulang error agar dapat ditangani lebih lanjut
  }
}


  void _filterPartners() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPartners = allPartners.where((partner) {
        return partner.fields.toko.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100.0, // Increased height for appBar
        backgroundColor: const Color(0xFF387478), // Header color #387478
        title: const Padding(
          padding: EdgeInsets.only(top: 30), // Padding for top of the title
          child: Text(
            'LIST PARTNER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10.0), // Extra space between appBar and content
          child: Container(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar for filtering partners
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF1F1F1), // Light grey background
                  hintText: 'Search partner',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of partner cards
            Expanded(
              child: FutureBuilder<List<Partner>>(
                future: futurePartners,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final partners = filteredPartners.isNotEmpty ? filteredPartners : snapshot.data!;
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: partners.length,
                      itemBuilder: (context, index) {
                        final partner = partners[index];
                        return PartnerCard(
                          partnerId: partner.pk,
                          toko: partner.fields.toko,
                          linkLokasi: partner.fields.linkLokasi,
                          notelp: partner.fields.notelp,
                          status: partner.fields.status,
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No partners found.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBarBottomAdmin(),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
