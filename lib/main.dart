import 'package:flutter/material.dart';
import 'package:wtms/model/worker.dart';
import 'package:wtms/view/homescreen.dart';
import 'package:wtms/view/loginscreen.dart';
import 'package:wtms/view/tasklistscreen.dart';
import 'package:wtms/view/submissionhistoryscreen.dart';
import 'package:wtms/view/profilescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WTMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final worker = settings.arguments as Worker;
          return MaterialPageRoute(builder: (_) => HomeScreen(worker: worker));
        } else if (settings.name == '/tasks') {
          final worker = settings.arguments as Worker;
          return MaterialPageRoute(
            builder:
                (_) => TaskListScreen(
                  workerId: int.parse(worker.workerId!),
                  worker: worker,
                ),
          );
        } else if (settings.name == '/history') {
          final worker = settings.arguments as Worker;
          return MaterialPageRoute(
            builder:
                (_) => SubmissionHistoryScreen(
                  workerId: int.parse(worker.workerId!),
                ),
          );
        } else if (settings.name == '/profile') {
          final worker = settings.arguments as Worker;
          return MaterialPageRoute(
            builder: (_) => ProfileScreen(worker: worker),
          );
        } else if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        }
        return null;
      },
    );
  }
}
