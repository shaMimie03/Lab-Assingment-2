import 'package:flutter/material.dart';
import 'view/splashscreen.dart';
import 'view/loginscreen.dart';
import 'view/registerscreen.dart';
import 'view/profilescreen.dart';
import 'model/worker.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is Worker) {
            return ProfileScreen(worker: args);
          } else {
            return const LoginScreen();
          }
        },
      },
    );
  }
}
