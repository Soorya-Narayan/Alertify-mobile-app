import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  List<Map<String, String>> contacts = [
    {'name': 'Police', 'number': '100'},
    {'name': 'Fire', 'number': '101'},
    {'name': 'Ambulance', 'number': '102'},
    {'name': 'Women\'s Helpline', 'number': '1091'},
    {'name': 'Child Helpline', 'number': '1098'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCustomContact();
  }

  Future<void> _loadCustomContact() async {
    final prefs = await SharedPreferences.getInstance();
    final storedContacts = prefs.getStringList('emergencyContacts');

    if (storedContacts != null) {
      final List<Map<String, String>> loadedContacts = storedContacts.map((contact) {
        final parts = contact.split(',');
        return {'name': parts[0], 'number': parts[1]};
      }).toList();

      setState(() {
        contacts.addAll(loadedContacts);
      });
    }
  }

  void _callNumber(String number) async {
    final Uri url = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0C1D), Color(0xFF1D1E33)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: kToolbarHeight + 16, bottom: 16),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return Card(
              color: Colors.deepPurple.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.purpleAccent),
                title: Text(
                  contact['name']!,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  contact['number']!,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () => _callNumber(contact['number']!),
              ),
            );
          },
        ),
      ),
    );
  }
}
