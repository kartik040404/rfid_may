import 'package:flutter/material.dart';
import '../ui/screens/dashboard_screens/profileSection/AboutScreen.dart';
import '../ui/screens/dashboard_screens/profileSection/SupportScreen.dart';
import '../ui/screens/onboarding_screens/login_screen.dart';
import '../ui/screens/dashboard_screens/dashboard.dart';
import '../ui/screens/dashboard_screens/scan_screen.dart';
import '../ui/screens/dashboard_screens/patternregister.dart';
import '../ui/screens/dashboard_screens/profileSection/ProfileScreen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String scanPattern = '/scanPattern';
  static const String registerPattern = '/registerPattern';
  static const String profile = '/profile';
  static const String about = '/about';
  static const String support = '/support';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      dashboard: (context) => const DashboardScreen(),
      scanPattern: (context) => const ScanScreen(),
      registerPattern: (context) => NewRegisterPatternScreen(),
      profile: (context) => const ProfileScreen(),
      about: (context) => const AboutScreen(),
      support: (context) => const SupportScreen(),
    };
  }
}