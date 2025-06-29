// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../RFIDPlugin.dart';
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
//   Map<String, dynamic>? selectedPatternData;
//
//
//   Future<List<String>> fetchPatternSuggestions(String query) async {
//     final response = await http.get(Uri.parse('http://255.255.255.0:3000/patterns?query=$query'));
//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body);
//       return data.cast<String>();
//     } else {
//       return [];
//     }
//   }
//
//   // Future<List<String>> fetchRfidsForPattern(String patternName) async {
//   //   final response = await http.get(Uri.parse('http://192.168.0.120:3000/patterns/rfids?pattern_name=$patternName'));
//   //   if (response.statusCode == 200) {
//   //     final data = json.decode(response.body);
//   //     return [data['rfid1'], data['rfid2'], data['rfid3']]
//   //         .where((rfid) => rfid != null && rfid.isNotEmpty)
//   //         .cast<String>()
//   //         .toList();
//   //   } else {
//   //     return [];
//   //   }
//   // }
//   Future<List<String>> fetchRfidsForPattern(String patternName) async {
//     final response = await http.get(Uri.parse('http://255.255.255.0:3000/patterns/rfids?pattern_name=$patternName'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       // Store the whole object
//       setState(() {
//         selectedPatternData = data;
//       });
//
//       return [data['rfid1'], data['rfid2'], data['rfid3']]
//           .where((rfid) => rfid != null && rfid.isNotEmpty)
//           .cast<String>()
//           .toList();
//     } else {
//       return [];
//     }
//   }
//
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
//       resizeToAvoidBottomInset: true,  // Add this line to resize when keyboard appears
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           'Search RFID by Pattern',
//           style: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             fontFamily: 'Poppins',
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1.0),
//           child: Container(
//             color: Colors.grey.shade200,
//             height: 1.0,
//           ),
//         ),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Colors.grey[50]!,
//               Colors.white,
//             ],
//           ),
//         ),
//         child: SingleChildScrollView(
//           physics: const ClampingScrollPhysics(),
//           keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//           child: Padding(
//             padding: EdgeInsets.only(
//               left: 16.0,
//               right: 16.0,
//               top: 16.0,
//               bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
//             ),
//             child: Column(
//               children: [
//                 // Search Pattern Field
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(14),
//                     border: Border.all(color: Colors.red.withOpacity(0.2), width: 1.5),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TypeAheadField<String>(
//                     controller: _patternController,
//                     focusNode: _focusNode,
//                     suggestionsCallback: fetchPatternSuggestions,
//                     builder: (context, controller, focusNode) {
//                       return TextField(
//                         controller: controller,
//                         focusNode: focusNode,
//                         decoration: InputDecoration(
//                           labelText: 'Enter Pattern Name',
//                           labelStyle: TextStyle(
//                               color: Colors.black54,
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w500
//                           ),
//                           filled: true,
//                           fillColor: Colors.grey[50],
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide.none,
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(14),
//                             borderSide: BorderSide(color: Colors.red.shade300),
//                           ),
//                           prefixIcon: Container(
//                             padding: EdgeInsets.all(12),
//                             child: Icon(Icons.search, color: Colors.red[700], size: 20),
//                           ),
//                         ),
//                       );
//                     },
//                     itemBuilder: (context, suggestion) {
//                       return Container(
//                           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                           child: Text(
//                             suggestion,
//                             style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontSize: 14,
//                               color: Colors.black87,
//                             ),
//                           )
//                       );
//                     },
//                     onSelected: (suggestion) {
//                       setState(() {
//                         _patternController.text = suggestion;
//                       });
//                     },
//                     hideOnSelect: true,
//                     hideOnUnfocus: true,
//                     hideOnEmpty: false,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Search Button
//                 Center(
//                   child: Container(
//                     width: 210,
//                     height: 55,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: isSearching
//                             ? [Colors.red[700]!, Colors.red[800]!]
//                             : [Colors.black87, Colors.black],
//                       ),
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: (isSearching ? Colors.red : Colors.black).withOpacity(0.3),
//                           blurRadius: 12,
//                           offset: Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         shadowColor: Colors.transparent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       onPressed: isSearching
//                           ? stopSearch
//                           : () async {
//                         final pattern = _patternController.text.trim();
//                         if (pattern.isEmpty) return;
//                         final rfids = await fetchRfidsForPattern(pattern);
//                         if (rfids.isNotEmpty) {
//                           startSearch(rfids);
//                         } else {
//                           setState(() {
//                             status = 'No RFID tags found for pattern "$pattern"';
//                           });
//                         }
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             isSearching ? Icons.stop : Icons.search,
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             isSearching ? "Stop Search" : "Start Search",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Status and Signal Strength
//                 Container(
//                   padding: const EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     border: Border.all(color: Colors.grey.withOpacity(0.2)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.08),
//                         blurRadius: 12,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: Colors.red.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Icon(Icons.info_outline, color: Colors.red[700], size: 20),
//                           ),
//                           const SizedBox(width: 12),
//                           Text(
//                             "Status",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               fontFamily: 'Poppins',
//                               color: Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         status,
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 14,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         "Signal Strength",
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       LinearProgressIndicator(
//                         value: signalStrength,
//                         minHeight: 8,
//                         backgroundColor: Colors.grey[200],
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           signalStrength > 0 ? Colors.red[600]! : Colors.grey[400]!,
//                         ),
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 // Pattern Details Card
//                 if (selectedPatternData != null)
//                   Container(
//                     margin: const EdgeInsets.only(top: 20),
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.grey.withOpacity(0.2)),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.08),
//                           blurRadius: 12,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: Colors.red.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Icon(Icons.description_outlined, color: Colors.red[700], size: 20),
//                             ),
//                             const SizedBox(width: 12),
//                             Text(
//                               "Pattern Details",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 fontFamily: 'Poppins',
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         // Primary Details (always visible)
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[50],
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.withOpacity(0.1)),
//                           ),
//                           child: Column(
//                             children: [
//                               _buildDetailItem("Pattern Name", selectedPatternData!['PatternName']),
//                               _buildDetailItem("Code", selectedPatternData!['PatternCode']),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         // Expandable Additional Details
//                         Theme(
//                           data: Theme.of(context).copyWith(
//                             dividerColor: Colors.transparent,
//                           ),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[50],
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey.withOpacity(0.1)),
//                             ),
//                             child: ExpansionTile(
//                               tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                               title: Text(
//                                 "Additional Details",
//                                 style: TextStyle(
//                                   fontFamily: 'Poppins',
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                               leading: Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.red.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(Icons.more_horiz, color: Colors.red[700], size: 20),
//                               ),
//                               iconColor: Colors.red[700],
//                               collapsedIconColor: Colors.grey[600],
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(16),
//                                   child: Column(
//                                     children: [
//                                       _buildDetailItem("Supplier", selectedPatternData!['SupplierName']),
//                                       _buildDetailItem("Tool Life Start", selectedPatternData!['ToolLifeStartDate']),
//                                       _buildDetailItem("Invoice No", selectedPatternData!['InvoiceNo']),
//                                       _buildDetailItem("Invoice Date", selectedPatternData!['InvoiceDate']),
//                                       _buildDetailItem("Number of Parts", selectedPatternData!['NumberOfParts']),
//                                       _buildDetailItem("Parts Produced", selectedPatternData!['PartsProduced']),
//                                       _buildDetailItem("Remaining", selectedPatternData!['RemainingBalance']),
//                                       _buildDetailItem("Signal", selectedPatternData!['Signal']),
//                                       _buildDetailItem("Last Produced", selectedPatternData!['LastPrdDate']),
//                                       _buildDetailItem("Asset Name", selectedPatternData!['AssetName']),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailItem(String label, dynamic value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 12,
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value?.toString() ?? '-',
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 12,
//                 color: Colors.black87,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
  String status = 'Search by pattern name or code';
  bool isSearching = false;
  Map<String, String>? selectedItem;

  bool tagFound = false;
  double signalStrength = 0.0;

  bool showSuggestions = false;

  List<Map<String, String>> dummyData = [
    {
      'PatternName': 'PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)',
      'PatternCode': '1010602615',
      'rfdId': 'E200001D880601882800A28A',
      'SupplierName': 'ABC Supplier',
      'ToolLifeStartDate': '2024-01-01',
      'InvoiceNo': 'INV12345',
      'InvoiceDate': '2024-01-10',
      'NumberOfParts': '1000',
      'PartsProduced': '500',
      'RemainingBalance': '500',
      'Signal': 'Strong',
      'LastPrdDate': '2024-06-01',
      'AssetName': 'Bed Plate Asset',
    },
    {
      'PatternName': 'ATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)',
      'PatternCode': '1010602616',
      'rfdId': 'E20000162015005719704BE1',
      'SupplierName': 'ABC Supplier',
      'ToolLifeStartDate': '2024-01-01',
      'InvoiceNo': 'INV12345',
      'InvoiceDate': '2024-01-10',
      'NumberOfParts': '1000',
      'PartsProduced': '500',
      'RemainingBalance': '500',
      'Signal': 'Strong',
      'LastPrdDate': '2024-06-01',
      'AssetName': 'Bed Plate Asset',
    },

    // Add more items here if needed
  ];
  List<Map<String, String>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = List.from(dummyData);
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredData = dummyData.where((item) {
        return item['PatternName']!.toLowerCase().contains(query.toLowerCase()) ||
            item['PatternCode']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      showSuggestions = query.isNotEmpty;
    });
  }

  void _onSelectItem(Map<String, String> item) {
    setState(() {
      selectedItem = item;
      _patternController.text = item['PatternName'] ?? '';
      showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _startTagSearch() async {
    setState(() {
      isSearching = true;
      status = 'Searching for tag...';
      tagFound = false;
      signalStrength = 0.0;
    });
    final rfdId = selectedItem?["rfdId"];
    if (rfdId == null) return;
    await RFIDPlugin.startMultiSearchTags([rfdId], (matchedEpc) {
      setState(() {
        status = 'Tag found!';
        isSearching = false;
        tagFound = true;
        signalStrength = 1.0;
      });
      RFIDPlugin.stopSearchTag();
    });
  }

  void _stopTagSearch() async {
    await RFIDPlugin.stopSearchTag();
    setState(() {
      isSearching = false;
      status = 'Search stopped.';
      tagFound = false;
      signalStrength = 0.0;
    });
  }

  @override
  void dispose() {
    _patternController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Search RFID by Pattern',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade200,
            height: 1.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[50]!,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            ),
            child: Column(
              children: [
                // Search Pattern Field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withAlpha((0.2 * 255).toInt()), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.08 * 255).toInt()),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _patternController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          labelText: 'Search by Pattern Name or Code',
                          labelStyle: TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.red.shade300),
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.search, color: Colors.red[700], size: 20),
                          ),
                        ),
                        onChanged: _onSearchChanged,
                        onTap: () {
                          setState(() {
                            showSuggestions = _patternController.text.isNotEmpty;
                          });
                        },
                      ),
                      if (showSuggestions && filteredData.isNotEmpty)
                        Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final item = filteredData[index];
                              return ListTile(
                                title: Text(item['PatternName'] ?? '', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                                subtitle: Text('Code: ${item['PatternCode']}', style: TextStyle(fontFamily: 'Poppins')),
                                onTap: () => _onSelectItem(item),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Search Button
                Center(
                  child: Container(
                    width: 210,
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSearching
                            ? [Colors.red[700]!, Colors.red[800]!]
                            : [Colors.black87, Colors.black],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: (isSearching ? Colors.red : Colors.black).withAlpha((0.3 * 255).toInt()),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: selectedItem == null ? null : (isSearching ? _stopTagSearch : _startTagSearch),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSearching ? Icons.stop : Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSearching ? "Stop Search" : "Start Search",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Status and Signal Strength
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withAlpha((0.2 * 255).toInt())),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.08 * 255).toInt()),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withAlpha((0.1 * 255).toInt()),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.info_outline, color: Colors.red[700], size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Status",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Signal Strength",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: tagFound ? 1.0 : (isSearching ? null : 0.0),
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          tagFound ? Colors.green : Colors.red[600]!,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                // Pattern Details Card
                if (tagFound && selectedItem != null)
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withAlpha((0.2 * 255).toInt())),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.08 * 255).toInt()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withAlpha((0.1 * 255).toInt()),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.description_outlined, color: Colors.red[700], size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Pattern Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Primary Details (always visible)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withAlpha((0.1 * 255).toInt())),
                          ),
                          child: Column(
                            children: [
                              _buildDetailItem("Pattern Name", selectedItem!["PatternName"]),
                              _buildDetailItem("Code", selectedItem!["PatternCode"]),
                              _buildDetailItem("Tag ID", selectedItem!["rfdId"]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Expandable Additional Details
                        Theme(
                          data: Theme.of(context).copyWith(
                            dividerColor: Colors.transparent,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withAlpha((0.1 * 255).toInt())),
                            ),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              title: const Text(
                                "Additional Details",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withAlpha((0.1 * 255).toInt()),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.more_horiz, color: Colors.red[700], size: 20),
                              ),
                              iconColor: Colors.red[700],
                              collapsedIconColor: Colors.grey[600],
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      _buildDetailItem("Supplier", selectedItem!["SupplierName"]),
                                      _buildDetailItem("Tool Life Start", selectedItem!["ToolLifeStartDate"]),
                                      _buildDetailItem("Invoice No", selectedItem!["InvoiceNo"]),
                                      _buildDetailItem("Invoice Date", selectedItem!["InvoiceDate"]),
                                      _buildDetailItem("Number of Parts", selectedItem!["NumberOfParts"]),
                                      _buildDetailItem("Parts Produced", selectedItem!["PartsProduced"]),
                                      _buildDetailItem("Remaining", selectedItem!["RemainingBalance"]),
                                      _buildDetailItem("Signal", selectedItem!["Signal"]),
                                      _buildDetailItem("Last Produced", selectedItem!["LastPrdDate"]),
                                      _buildDetailItem("Asset Name", selectedItem!["AssetName"]),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value?.toString() ?? '-',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


