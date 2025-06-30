// lib/ui/screens/onboarding_screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:testing_aar_file/RFIDPlugin.dart';
import 'package:testing_aar_file/services/pattern_service.dart';

import '../../widgets/BottomNaviagtionBar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    try {
      // Run RFID init and pattern fetch at the same time
      await Future.wait([
        RFIDPlugin.initRFID(),
        PatternService.fetchPatterns(),
      ]);
    } catch (e) {
      // TODO: handle error (e.g. show retry dialog)
      debugPrint('Error during splash init: $e');
    } finally {
      // Once done, go to MainScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/ZanvarGroup.png',
                width: 600,
                height: 300,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Developed by DYPCET',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
