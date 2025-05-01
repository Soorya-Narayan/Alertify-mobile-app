import 'package:flutter/material.dart';
import '../services/incident_service.dart';

class NotificationsTab extends StatefulWidget {
  final Key refreshKey;

  const NotificationsTab({required this.refreshKey, super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  @override
  Widget build(BuildContext context) {
    final incidents = IncidentService().getIncidents();

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nearby Incidents",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            incidents.isEmpty
                ? const Text("No incidents reported yet.", style: TextStyle(color: Colors.white70))
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incidents.length,
              itemBuilder: (context, index) {
                final incident = incidents[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(incident.type),
                    subtitle: Text("${incident.address}\n${incident.details}"),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
