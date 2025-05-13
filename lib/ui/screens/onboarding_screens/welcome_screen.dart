import 'package:flutter/material.dart';
import '../../../RFIDPlugin.dart';
import '../../widgets/black_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isInitializing = true;
  bool _initSuccess = false;

  @override
  void initState() {
    super.initState();
    _initializeRFID();
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
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_initSuccess) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Failed to initialize RFID",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _initializeRFID,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    // Main UI after successful init
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "PatternTrackRFID",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Track and manage patterns with RFID technology",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 30),
              Image.asset("assets/Z.jpg", height: 130),
              const SizedBox(height: 40),
              BlackButton(
                text: "Get Started",
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
