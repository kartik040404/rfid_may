import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/dashboard_screens/dashboard.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/welcome_screen.dart';
import 'dart:async';

import 'package:testing_aar_file/ui/widgets/BottomNaviagtionBar.dart';

import '../../../RFIDPlugin.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitializing = true;
  bool _initSuccess = false;
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      _initializeRFID();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()), // Replace with your screen
      );
    });
  }
  Future<void> _initializeRFID() async {
    bool success = await RFIDPlugin.initRFID();
    setState(() {
      _isInitializing = false;
      _initSuccess = success;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/ZanvarGroup.png', // Replace with your image path
                width: 600,
                height: 300,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Developed by DYPCET',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}