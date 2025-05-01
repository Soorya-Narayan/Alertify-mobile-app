import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  List<Map<String, String>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _loadSavedContacts();
  }

  Future<void> _loadSavedContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contacts = prefs.getStringList('emergencyContacts');

    if (contacts != null) {
      setState(() {
        emergencyContacts = contacts
            .map((contact) => {
          'name': contact.split(',')[0],
          'number': contact.split(',')[1],
        })
            .toList();
      });
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> contactsToSave = emergencyContacts
        .map((c) => '${c['name']},${c['number']}')
        .toList();

    await prefs.setStringList('emergencyContacts', contactsToSave);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacts saved!')),
    );
  }

  void _addContact() {
    final name = _nameController.text.trim();
    final number = _numberController.text.trim();

    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both name and number')),
      );
      return;
    }

    setState(() {
      emergencyContacts.add({'name': name, 'number': number});
    });

    _nameController.clear();
    _numberController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final user = UserService();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D0C1D), Color(0xFF1D1E33)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                Text(
                  'Email: ${user.userEmail}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Incidents Reported: ${user.alertCount}',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 30),
                const Divider(color: Colors.white38),
                const SizedBox(height: 10),
                const Text(
                  'Add Emergency Contacts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purpleAccent),
                ),
                const SizedBox(height: 10),
                _buildTextField(_nameController, 'Contact Name'),
                _buildTextField(_numberController, 'Phone Number', isPhone: true),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                  ),
                  onPressed: _addContact,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Saved Contacts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: emergencyContacts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.black38,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          emergencyContacts[index]['name']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          emergencyContacts[index]['number']!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              emergencyContacts.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveContacts,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save All Contacts'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isPhone = false}) {
    return TextField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.black26,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.purpleAccent),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
