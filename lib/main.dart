import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const FleetLogApp());
}

class FleetLogApp extends StatelessWidget {
  const FleetLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Log',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}