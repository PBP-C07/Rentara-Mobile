import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({Key? key}) : super(key: key);

  Future<List<dynamic>> fetchReports(CookieRequest request) async {
    final response = await request.get("http://127.0.0.1:8000/report/user_reports/");
    return response['reports'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Report"),
        backgroundColor: const Color(0xFF557B83),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchReports(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading reports"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada laporan."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final report = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(report['title']),
                  subtitle: Text(report['description']),
                  trailing: Text(report['date']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
