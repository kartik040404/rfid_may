import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddScanEntryScreen extends StatefulWidget {
  const AddScanEntryScreen({Key? key}) : super(key: key);

  @override
  State<AddScanEntryScreen> createState() => _AddScanEntryScreenState();
}

class _AddScanEntryScreenState extends State<AddScanEntryScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedIconName = 'inventory_2_outlined';

  final Map<String, IconData> iconOptions = {
    'inventory_2_outlined': Icons.inventory_2_outlined,
    'check_circle_outline': Icons.check_circle_outline,
    'add_circle_outline': Icons.add_circle_outline,
    'schedule_outlined': Icons.schedule_outlined,
  };

  Future<void> _saveEntry() async {
    if (_titleController.text.isEmpty || _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Time are required")),
      );
      return;
    }

    final entry = {
      'title': _titleController.text,
      'subtitle': _subtitleController.text,
      'time': _timeController.text,
      'icon': _selectedIconName,
    };

    final prefs = await SharedPreferences.getInstance();
    List<String> existingEntries = prefs.getStringList('recent_scans') ?? [];
    existingEntries.add(jsonEncode(entry));
    await prefs.setStringList('recent_scans', existingEntries);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Scan entry saved successfully")),
    );

    _titleController.clear();
    _subtitleController.clear();
    _timeController.clear();
    setState(() {
      _selectedIconName = 'inventory_2_outlined';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Scan Entry"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _subtitleController,
              decoration: const InputDecoration(labelText: "Subtitle"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _timeController,
              decoration: const InputDecoration(labelText: "Time (e.g. 2 hrs ago)"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedIconName,
              decoration: const InputDecoration(labelText: "Select Icon"),
              items: iconOptions.entries
                  .map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Icon(entry.value),
                    const SizedBox(width: 8),
                    Text(entry.key),
                  ],
                ),
              ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedIconName = value);
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEntry,
              child: const Text("Save Entry"),
            ),
          ],
        ),
      ),
    );
  }
}
