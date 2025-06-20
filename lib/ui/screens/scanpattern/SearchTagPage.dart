import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

import '../../../RFIDPlugin.dart';

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
  Map<String, dynamic>? selectedPatternData;


  Future<List<String>> fetchPatternSuggestions(String query) async {
    final response = await http.get(Uri.parse('http://255.255.255.0:3000/patterns?query=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<String>();
    } else {
      return [];
    }
  }

  // Future<List<String>> fetchRfidsForPattern(String patternName) async {
  //   final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns/rfids?pattern_name=$patternName'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return [data['rfid1'], data['rfid2'], data['rfid3']]
  //         .where((rfid) => rfid != null && rfid.isNotEmpty)
  //         .cast<String>()
  //         .toList();
  //   } else {
  //     return [];
  //   }
  // }
  Future<List<String>> fetchRfidsForPattern(String patternName) async {
    final response = await http.get(Uri.parse('http://255.255.255.0:3000/patterns/rfids?pattern_name=$patternName'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Store the whole object
      setState(() {
        selectedPatternData = data;
      });

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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2, // No shadow
        title: const Text(
          'Search RFID by Pattern',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200, // Divider color
            height: 1.0,
          ),
        ),
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
                // This is called when building the text field
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Pattern Name',
                    labelStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: Colors.grey[200], // Light grey background
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: isSearching ? Colors.red : Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
                margin: EdgeInsets.only(top: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedPatternData!['PatternName'] ?? '',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text("Code: ${selectedPatternData!['PatternCode'] ?? ''}"),
                      Text("Supplier: ${selectedPatternData!['SupplierName'] ?? ''}"),
                      SizedBox(height: 10),
                      Text("Tool Life Start: ${selectedPatternData!['ToolLifeStartDate'] ?? ''}"),
                      Text("Invoice No: ${selectedPatternData!['InvoiceNo'] ?? ''}"),
                      Text("Invoice Date: ${selectedPatternData!['InvoiceDate'] ?? ''}"),
                      Text("Number of Parts: ${selectedPatternData!['NumberOfParts'] ?? ''}"),
                      Text("Parts Produced: ${selectedPatternData!['PartsProduced'] ?? ''}"),
                      Text("Remaining: ${selectedPatternData!['RemainingBalance'] ?? ''}"),
                      Text("Signal: ${selectedPatternData!['Signal'] ?? ''}"),
                      Text("Last Produced: ${selectedPatternData!['LastPrdDate'] ?? ''}"),
                      Text("Asset Name: ${selectedPatternData!['AssetName'] ?? ''}"),
                    ],
                  ),
                ),
              )

          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
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
//   String status = 'Search by Pattern Code or Name';
//   bool isSearching = false;
//   double signalStrength = 0.0;
//   Map<String, dynamic>? selectedPattern;
//   List<Map<String, dynamic>> foundPatterns = [];
//   List<bool> expanded = [];
//
//   final List<Map<String, dynamic>> dummyPatterns = [
//     {
//       'PatternName': 'Pattern Alpha',
//       'PatternCode': 'PA001',
//       'SupplierName': 'Supplier A',
//       'ToolLifeStartDate': '2024-01-01',
//       'InvoiceNo': 'INV1001',
//       'InvoiceDate': '2024-01-15',
//       'NumberOfParts': 100,
//       'PartsProduced': 40,
//       'RemainingBalance': 60,
//       'Signal': 'high',
//       'LastPrdDate': '2024-05-10',
//       'AssetName': 'Asset-X',
//       'rfids': ['TAG001', 'TAG002']
//     },
//     {
//       'PatternName': 'Pattern Beta',
//       'PatternCode': 'PB002',
//       'SupplierName': 'Supplier B',
//       'ToolLifeStartDate': '2024-03-01',
//       'InvoiceNo': 'INV1022',
//       'InvoiceDate': '2024-03-12',
//       'NumberOfParts': 200,
//       'PartsProduced': 150,
//       'RemainingBalance': 50,
//       'Signal': 'Low',
//       'LastPrdDate': '2024-06-10',
//       'AssetName': 'Asset-Y',
//       'rfids': ['TAG003', 'TAG004']
//     },
//   ];
//
//   Future<List<Map<String, dynamic>>> fetchSuggestions(String query) async {
//     return dummyPatterns
//         .where((item) =>
//     item['PatternName']!.toLowerCase().contains(query.toLowerCase()) ||
//         item['PatternCode']!.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//   }
//
//   void mockStartSearch() {
//     setState(() {
//       isSearching = true;
//       status = 'Scanning for RFID signals...';
//       signalStrength = 1.0;
//
//       if (selectedPattern != null && !foundPatterns.contains(selectedPattern)) {
//         foundPatterns.add(selectedPattern!);
//         expanded.add(false);
//       }
//     });
//   }
//
//   void mockStopSearch() {
//     setState(() {
//       isSearching = false;
//       status = 'Search completed';
//       signalStrength = 0.0;
//     });
//   }
//
//   Color _getSignalColor(String signal) {
//     switch (signal.toLowerCase()) {
//       case 'high':
//         return Colors.red.shade700;
//       case 'medium':
//         return Colors.red.shade500;
//       case 'low':
//         return Colors.red.shade300;
//       default:
//         return Colors.grey;
//     }
//   }
//
//   IconData _getSignalIcon(String signal) {
//     switch (signal.toLowerCase()) {
//       case 'high':
//         return Icons.signal_cellular_4_bar;
//       case 'medium':
//         return Icons.signal_cellular_0_bar;
//       case 'low':
//         return Icons.signal_cellular_0_bar;
//       default:
//         return Icons.signal_cellular_null;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
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
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Search Input
//             TypeAheadField<Map<String, dynamic>>(
//               controller: _patternController,
//               focusNode: _focusNode,
//               suggestionsCallback: fetchSuggestions,
//               itemBuilder: (context, suggestion) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     border: Border(
//                       bottom: BorderSide(color: Colors.grey.shade300),
//                     ),
//                   ),
//                   child: ListTile(
//                     leading: Icon(Icons.developer_board, color: Colors.red),
//                     title: Text(
//                       suggestion['PatternName'] ?? '',
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                     subtitle: Text(
//                       "Code: ${suggestion['PatternCode'] ?? ''}",
//                       style: TextStyle(color: Colors.grey.shade600),
//                     ),
//                   ),
//                 );
//               },
//               onSelected: (suggestion) {
//                 setState(() {
//                   selectedPattern = suggestion;
//                   _patternController.text = suggestion['PatternName'] ?? '';
//                 });
//               },
//               builder: (context, controller, focusNode) {
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   style: const TextStyle(fontSize: 16),
//                   decoration: InputDecoration(
//                     labelText: 'Enter Pattern Name or Code',
//                     labelStyle: const TextStyle(color: Colors.black54),
//                     prefixIcon: const Icon(Icons.search, color: Colors.red),
//                     border: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.black),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.red, width: 2),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.grey.shade400),
//                     ),
//                   ),
//                 );
//               },
//             ),
//
//             const SizedBox(height: 30),
//
//             // Scan Button
//             ElevatedButton(
//               onPressed: isSearching ? mockStopSearch : mockStartSearch,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isSearching ? Colors.black : Colors.red,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     isSearching ? Icons.stop : Icons.radar,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     isSearching ? 'Stop Scan' : 'Start Scan',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // Signal Strength Indicator
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.wifi, color: Colors.red),
//                       const SizedBox(width: 8),
//                       const Text(
//                         'Signal Strength',
//                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 15),
//                   LinearProgressIndicator(
//                     value: signalStrength,
//                     backgroundColor: Colors.grey.shade300,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       signalStrength > 0.7 ? Colors.red.shade700 :
//                       signalStrength > 0.3 ? Colors.red.shade500 : Colors.red.shade300,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     status,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 25),
//
//             // Results List
//             if (foundPatterns.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: foundPatterns.length,
//                   itemBuilder: (context, index) {
//                     final item = foundPatterns[index];
//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade400),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             expanded[index] = !expanded[index];
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Icon(
//                                     Icons.developer_board,
//                                     color: Colors.red,
//                                     size: 24,
//                                   ),
//                                   const SizedBox(width: 12),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           item['PatternName'] ?? '',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Code: ${item['PatternCode'] ?? ''}",
//                                           style: const TextStyle(
//                                             color: Colors.black54,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Supplier: ${item['SupplierName'] ?? ''}",
//                                           style: const TextStyle(
//                                             color: Colors.black54,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                     decoration: BoxDecoration(
//                                       color: _getSignalColor(item['Signal'] ?? ''),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Row(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         Icon(
//                                           _getSignalIcon(item['Signal'] ?? ''),
//                                           size: 14,
//                                           color: Colors.white,
//                                         ),
//                                         const SizedBox(width: 4),
//                                         Text(
//                                           item['Signal'] ?? '',
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w600,
//                                             fontSize: 12,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               if (expanded[index]) ...[
//                                 const SizedBox(height: 16),
//                                 Container(
//                                   height: 1,
//                                   color: Colors.grey.shade300,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 _buildDetailRow("Tool Life Start", item['ToolLifeStartDate']),
//                                 _buildDetailRow("Invoice No", item['InvoiceNo']),
//                                 _buildDetailRow("Invoice Date", item['InvoiceDate']),
//                                 _buildDetailRow("Total Parts", "${item['NumberOfParts']}"),
//                                 _buildDetailRow("Parts Produced", "${item['PartsProduced']}"),
//                                 _buildDetailRow("Remaining", "${item['RemainingBalance']}"),
//                                 _buildDetailRow("Last Produced", item['LastPrdDate']),
//                                 _buildDetailRow("Asset Name", item['AssetName']),
//                               ],
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
// import '../../../RFIDPlugin.dart';
//
// class SearchTagPage extends StatefulWidget {
//   @override
//   _SearchTagPageState createState() => _SearchTagPageState();
// }
//
// class _SearchTagPageState extends State<SearchTagPage> {
//   List<dynamic> patternList = [];
//   List<bool> expanded = [];
//
//   final TextEditingController _patternController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   String status = 'Search by pattern name';
//   bool isSearching = false;
//   double signalStrength = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     // fetchSearchTagPage();
//   }
//
//   // Future<void> fetchSearchTagPage() async {
//   //   final response = await http.get(
//   //     Uri.parse('http://10.10.1.7:8301/api/productionappservices/getSearchTagPagelist'),
//   //   );
//   //   if (response.statusCode == 200) {
//   //     final List<dynamic> data = json.decode(response.body);
//   //     setState(() {
//   //       patternList = data;
//   //       expanded = List.generate(data.length, (index) => false);
//   //     });
//   //   } else {
//   //     print("Failed to load pattern data");
//   //   }
//   // }
//
//   Future<List<String>> fetchPatternSuggestions(String query) async {
//     final response = await http.get(
//       Uri.parse('http://192.168.0.120:3000/patterns?query=$query'),
//     );
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.cast<String>();
//     } else {
//       return [];
//     }
//   }
//
//   Future<List<String>> fetchRfidsForPattern(String patternName) async {
//     final response = await http.get(
//       Uri.parse('http://192.168.0.120:3000/patterns/rfids?pattern_name=$patternName'),
//     );
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
//         signalStrength = 1.0;
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
//       appBar: AppBar(title: Text('Pattern Details')),
//       body: patternList.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               TypeAheadField<String>(
//                 controller: _patternController,
//                 focusNode: _focusNode,
//                 suggestionsCallback: fetchPatternSuggestions,
//                 builder: (context, controller, focusNode) {
//                   return TextField(
//                     controller: controller,
//                     focusNode: focusNode,
//                     decoration: InputDecoration(
//                       labelText: 'Enter Pattern Name',
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   );
//                 },
//                 itemBuilder: (context, suggestion) {
//                   return ListTile(title: Text(suggestion));
//                 },
//                 onSelected: (suggestion) {
//                   setState(() {
//                     _patternController.text = suggestion;
//                   });
//                 },
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: isSearching
//                     ? stopSearch
//                     : () async {
//                   final pattern = _patternController.text.trim();
//                   if (pattern.isEmpty) return;
//                   final rfids = await fetchRfidsForPattern(pattern);
//                   if (rfids.isNotEmpty) {
//                     startSearch(rfids);
//                   } else {
//                     setState(() {
//                       status = 'No RFID tags found for "$pattern"';
//                     });
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: isSearching ? Colors.red : Colors.black,
//                   foregroundColor: Colors.white,
//                 ),
//                 child: Text(isSearching ? "Stop Search" : "Start Search"),
//               ),
//               const SizedBox(height: 10),
//               Text(status),
//               const SizedBox(height: 10),
//               LinearProgressIndicator(
//                 value: signalStrength,
//                 minHeight: 10,
//                 backgroundColor: Colors.grey[300],
//                 color: Colors.green,
//               ),
//               const SizedBox(height: 10),
//               const Text("Signal Strength Indicator"),
//               const Divider(thickness: 1),
//
//               // Pattern List
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 itemCount: patternList.length,
//                 itemBuilder: (context, index) {
//                   final item = patternList[index];
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 6),
//                     child: InkWell(
//                       onTap: () {
//                         setState(() {
//                           expanded[index] = !expanded[index];
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item['PatternName'] ?? '',
//                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             Text("Code: ${item['PatternCode']}"),
//                             Text("Supplier: ${item['SupplierName']}"),
//                             if (expanded[index]) ...[
//                               SizedBox(height: 10),
//                               Text("Tool Life Start: ${item['ToolLifeStartDate']}"),
//                               Text("Invoice No: ${item['InvoiceNo']}"),
//                               Text("Invoice Date: ${item['InvoiceDate']}"),
//                               Text("Number of Parts: ${item['NumberOfParts']}"),
//                               Text("Parts Produced: ${item['PartsProduced']}"),
//                               Text("Remaining: ${item['RemainingBalance']}"),
//                               Text("Signal: ${item['Signal']}"),
//                               Text("Last Produced: ${item['LastPrdDate']}"),
//                               Text("Asset Name: ${item['AssetName']}"),
//                             ]
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



