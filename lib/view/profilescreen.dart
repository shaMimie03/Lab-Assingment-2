import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wtms/model/worker.dart';

class ProfileScreen extends StatelessWidget {
  final Worker worker;

  const ProfileScreen({super.key, required this.worker});

  _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? workerData = prefs.getString("worker");

    if (workerData != null) {
      Worker worker = Worker.fromJson(jsonDecode(workerData));
      print(worker.fullName);
    }
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 254, 255),
      appBar: AppBar(
        title: const Text("Worker Profiles"),
        backgroundColor: const Color.fromARGB(255, 38, 74, 38),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Text(
              "Welcome Back, ${worker.fullName}!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),

            Image.asset("assets/images/profile.png", height: 230, width: 400),
            Text(
              "Worker ID             : ${worker.workerId}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Full Name            : ${worker.fullName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Email                    : ${worker.email}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Phone Number    : ${worker.phone}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Address                : ${worker.address}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 61, 117, 61),
                ),
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
