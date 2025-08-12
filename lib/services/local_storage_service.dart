//------------------------------------------------- LocalStorageService --------------------------------------------------//
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//------------------------------------------------- Class Definition --------------------------------------------------//
class LocalStorageService {
  //------------------------------------------------- Key --------------------------------------------------//
  static const _prefsKey = 'recent_register_patterns';

  //------------------------------------------------- Add Recent Registration --------------------------------------------------//
  static Future<void> addRecentRegistration(Map<String, dynamic> reg) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_prefsKey) ?? [];

    final filtered = existing.where((s) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return m['PatternCode'] != reg['PatternCode'];
    }).toList();

    filtered.insert(0, jsonEncode(reg));

    final toStore = filtered.take(4).toList();
    await prefs.setStringList(_prefsKey, toStore);
  }

  //------------------------------------------------- Get Recent Registrations --------------------------------------------------//
  static Future<List<Map<String, dynamic>>> getRecentRegistrations() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_prefsKey) ?? [];
    return stored.map((s) {
      return jsonDecode(s) as Map<String, dynamic>;
    }).toList();
  }
}
