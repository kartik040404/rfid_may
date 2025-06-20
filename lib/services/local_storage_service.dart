import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _recentRegistrationsKey = 'recent_registrations';

  /// Add a pattern to local storage
  static Future<void> addRecentRegistration(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> registrations = prefs.getStringList(_recentRegistrationsKey) ?? [];

    registrations.insert(0, jsonEncode(data)); // Add to top
    await prefs.setStringList(
      _recentRegistrationsKey,
      registrations.take(20).toList(), // Keep only last 20
    );
  }

  /// Fetch all recent pattern registrations
  static Future<List<Map<String, dynamic>>> getRecentRegistrations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> registrations = prefs.getStringList(_recentRegistrationsKey) ?? [];

    return registrations
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
