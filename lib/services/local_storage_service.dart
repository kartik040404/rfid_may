// lib/services/local_storage_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _prefsKey = 'recent_register_patterns';

  /// Add a new registration to the front of the list, trim to max 4.
  static Future<void> addRecentRegistration(Map<String, dynamic> reg) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_prefsKey) ?? [];

    // Remove any existing entry with the same PatternCode to avoid duplicates
    final filtered = existing.where((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m['PatternCode'] != reg['PatternCode'];
    }).toList();

    // Insert the new one at front
    filtered.insert(0, jsonEncode(reg));

    // Keep only the first 4
    final toStore = filtered.take(4).toList();
    await prefs.setStringList(_prefsKey, toStore);
  }

  /// Retrieve up to 4 most-recent registrations.
  static Future<List<Map<String, dynamic>>> getRecentRegistrations() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? [];
    return stored.map((s) {
      return jsonDecode(s) as Map<String, dynamic>;
    }).toList();
  }
}
