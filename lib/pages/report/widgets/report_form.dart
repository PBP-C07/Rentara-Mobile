import 'package:flutter/material.dart';
import 'package:rentara_mobile/pages/report/models/report.dart';

class ReportForm extends StatefulWidget {
  final Function(Report) onSubmit;

  const ReportForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ReportForm> createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleController = TextEditingController();
  final _issueTypeController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _vehicleController.dispose();
    _issueTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final report = Report(
        model: 'report.model',
        pk: '1', // Replace with actual pk logic
        fields: Fields(
          vehicle: _vehicleController.text,
          issueType: _issueTypeController.text,
          description: _descriptionController.text,
          time: DateTime.now(),
          user: 1, // Replace with actual user ID
        ),
      );
      widget.onSubmit(report);
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _vehicleController,
              decoration: const InputDecoration(labelText: 'Vehicle'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a vehicle'
                  : null,
            ),
            TextFormField(
              controller: _issueTypeController,
              decoration: const InputDecoration(labelText: 'Issue Type'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter an issue type'
                  : null,
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter a description'
                  : null,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
