import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../widgets/incident_form.dart';
import '../widgets/incident_map.dart';
import '../widgets/notifications_tab.dart';
import '../screens/profile_screen.dart';
import '../screens/login_screen.dart';
import '../services/user_service.dart';
import '../services/incident_service.dart';
import '../screens/emergency_contact_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LatLng? _incidentLocation;
  Key _notificationsKey = UniqueKey(); // Trigger rebuild for NotificationsTab

  Future<void> _handleSubmit(String address, String type, String details) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          _incidentLocation = LatLng(locations.first.latitude, locations.first.longitude);
          _notificationsKey = UniqueKey();
        });

        // Submit incident
        IncidentService().addIncident(address, type, details);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incident submitted successfully')),
        );
      } else {
        _showError("Location not found");
      }
    } catch (e) {
      _showError("Failed to geocode location");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sygnal',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // 👈 This makes it bold
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8A2BE2), Color(0xFFFFC0CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              } else if (value == 'logout') {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              } else if (value == 'contact') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyContactPage()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'contact',
                child: Text('Contact', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
            color: Colors.black87,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: IncidentForm(onSubmit: _handleSubmit),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.black54,
                          child: IncidentMap(location: _incidentLocation),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: NotificationsTab(refreshKey: _notificationsKey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
