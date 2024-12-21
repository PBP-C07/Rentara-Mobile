import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/report/services/report_service.dart';
import 'package:rentara_mobile/pages/report/models/report.dart';
import 'package:rentara_mobile/pages/report/widgets/report_form.dart';

class ReportScreen extends StatefulWidget {
  final bool viewOnly;
  
  const ReportScreen({
    Key? key,
    required this.viewOnly,
  }) : super(key: key);

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
        _loadReports();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to submit report')),
          );
        }
      }
    } catch (e) {
      print('Error adding report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.viewOnly ? 'View Reports' : 'Create Report',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF557B83),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.viewOnly
          ? ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(report.fields.vehicle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Issue: ${report.fields.issueType}'),
                        Text(report.fields.description),
                        Text(
                          'Submitted: ${report.fields.time.toString().split('.')[0]}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ReportForm(onSubmit: _addReport),
              ),
            ),
    );
  }
}