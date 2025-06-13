// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import '../../RFIDPlugin.dart';
//
// class SearchTagPage extends StatefulWidget {
//   const SearchTagPage({super.key});
//
//   @override
//   State<SearchTagPage> createState() => _SearchTagPageState();
// }
//
// class _SearchTagPageState extends State<SearchTagPage> {
//   final TextEditingController _patternController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   String status = 'Search by pattern name';
//   bool isSearching = false;
//   double signalStrength = 0.0;
//
//   Future<List<String>> fetchPatternSuggestions(String query) async {
//     final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns?query=$query'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.cast<String>();
//     } else {
//       return [];
//     }
//   }
//
//   Future<List<String>> fetchRfidsForPattern(String patternName) async {
//     final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns/rfids?pattern_name=$patternName'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return [data['rfid1'], data['rfid2'], data['rfid3']]
//           .where((rfid) => rfid != null && rfid.isNotEmpty)
//           .cast<String>()
//           .toList();
//     } else {
//       return [];
//     }
//   }
//
//   void startSearch(List<String> rfids) async {
//     setState(() {
//       isSearching = true;
//       status = 'Searching for ${rfids.length} tags...';
//     });
//
//     final started = await RFIDPlugin.startMultiSearchTags(rfids, (matchedEpc) {
//       setState(() {
//         status = 'Found: $matchedEpc';
//         signalStrength = 1.0; // You could simulate strength here
//       });
//     });
//
//     if (!started) {
//       setState(() {
//         isSearching = false;
//         status = 'Failed to start search';
//       });
//     }
//   }
//
//   void stopSearch() async {
//     await RFIDPlugin.stopSearchTag();
//     setState(() {
//       isSearching = false;
//       status = 'Search stopped';
//       signalStrength = 0.0;
//     });
//   }
//
//   @override
//   void dispose() {
//     _patternController.dispose();
//     _focusNode.dispose();
//     stopSearch();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 2, // No shadow
//         title: const Text(
//           'Search RFID by Pattern',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(
//             color: Colors.grey.shade200, // Divider color
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TypeAheadField<String>(
//               controller: _patternController,
//               focusNode: _focusNode,
//               suggestionsCallback: fetchPatternSuggestions,
//               builder: (context, controller, focusNode) {
//                 // This is called when building the text field
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   decoration: InputDecoration(
//                     labelText: 'Enter Pattern Name',
//                     labelStyle: const TextStyle(color: Colors.black54),
//                     filled: true,
//                     fillColor: Colors.grey[200], // Light grey background
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12), // Rounded corners
//                     ),
//                   ),
//                 );
//               },
//               itemBuilder: (context, suggestion) {
//                 return ListTile(title: Text(suggestion));
//               },
//               onSelected: (suggestion) {
//                 setState(() {
//                   // When a suggestion is selected, update our controller explicitly
//                   _patternController.text = suggestion;
//                 });
//               },
//               hideOnSelect: true,
//               hideOnUnfocus: true,
//               hideOnEmpty: false,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSearching ? Colors.red : Colors.black,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: isSearching
//                   ? stopSearch
//                   : () async {
//                 final pattern = _patternController.text.trim();
//                 if (pattern.isEmpty) return;
//                 final rfids = await fetchRfidsForPattern(pattern);
//                 if (rfids.isNotEmpty) {
//                   startSearch(rfids);
//                 } else {
//                   setState(() {
//                     status = 'No RFID tags found for pattern "$pattern"';
//                   });
//                 }
//               },
//               child: Text(
//                 isSearching ? "Stop Search" : "Start Search",
//                 style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
//               ),
//             ),
//
//             const SizedBox(height: 20),
//             Text(status),
//             const SizedBox(height: 20),
//             LinearProgressIndicator(
//               value: signalStrength,
//               minHeight: 10,
//               backgroundColor: Colors.grey[300],
//               color: Colors.green,
//             ),
//             const SizedBox(height: 10),
//             const Text("Signal Strength Indicator"),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchTagPage extends StatefulWidget {
  const SearchTagPage({super.key});

  @override
  State<SearchTagPage> createState() => _SearchTagPageState();
}

class _SearchTagPageState extends State<SearchTagPage> {
  final TextEditingController _patternController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String status = 'Search by Pattern Code or Name';
  bool isSearching = false;
  double signalStrength = 0.0;
  Map<String, dynamic>? selectedPatternData;

  // Updated dummy data in requested format
  final List<Map<String, dynamic>> dummyPatterns = [
    {
      "PatternName": "PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)",
      "PatternCode": 1010602615,
      "SupplierName": "S J IRON AND STEELS PVT LTD",
      "rfid1": "E28011606000021C1790348B",
      "rfid2": "E28011606000021C1790348C",
      "rfid3": "E28011606000021C1790348D"
    },
    {
      "PatternName": "PATTERN FOR HOUSING COVER 4708 0020 3702/398534010001 (M)",
      "PatternCode": 1024602817,
      "SupplierName": "GLOBAL CASTINGS INDIA",
      "rfid1": "E28011606000021C1790348E",
      "rfid2": "E28011606000021C1790348F",
      "rfid3": "E28011606000021C17903490"
    },
    {
      "PatternName": "PATTERN FOR PUMP BODY 6712 0030 3702/398534010002 (L)",
      "PatternCode": 1035602999,
      "SupplierName": "METAL TECH FOUNDRIES",
      "rfid1": "E28011606000021C17903491",
      "rfid2": "E28011606000021C17903492",
      "rfid3": "E28011606000021C17903493"
    },
  ];

  Future<List<String>> fetchPatternSuggestions(String query) async {
    final lowerQuery = query.toLowerCase();
    return dummyPatterns
        .where((item) =>
    item['PatternName'].toString().toLowerCase().contains(lowerQuery) ||
        item['PatternCode'].toString().contains(query))
        .map((item) =>
    '${item['PatternName']} (${item['PatternCode']})') // formatted suggestions
        .toList();
  }

  Future<List<String>> fetchRfidsFromSelection(String selectedText) async {
    String patternName = "";
    String patternCode = "";

    final match = RegExp(r'(.+)\s+\((\d+)\)').firstMatch(selectedText);
    if (match != null) {
      patternName = match.group(1)!;
      patternCode = match.group(2)!;
    } else {
      patternName = selectedText;
    }

    final found = dummyPatterns.firstWhere(
          (item) =>
      item['PatternName'].toString().toLowerCase() == patternName.toLowerCase() ||
          item['PatternCode'].toString() == selectedText ||
          item['PatternCode'].toString() == patternCode,
      orElse: () => {},
    );

    if (found.isNotEmpty) {
      setState(() {
        selectedPatternData = {
          "PatternName": found["PatternName"],
          "PatternCode": found["PatternCode"],
          "SupplierName": found["SupplierName"]
        };
      });
      return [found['rfid1'], found['rfid2'], found['rfid3']]
          .where((rfid) => rfid != null && rfid.isNotEmpty)
          .cast<String>()
          .toList();
    }
    return [];
  }

  void startSearch(List<String> rfids) async {
    setState(() {
      isSearching = true;
      status = 'Searching for ${rfids.length} tags...';
    });

    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      status = 'Found: ${rfids[0]}';
      signalStrength = 1.0;
    });
  }

  void stopSearch() async {
    setState(() {
      isSearching = false;
      status = 'Search stopped';
      signalStrength = 0.0;
      selectedPatternData = null;
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text(
          'Search RFID by Pattern',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade200, height: 1.0),
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TypeAheadField<String>(
              controller: _patternController,
              focusNode: _focusNode,
              suggestionsCallback: fetchPatternSuggestions,
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Pattern Code or Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              itemBuilder: (context, suggestion) {
                return ListTile(title: Text(suggestion));
              },
              onSelected: (suggestion) {
                setState(() {
                  _patternController.text = suggestion;
                });
              },
              hideOnSelect: true,
              hideOnUnfocus: true,
              hideOnEmpty: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isSearching ? Colors.red : Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: isSearching
                  ? stopSearch
                  : () async {
                final input = _patternController.text.trim();
                if (input.isEmpty) return;

                final rfids = await fetchRfidsFromSelection(input);
                if (rfids.isNotEmpty) {
                  startSearch(rfids);
                } else {
                  setState(() {
                    status = 'No RFID tags found for "$input"';
                  });
                }
              },
              child: Text(
                isSearching ? "Stop Search" : "Start Search",
                style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
              ),
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
            const SizedBox(height: 20),
            if (selectedPatternData != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📦 Pattern Name:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedPatternData!["PatternName"] ?? ""),
                      const SizedBox(height: 8),
                      Text("🔢 Pattern Code:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedPatternData!["PatternCode"].toString()),
                      const SizedBox(height: 8),
                      Text("🏢 Supplier:", style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(selectedPatternData!["SupplierName"] ?? ""),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


