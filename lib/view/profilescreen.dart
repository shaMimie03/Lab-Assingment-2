import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/config.dart';
import 'package:wtms/model/worker.dart';

class ProfileScreen extends StatefulWidget {
  final Worker worker;

  const ProfileScreen({super.key, required this.worker});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.worker.fullName ?? '');
    _emailController = TextEditingController(text: widget.worker.email ?? '');
    _phoneController = TextEditingController(text: widget.worker.phone ?? '');
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  _updateProfile() async {
    setState(() => _isSaving = true);

    try {
      final response = await http.post(
        Uri.parse("${MyConfig.myurl}/update_profile.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "worker_id": int.parse(widget.worker.workerId ?? '0'),
          "full_name": _nameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
        widget.worker.fullName = _nameController.text;
        widget.worker.email = _emailController.text;
        widget.worker.phone = _phoneController.text;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Update failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 254, 255),
      appBar: AppBar(
        title: const Text("Worker Profile"),
        backgroundColor: const Color.fromARGB(255, 38, 74, 38),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 38, 74, 38),
              ),
              accountName: Text(widget.worker.fullName ?? 'No Name'),
              accountEmail: Text(widget.worker.email ?? 'No Email'),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text("Tasks"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/tasks',
                  arguments: widget.worker,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/history',
                  arguments: widget.worker,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/profile',
                  arguments: widget.worker,
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: _logout,
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.asset("assets/images/profile.png", height: 160),
            const SizedBox(height: 10),
            Text(
              widget.worker.username ?? 'username',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const CircularProgressIndicator()
                : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 61, 117, 61),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _updateProfile,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
