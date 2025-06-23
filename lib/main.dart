import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/login_screen.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/splashscreen.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/welcome_screen.dart';
import 'package:testing_aar_file/utils/save_and_dashboard.dart';
import 'RFIDPlugin.dart';
import './routes/routes.dart';
import 'Testing/ADDEntry.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      RFIDPlugin.releaseRFID();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID UHF Demo',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: AppRoutes.getRoutes(),
    );
  }
}
