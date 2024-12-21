import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentara_mobile/pages/report/models/report.dart';

class ReportService {
  final String baseUrl = 'http://your-backend-url.com/api'; // Ganti dengan URL backend Anda

  Future<List<Report>> fetchReports() async {
    final response = await http.get(Uri.parse('$baseUrl/reports'));
    if (response.statusCode == 200) {
      return reportFromJson(response.body);
    } else {
      throw Exception('Failed to load reports');
    }
  }

  Future<bool> createReport(Report report) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reports'),
      headers: {"Content-Type": "application/json"},
      body: reportToJson([report]),
    );

    return response.statusCode == 201;
  }
}
