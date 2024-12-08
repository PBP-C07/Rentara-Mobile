import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../main/widgets/navbarAdmin.dart'; // Assuming NavBarBottom is located here
import '../../models/Partner.dart';

void main() {
  runApp(const PendingPartnerApp());
}

class PendingPartnerApp extends StatelessWidget {
  const PendingPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF387478), // Warna utama
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0), // Height for the app bar
          child: AppBar(
            backgroundColor: const Color(0xFF387478), // Warna utama
            title: const Padding(
              padding: EdgeInsets.only(top: 30), // Padding for top space
              child: Text(
                'PENDING PARTNER',
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
              preferredSize: Size.fromHeight(10.0), // Extra space below app bar
              child: Container(),
            ),
          ),
        ),
        body: const PendingPartnerScreen(),
        bottomNavigationBar: NavBarBottomAdmin(),
      ),
    );
  }
}

class PendingPartnerScreen extends StatefulWidget {
  const PendingPartnerScreen({super.key});

  @override
  State<PendingPartnerScreen> createState() => _PendingPartnerScreenState();
}

class _PendingPartnerScreenState extends State<PendingPartnerScreen> {
  List<Partner> pendingPartners = [];
  List<Partner> filteredPartners = [];
  String searchQuery = '';
  List<Partner> get pendingPartnersList => pendingPartners;

  // Getter untuk menghitung jumlah partner pending
  int get totalPending => pendingPartnersList.length;

  @override
  void initState() {
    super.initState();
    fetchPartners().then((partners) {
      setState(() {
        pendingPartners = partners;
        filteredPartners = partners;
      });
    });
  }

  Future<List<Partner>> fetchPartners() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/partner_json/'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Partner> partners = data.map((json) => Partner.fromJson(json)).toList();
      pendingPartners = partners.where((partner) => partner.fields.status == 'pending').toList();
      return pendingPartners;
    } else {
      throw Exception('Failed to load partners');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredPartners = pendingPartners
          .where((partner) =>
              partner.fields.toko.toLowerCase().contains(searchQuery) ||
              partner.fields.linkLokasi.toLowerCase().contains(searchQuery) ||
              partner.fields.notelp.contains(searchQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar for filtering partners
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFA), // Warna latar belakang input
                hintText: 'Search pending partner',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF387478)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredPartners.length,
              itemBuilder: (context, index) {
                final partner = filteredPartners[index];
                return PendingPartnerCard(
                  name: partner.fields.toko,
                  address: partner.fields.linkLokasi,
                  phone: partner.fields.notelp,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PendingPartnerCard extends StatelessWidget {
  final String name;
  final String address;
  final String phone;

  const PendingPartnerCard({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA), // Background color for the card
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Partner name with a different background color
          Container(
            width: double.infinity, // Full width of the card
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF387478), // Light green background for name
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600, // Semi-bold
                fontSize: 16,
                color: Colors.white, // White text
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          // Address and Phone number with matching Container widths
          Column(
            children: [
              Container(
                width: double.infinity, // Full width of the card
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F4F), // Dark green container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity, // Full width of the card
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F4F4F), // Dark green container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  phone,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600, // Semi-bold
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Accept/Reject buttons inside Expanded widgets
          Flexible(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF832424), // Red color for reject button
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 3), // Space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF387478), // Main color for accept button
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Accept',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
