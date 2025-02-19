import 'package:flutter/material.dart';
import '../ui/screens/dashboard_screens/home_screen.dart';
import '../ui/screens/inventory_screen.dart';
import '../ui/screens/onboarding_screens/login_screen.dart';
import '../ui/screens/onboarding_screens/forgot_password_screen.dart';
import '../ui/screens/onboarding_screens/onboarding_screen.dart';
import '../ui/screens/dashboard_screens/dashboard.dart';

class AppRoutes {
  static const String home = '/home';
  static const String inventory = '/inventory';
  static const String login = '/login';
  static const String forgotPassword = '/forgotPassword';
  static const String onboarding = '/onboarding';
  static const String dashboard = '/dashboard';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => HomeScreen(),
      inventory: (context) => InventoryScreen(),
      login: (context) => LoginScreen(),
      forgotPassword: (context) => ForgotPasswordScreen(),
      onboarding: (context) => OnboardingScreen(),
      dashboard: (context) => DashboardScreen(),
    };
  }
}