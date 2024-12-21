import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentara_mobile/pages/report/models/report.dart';

class ReportService {
  final String baseUrl = 'http://127.0.0.1:8000';

  Future<List<Report>> fetchReports() async {
    final response = await http.get(
      Uri.parse('$baseUrl/report/get-report/'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      print('Response body: ${response.body}'); // Untuk debugging
      return reportFromJson(response.body);
    } else {
      throw Exception('Failed to load reports: ${response.statusCode}');
    }
  }

  Future<bool> createReport(Report report) async {
    final response = await http.post(
      Uri.parse('$baseUrl/report/create-report/'),
      headers: {
        "Content-Type": "application/json",
      },
      body: reportToJson([report]), // Kirim sebagai array dengan satu item
    );

    print('Create report response: ${response.body}'); // Untuk debugging
    return response.statusCode == 201;
  }
}