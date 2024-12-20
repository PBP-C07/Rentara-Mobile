import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../../models/Partner.dart';
import '../../../main/widgets/navbarAdmin.dart';
import 'package:url_launcher/url_launcher.dart';

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
      final response = await request.get('https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/partner_json/');
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
          // ListView with Wrap
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _filteredPartners.map((partner) {
                  return PendingPartnerCard(
                    id: partner.pk,
                    name: partner.fields.toko,
                    address: partner.fields.linkLokasi,
                    phone: partner.fields.notelp,
                    status: partner.fields.status,
                  );
                }).toList(),
              ),
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

  Future<void> updatePartnerStatus(String newStatus, BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);
    final data = {
      'status': newStatus,
      'toko': name,
      'notelp': phone,
      'link_lokasi': address,
    };

    try {
      final response = await request.post(
        'https://raisa-sakila-rentaraproject.pbp.cs.ui.ac.id/edit_partner_flutter/$id/', jsonEncode(data),
      );

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message']),
            backgroundColor: const Color(0xFF387478),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PendingPartnerApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update partner.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $error'),
          backgroundColor: const Color(0xFF832424),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1), // Light background color
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Adjust height based on content
        children: [
          // Toko Name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF387478),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),

          // Location Button
          _buildActionButton(context, address, 'Location'),
          const SizedBox(height: 8),

          // Phone Number
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF387478),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              phone,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
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

  Widget _buildActionButton(BuildContext context, String url, String buttonLabel) {
    return Container(
      width: double.infinity, // Ensures the button spans the full width
      padding: const EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFF629584), // Light green color
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: () async {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            print('Could not launch $url');
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
         

          padding: EdgeInsets.zero,
        ),
        child: Text(
          buttonLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
