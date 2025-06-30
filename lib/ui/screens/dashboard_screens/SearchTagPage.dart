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
// lib/ui/screens/scanpattern/SearchTagPage.dart
// lib/ui/screens/scanpattern/SearchTagPage.dart

import 'package:flutter/material.dart';
import 'package:testing_aar_file/services/pattern_service.dart';
import 'package:testing_aar_file/model/Pattern.dart';
import '../../../RFIDPlugin.dart';
import '../../widgets/custom_app_bar.dart';
import '../../../utils/size_config.dart';

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
  bool tagFound = false;
  bool showSuggestions = false;

  Pattern? selectedPattern;
  List<Pattern> allPatterns = [];
  List<Pattern> filteredPatterns = [];

  @override
  void initState() {
    super.initState();
    // Load cached patterns
    allPatterns = PatternService.patterns.values.toList();
    filteredPatterns = List.from(allPatterns);
  }

  void _onSearchChanged(String query) {
    setState(() {
      final q = query.toLowerCase();
      filteredPatterns = allPatterns.where((p) {
        return p.patternName.toLowerCase().contains(q) ||
            p.patternCode.toLowerCase().contains(q);
      }).toList();
      showSuggestions = query.isNotEmpty;
    });
  }

  void _onSelectPattern(Pattern p) {
    _focusNode.unfocus();
    setState(() {
      selectedPattern = p;
      _patternController.text = p.patternName;
      showSuggestions = false;
    });
  }

  void _startTagSearch() async {
    if (selectedPattern == null) return;
    setState(() {
      isSearching = true;
      tagFound = false;
      status = 'Searching for tag...';
    });

    // Start scanning but do NOT auto-stop on first find
    await RFIDPlugin.startMultiSearchTags(
      [selectedPattern!.rfdId],
          (matchedEpc) {
        // Just update UI; keep scanning
        setState(() {
          tagFound = true;
          status = 'Tag found: $matchedEpc';
        });
      },
    );
  }

  void _stopTagSearch() async {
    await RFIDPlugin.stopSearchTag();
    setState(() {
      isSearching = false;
      tagFound = false;
      status = 'Search stopped.';
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
    SizeConfig.init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(title: 'Search RFID by Pattern'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[50]!, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              children: [
                // Search Field + Suggestions
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withOpacity(0.2), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: Offset(0,4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _patternController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          labelText: 'Search by Pattern Name or Code',
                          labelStyle: const TextStyle(
                            color: Colors.black54,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(horizontal:20, vertical:16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.red.shade300),
                          ),
                          prefixIcon: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.search, color: Colors.red[700], size:20),
                          ),
                        ),
                        onChanged: _onSearchChanged,
                        onTap: () {
                          setState(() {
                            showSuggestions = _patternController.text.isNotEmpty;
                          });
                        },
                      ),
                      if (showSuggestions && filteredPatterns.isNotEmpty)
                        Container(
                          constraints: const BoxConstraints(maxHeight:200),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: filteredPatterns.length,
                            itemBuilder: (context, i) {
                              final p = filteredPatterns[i];
                              return ListTile(
                                title: Text(p.patternName,
                                    style: const TextStyle(fontFamily:'Poppins', fontWeight: FontWeight.w600)),
                                subtitle: Text('Code: ${p.patternCode}',
                                    style: const TextStyle(fontFamily:'Poppins')),
                                onTap: () => _onSelectPattern(p),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height:20),

                // Search / Stop button
                Center(
                  child: Container(
                    width:210, height:55,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isSearching
                            ? [Colors.red[700]!, Colors.red[800]!]
                            : [Colors.black87, Colors.black],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: (isSearching ? Colors.red : Colors.black).withOpacity(0.3),
                            blurRadius:12, offset:Offset(0,6)
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: selectedPattern == null
                          ? null
                          : (isSearching ? _stopTagSearch : _startTagSearch),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isSearching ? Icons.stop : Icons.search, color:Colors.white),
                          const SizedBox(width:8),
                          Text(
                            isSearching ? 'Stop Search' : 'Start Search',
                            style: const TextStyle(
                                fontSize:16,
                                fontFamily:'Poppins',
                                fontWeight: FontWeight.w600,
                                color:Colors.white
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height:20),

                // Status + signal
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius:12, offset:Offset(0,4)),
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
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.info_outline, color:Colors.red[700], size:20),
                          ),
                          const SizedBox(width:12),
                          const Text('Status',
                            style: TextStyle(
                                fontSize:16,
                                fontWeight: FontWeight.w600,
                                fontFamily:'Poppins',
                                color:Colors.black87
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height:16),
                      Text(status,
                        style: TextStyle(fontFamily:'Poppins', fontSize:14, color:Colors.grey[700]),
                      ),
                      const SizedBox(height:16),
                      const Text('Signal Strength',
                        style: TextStyle(
                            fontFamily:'Poppins', fontSize:14,
                            fontWeight: FontWeight.w500, color:Colors.black87
                        ),
                      ),
                      const SizedBox(height:8),
                      LinearProgressIndicator(
                        value: tagFound ? 1.0 : (isSearching ? null : 0.0),
                        minHeight:8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            tagFound ? Colors.green : Colors.red[600]!
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),

                // Details card
                if (tagFound && selectedPattern != null)
                  Container(
                    margin: const EdgeInsets.only(top:20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius:12, offset:Offset(0,4)),
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
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.description_outlined, color:Colors.red[700], size:20),
                            ),
                            const SizedBox(width:12),
                            const Text('Pattern Details',
                              style: TextStyle(
                                  fontSize:16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily:'Poppins',
                                  color:Colors.black87
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height:16),
                        _buildDetailRow('Pattern Name', selectedPattern!.patternName),
                        _buildDetailRow('Code', selectedPattern!.patternCode),
                        _buildDetailRow('RFID', selectedPattern!.rfdId),
                        _buildDetailRow('Supplier', selectedPattern!.supplierName),
                        const SizedBox(height:16),
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(horizontal:16, vertical:8),
                            title: const Text('Additional Details',
                              style: TextStyle(
                                  fontFamily:'Poppins', fontSize:14, fontWeight: FontWeight.w600
                              ),
                            ),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.more_horiz, color: Colors.red[700], size:20),
                            ),
                            iconColor: Colors.red[700],
                            collapsedIconColor: Colors.grey[600],
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    _buildDetailRow('Tool Life Start', selectedPattern!.toolLifeStartDate.toLocal().toString().split(' ')[0]),
                                    _buildDetailRow('Invoice No', selectedPattern!.invoiceNo),
                                    _buildDetailRow('Invoice Date', selectedPattern!.invoiceDate.toLocal().toString().split(' ')[0]),
                                    _buildDetailRow('Number of Parts', selectedPattern!.numberOfParts.toString()),
                                    _buildDetailRow('Parts Produced', selectedPattern!.partsProduced.toString()),
                                    _buildDetailRow('Remaining Balance', selectedPattern!.remainingBalance.toString()),
                                    _buildDetailRow('Signal', selectedPattern!.signal),
                                    _buildDetailRow('Last Production Date', selectedPattern!.lastPrdDate.toLocal().toString().split(' ')[0]),
                                    _buildDetailRow('Asset Name', selectedPattern!.assetName),
                                  ],
                                ),
                              )
                            ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6.0),
      child: Row(
        children: [
          Expanded(
            flex:2,
            child: Text(label,
              style: const TextStyle(
                  fontFamily:'Poppins', fontSize:12,
                  fontWeight: FontWeight.w500, color:Colors.grey
              ),
            ),
          ),
          const SizedBox(width:8),
          Expanded(
            flex:3,
            child: Text(value,
              style: const TextStyle(
                  fontFamily:'Poppins', fontSize:12,
                  fontWeight: FontWeight.w600, color:Colors.black87
              ),
            ),
          ),
        ],
      ),
    );
  }
}
