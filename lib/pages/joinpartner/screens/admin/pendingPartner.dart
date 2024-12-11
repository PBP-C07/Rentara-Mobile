import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:rentara_mobile/pages/joinpartner/widgets/admin/partnerCard.dart';
import '../../../main/widgets/navbarAdmin.dart';
import '../../models/Partner.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

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
        primaryColor: const Color(0xFF387478),
        fontFamily: 'Poppins',
      ),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: AppBar(
            backgroundColor: const Color(0xFF387478),
            title: const Padding(
              padding: EdgeInsets.only(top: 30),
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
  List<Partner> _pendingPartners = [];
  List<Partner> _filteredPartners = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _fetchPartners(request);
  }

  Future<void> _fetchPartners(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/partner_json/');
      if (response is List) {
        List<Partner> partners =
            response.map((json) => Partner.fromJson(json)).toList();
        setState(() {
          _pendingPartners =
              partners.where((partner) => partner.fields.status == 'Pending').toList();
          _filteredPartners = _pendingPartners;
        });
      } else {
        throw Exception('Unexpected response format: Expected a list but got ${response.runtimeType}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching partners: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterPartners(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredPartners = _pendingPartners.where((partner) {
        return partner.fields.toko.toLowerCase().contains(_searchQuery) ||
            partner.fields.linkLokasi.toLowerCase().contains(_searchQuery) ||
            partner.fields.notelp.contains(_searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.9; // 90% of screen width
    final double cardHeight = MediaQuery.of(context).size.height * 0.25; // 25% of screen height

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              onChanged: _filterPartners,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
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
          // ListView for displaying partners
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPartners.length,
              itemBuilder: (context, index) {
                final partner = _filteredPartners[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: cardWidth,
                    height: cardHeight,
                    child: PendingPartnerCard(
                      id: partner.pk,
                      name: partner.fields.toko,
                      address: partner.fields.linkLokasi,
                      phone: partner.fields.notelp,
                      status: partner.fields.status,
                    ),
                  ),
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
  final String id;
  final String status;

  const PendingPartnerCard({
    super.key,
    required this.name,
    required this.address,
    required this.phone,
    required this.id,
    required this.status,
  });

  // Function to update the partner status and other details
  Future<void> updatePartnerStatus(String newStatus, BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    // Prepare the data to send in the POST request
    final data = {
      'status': newStatus,
      'toko': name, // assuming `name` is the store name (toko)
      'notelp': phone, // phone number
      'link_lokasi': address, // store location link
    };

    try {
      // Send the POST request to update the partner's data
      final response = await request.post(
        'http://127.0.0.1:8000/edit_partner_flutter/$id/', jsonEncode(data), // Use jsonEncode for encoding data
      );
      print('Response status: ${response['status']}');
      print('Response body: $response');

      if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response['message']),
            backgroundColor: const Color(0xFF387478),
          ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Failed to update partner.'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        
        content: Text('Error: $error'),
        backgroundColor: const Color(0xFF832424),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
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
          // Partner's Name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF387478),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
          // Address and Phone
          Column(
            children: [
              Text(address, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(phone, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Reject button: Set status to 'Rejected'
                    updatePartnerStatus('Rejected', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF832424),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Reject', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Accept button: Set status to 'Accepted'
                    updatePartnerStatus('Approved', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF387478),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Accept', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}