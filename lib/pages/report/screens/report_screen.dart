import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/report/services/report_service.dart';
import 'package:rentara_mobile/pages/report/models/report.dart';
import 'package:rentara_mobile/pages/report/services/report_service.dart';
import 'package:rentara_mobile/pages/report/widgets/report_form.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final ReportService _reportService = ReportService();
  List<Report> _reports = [];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  void _loadReports() async {
    try {
      final reports = await _reportService.fetchReports();
      setState(() {
        _reports = reports;
      });
    } catch (e) {
      print('Error loading reports: $e');
    }
  }

  void _addReport(Report report) async {
    try {
      final success = await _reportService.createReport(report);
      if (success) {
        _loadReports(); // Reload data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report')),
        );
      }
    } catch (e) {
      print('Error adding report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Reports')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return ListTile(
                  title: Text(report.fields.vehicle),
                  subtitle: Text(report.fields.description),
                  trailing: Text(report.fields.issueType),
                );
              },
            ),
          ),
          ReportForm(onSubmit: _addReport),
        ],
      ),
    );
  }
}
