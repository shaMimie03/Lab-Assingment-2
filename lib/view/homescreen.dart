import 'package:flutter/material.dart';
import 'package:wtms/model/worker.dart';
import 'package:wtms/view/profilescreen.dart';
import 'package:wtms/view/submissionhistoryscreen.dart';
import 'package:wtms/view/tasklistscreen.dart';

class HomeScreen extends StatefulWidget {
  final Worker worker;
  const HomeScreen({super.key, required this.worker});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    final String? idString = widget.worker.workerId;
    final int workerId = int.tryParse(idString ?? '') ?? 0;

    _pages = [
      TaskListScreen(workerId: workerId, worker: widget.worker),
      SubmissionHistoryScreen(workerId: workerId),
      ProfileScreen(worker: widget.worker),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
