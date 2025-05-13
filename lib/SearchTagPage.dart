import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import '../../RFIDPlugin.dart';

class SearchTagPage extends StatefulWidget {
  const SearchTagPage({super.key});

  @override
  State<SearchTagPage> createState() => _SearchTagPageState();
}

class _SearchTagPageState extends State<SearchTagPage> {
  final TextEditingController _patternController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String status = 'Search by pattern name';
  bool isSearching = false;
  double signalStrength = 0.0;

  Future<List<String>> fetchPatternSuggestions(String query) async {
    final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      return [];
    }
  }

  Future<List<String>> fetchRfidsForPattern(String patternName) async {
    final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns/rfids?pattern_name=$patternName'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return [data['rfid1'], data['rfid2'], data['rfid3']]
          .where((rfid) => rfid != null && rfid.isNotEmpty)
          .cast<String>()
          .toList();
    } else {
      return [];
    }
  }

  void startSearch(List<String> rfids) async {
    setState(() {
      isSearching = true;
      status = 'Searching for ${rfids.length} tags...';
    });

    final started = await RFIDPlugin.startMultiSearchTags(rfids, (matchedEpc) {
      setState(() {
        status = 'Found: $matchedEpc';
        signalStrength = 1.0; // You could simulate strength here
      });
    });

    if (!started) {
      setState(() {
        isSearching = false;
        status = 'Failed to start search';
      });
    }
  }

  void stopSearch() async {
    await RFIDPlugin.stopSearchTag();
    setState(() {
      isSearching = false;
      status = 'Search stopped';
      signalStrength = 0.0;
    });
  }

  @override
  void dispose() {
    _patternController.dispose();
    _focusNode.dispose();
    stopSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search RFID by Pattern")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField<String>(
              controller: _patternController,
              focusNode: _focusNode,
              suggestionsCallback: fetchPatternSuggestions,
              builder: (context, controller, focusNode) {
                // This is called when building the text field
                return TextField(
                  controller: controller, // This is the internal controller
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Enter Pattern Name',
                    border: OutlineInputBorder(),
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion));
              },
              onSelected: (suggestion) {
                setState(() {
                  // When a suggestion is selected, update our controller explicitly
                  _patternController.text = suggestion;
                });
              },
              hideOnSelect: true,
              hideOnUnfocus: true,
              hideOnEmpty: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSearching
                  ? stopSearch
                  : () async {
                final pattern = _patternController.text.trim();
                if (pattern.isEmpty) return;
                final rfids = await fetchRfidsForPattern(pattern);
                if (rfids.isNotEmpty) {
                  startSearch(rfids);
                } else {
                  setState(() {
                    status = 'No RFID tags found for pattern "$pattern"';
                  });
                }
              },
              child: Text(isSearching ? "Stop Search" : "Start Search"),
            ),
            const SizedBox(height: 20),
            Text(status),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: signalStrength,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            const Text("Signal Strength Indicator"),
          ],
        ),
      ),
    );
  }
}