import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// 🔹 MAIN SCREEN
class SavePatternPage extends StatelessWidget {
  const SavePatternPage({super.key});

  Future<void> savePatternOnly() async {
    final prefs = await SharedPreferences.getInstance();

    final newData = {
      "PatternCode": 1010602615,
      "PatternName": "PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)",
      "date": DateTime.now().toIso8601String(),
    };

    final key = 'recent_registrations';
    final existing = prefs.getStringList(key) ?? [];
    existing.insert(0, jsonEncode(newData));
    await prefs.setStringList(key, existing.take(20).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Save Pattern')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await savePatternOnly();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Pattern saved locally."),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text("Save Pattern"),
        ),
      ),
    );
  }
}
