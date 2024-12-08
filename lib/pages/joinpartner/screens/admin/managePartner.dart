import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/admin/listPartner.dart';
import 'package:rentara_mobile/pages/joinpartner/screens/admin/pendingPartner.dart';
import '../../../main/widgets/navbarAdmin.dart'; // Assuming NavBarBottom is located here

void main() {
  runApp(const ManagePartnerApp());
}

class ManagePartnerApp extends StatelessWidget {
  const ManagePartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100.0, // Tinggi appBar
          backgroundColor: const Color(0xFF387478), // Warna header
          title: const Padding(
            padding: EdgeInsets.only(top: 30), // Padding atas untuk title
            child: Text(
              'MANAGE PARTNER',
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
        body: const ManagePartnerScreen(),
        bottomNavigationBar: NavBarBottomAdmin(),
      ),
    );
  }
}

class ManagePartnerScreen extends StatelessWidget {
  const ManagePartnerScreen({super.key});
  
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Bagian untuk jumlah partner
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Number of Partner',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF2F635C),
                  ),
                ),
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF2F635C),
                  child: Text(
                    '33',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Bagian detail partner yang diterima dan pending
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    'Accepted Partner',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F635C),
                    ),
                  ),
                  trailing: Text(
                    '23',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F635C),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PartnerListApp(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text(
                    'Pending Partner',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F635C),
                    ),
                  ),
                  trailing: Text(
                    '5',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF2F635C),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PendingPartnerApp(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
