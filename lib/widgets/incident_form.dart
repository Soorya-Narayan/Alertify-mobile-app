import 'package:flutter/material.dart';

class IncidentForm extends StatefulWidget {
  final Function(String address, String incidentType, String details) onSubmit;

  const IncidentForm({super.key, required this.onSubmit});

  @override
  State<IncidentForm> createState() => _IncidentFormState();
}

class _IncidentFormState extends State<IncidentForm> {
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  String _selectedIncidentType = 'Accident';

  final List<String> _incidentTypes = [
    'Accident',
    'Fire',
    'Garbage',
    'Medical Emergency',
    'Flood',
    'Roadblock',
    'Power Failure',
    'Structural collapses',
    'Natural Disasters',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView( // ✅ Add scrollability and prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ Full width for children
            children: [
              const Text(
                'Add Incident Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedIncidentType,
                items: _incidentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedIncidentType = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Incident Type'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _detailsController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Additional Details'),
              ),
              const SizedBox(height: 12),
              SizedBox( // ✅ Prevent button overflow
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSubmit(
                      _locationController.text,
                      _selectedIncidentType,
                      _detailsController.text,
                    );
                    _locationController.clear();
                    _detailsController.clear();
                    setState(() => _selectedIncidentType = 'Accident');
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
