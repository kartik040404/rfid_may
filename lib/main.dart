import 'package:flutter/material.dart';
import 'ui/screens/onboarding_screens/welcome_screen.dart';
import './routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RFID Scanner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WelcomeScreen(), // Start from WelcomeScreen
      routes: AppRoutes.getRoutes(),
    );
  }
}
