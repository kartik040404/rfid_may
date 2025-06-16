// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:testing_aar_file/ui/widgets/custom_app_bar.dart';
// import '../../RFIDPlugin.dart';
//
// class NewRegisterPatternScreen extends StatefulWidget {
//   @override
//   _NewRegisterPatternScreenState createState() => _NewRegisterPatternScreenState();
// }
//
// class _NewRegisterPatternScreenState extends State<NewRegisterPatternScreen> {
//   int _currentStep = 0;
//   String status = 'Idle';
//   final TextEditingController _searchController = TextEditingController();
//
//   // Simulated pattern data for demo. Replace with your real fetch API.
//   List<Map<String, String>> allPatterns = [
//     {"name": "Pattern A", "code": "A001"},
//     {"name": "Pattern B", "code": "B001"},
//     {"name": "Pattern C", "code": "C001"},
//   ];
//   List<Map<String, String>> filteredPatterns = [];
//
//   Map<String, String>? selectedPattern;
//
//   final List<String> rfidTags = [];
//   bool isScanning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     filteredPatterns = List.from(allPatterns);
//     _searchController.addListener(_onSearchChanged);
//   }
//
//   void _onSearchChanged() {
//     String query = _searchController.text.toLowerCase();
//     setState(() {
//       filteredPatterns = allPatterns
//           .where((pattern) =>
//       pattern['name']!.toLowerCase().contains(query) ||
//           pattern['code']!.toLowerCase().contains(query))
//           .toList();
//     });
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   Future<void> startInventory() async {
//     if (rfidTags.length >= 3) {
//       setState(() {
//         status = 'Maximum 3 RFID tags allowed';
//       });
//       return;
//     }
//
//     setState(() {
//       isScanning = true;
//       status = 'Scanning for RFID tag...';
//     });
//
//     await RFIDPlugin.setPower(1);
//     final epc = await RFIDPlugin.readSingleTag();
//
//     setState(() {
//       isScanning = false;
//       if (epc != null) {
//         status = 'Tag Scanned';
//         if (!rfidTags.contains(epc)) {
//           rfidTags.add(epc);
//         } else {
//           status = 'This tag is already added';
//         }
//       } else {
//         status = 'No Tag Found';
//       }
//     });
//   }
//
//   Future<void> stopInventory() async {
//     if (isScanning) {
//       await RFIDPlugin.stopInventory();
//       setState(() {
//         isScanning = false;
//         status = 'Scanning Stopped';
//       });
//     }
//   }
//
//   void removeRfidTag(int index) {
//     setState(() {
//       rfidTags.removeAt(index);
//     });
//   }
//
//   Future<void> savePattern() async {
//     final payload = {
//       "pattern_code": selectedPattern?['code'],
//       "pattern_name": selectedPattern?['name'],
//       "rfids": rfidTags,
//     };
//
//     final uri = Uri.parse("http://:3000/patterns");
//
//     final response = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(payload),
//     );
//
//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Pattern saved successfully!')),
//       );
//
//       setState(() {
//         selectedPattern = null;
//         rfidTags.clear();
//         _currentStep = 0;
//         _searchController.clear();
//         filteredPatterns = List.from(allPatterns);
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save pattern')),
//       );
//     }
//   }
//
//   bool canProceedToNextStep() {
//     switch (_currentStep) {
//       case 0:
//         return selectedPattern != null;
//       case 1:
//         return rfidTags.isNotEmpty;
//       default:
//         return true;
//     }
//   }
//
//   // ----------- THIS IS THE KEY CHANGE -----------
//   Future<bool?> _confirmPatternDialog() async {
//     return showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) => AlertDialog(
//         title: Text('Confirm Pattern'),
//         content: Text(
//             'Pattern: ${selectedPattern?['name']} (${selectedPattern?['code']})\nProceed to attach RFID tags?'),
//         actions: <Widget>[
//           TextButton(
//             child: Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//           ),
//           ElevatedButton(
//             child: Text('Continue'),
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//   // -----------------------------------------------
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         appBar: const CustomAppBar(title: 'Register New Pattern'),
//
//         body: Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF6A5ACD),
//               onPrimary: Colors.white,
//               secondary: Color(0xFFB0B0B0),
//             ),
//           ),
//           child: Stepper(
//             type: StepperType.vertical,
//             currentStep: _currentStep,
//             onStepContinue: () async {
//               if (!canProceedToNextStep()) {
//                 String message = '';
//                 switch (_currentStep) {
//                   case 0:
//                     message = 'Please select a pattern';
//                     break;
//                   case 1:
//                     message = 'Please scan at least one RFID tag';
//                     break;
//                 }
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(message)),
//                 );
//                 return;
//               }
//               if (_currentStep == 0) {
//                 final proceed = await _confirmPatternDialog();
//                 if (proceed == true) {
//                   setState(() {
//                     _currentStep += 1;
//                     _searchController.clear(); // optional: clear after selection
//                   });
//                 }
//               } else if (_currentStep < 2) {
//                 setState(() => _currentStep += 1);
//               }
//             },
//             onStepCancel: () {
//               if (_currentStep > 0) {
//                 setState(() => _currentStep -= 1);
//               }
//             },
//             steps: [
//               // Step 1: Select pattern
//               Step(
//                 title: Text("Select Pattern Name/Code"),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         labelText: "Enter pattern name or code",
//                         border: OutlineInputBorder(),
//                         suffixIcon: Icon(Icons.search),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     if (filteredPatterns.isEmpty)
//                       Text("No patterns found", style: TextStyle(color: Colors.grey)),
//                     if (filteredPatterns.isNotEmpty)
//                       Container(
//                         height: 140,
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: filteredPatterns.length,
//                           itemBuilder: (context, idx) {
//                             final pat = filteredPatterns[idx];
//                             final isSelected = selectedPattern != null &&
//                                 selectedPattern!['code'] == pat['code'];
//                             return ListTile(
//                               tileColor: isSelected ? Colors.blue[100] : null,
//                               title: Text('${pat['name']} (${pat['code']})'),
//                               trailing: isSelected
//                                   ? Icon(Icons.check_circle, color: Colors.blue)
//                                   : null,
//                               onTap: () {
//                                 setState(() {
//                                   selectedPattern = pat;
//                                 });
//                               },
//                             );
//                           },
//                         ),
//                       ),
//                   ],
//                 ),
//                 isActive: _currentStep >= 0,
//                 state: _currentStep > 0
//                     ? StepState.complete
//                     : StepState.indexed,
//               ),
//               // Step 2: Attach RFID tags
//               Step(
//                 title: Text("Attach RFID Tags (1-3)"),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text("Status: $status"),
//                     SizedBox(height: 10),
//                     if (rfidTags.isNotEmpty) ...[
//                       Text("Scanned RFID Tags:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       SizedBox(height: 5),
//                       ...rfidTags.asMap().entries.map((entry) {
//                         int idx = entry.key;
//                         String tag = entry.value;
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Row(
//                             children: [
//                               Expanded(child: Text("${idx + 1}. $tag")),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () => removeRfidTag(idx),
//                               )
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                       Divider(),
//                     ],
//                     Text("${3 - rfidTags.length} more tag(s) can be added",
//                         style: TextStyle(fontStyle: FontStyle.italic)),
//                     SizedBox(height: 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF1E1E1E),
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: rfidTags.length < 3 ? startInventory : null,
//                       child: Text(isScanning ? "Scanning..." : "Scan RFID Tag"),
//                     ),
//                     if (isScanning)
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           foregroundColor: Colors.white,
//                         ),
//                         onPressed: stopInventory,
//                         child: Text("Stop Scanning"),
//                       ),
//                   ],
//                 ),
//                 isActive: _currentStep >= 1,
//                 state: _currentStep > 1
//                     ? StepState.complete
//                     : StepState.indexed,
//               ),
//               // Step 3: Review & Save
//               Step(
//                 title: Text("Review & Save"),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text("Pattern: ${selectedPattern?['name']} (${selectedPattern?['code']})",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 5),
//                     Text("RFID Tags (${rfidTags.length}):",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     ...rfidTags.asMap().entries.map((entry) {
//                       int idx = entry.key;
//                       String tag = entry.value;
//                       return Text("${idx + 1}. $tag");
//                     }).toList(),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF1E1E1E),
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       ),
//                       onPressed: savePattern,
//                       child: Text("Save Pattern"),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         setState(() {
//                           _currentStep = 0;
//                         });
//                       },
//                       child: Text("Cancel", style: TextStyle(color: Colors.red)),
//                     ),
//                   ],
//                 ),
//                 isActive: _currentStep >= 2,
//                 state: _currentStep == 2
//                     ? StepState.complete
//                     : StepState.indexed,
//               ),
//             ],
//             controlsBuilder: (BuildContext context, ControlsDetails details) {
//               if (_currentStep == 2) {
//                 return SizedBox.shrink();
//               }
//               return Row(
//                 children: <Widget>[
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF1E1E1E),
//                       foregroundColor: Colors.white,
//                     ),
//                     onPressed: details.onStepContinue,
//                     child: Text("Continue"),
//                   ),
//                   SizedBox(width: 10),
//                   TextButton(
//                     onPressed: details.onStepCancel,
//                     child: Text("Back", style: TextStyle(color: Colors.red)),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_aar_file/ui/widgets/custom_app_bar.dart';
import '../../RFIDPlugin.dart';

class NewRegisterPatternScreen extends StatefulWidget {
  @override
  _NewRegisterPatternScreenState createState() => _NewRegisterPatternScreenState();
}

class _NewRegisterPatternScreenState extends State<NewRegisterPatternScreen> {
  int _currentStep = 0;
  String status = 'Idle';
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> allPatterns = [
    {"name": "Pattern A", "code": "A001"},
    {"name": "Pattern B", "code": "B001"},
    {"name": "Pattern C", "code": "C001"},
  ];
  List<Map<String, String>> filteredPatterns = [];

  Map<String, String>? selectedPattern;
  final List<String> rfidTags = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    filteredPatterns = [];
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPatterns = [];
      } else {
        filteredPatterns = allPatterns
            .where((pattern) =>
        pattern['name']!.toLowerCase().contains(query) ||
            pattern['code']!.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> startInventory() async {
    if (rfidTags.length >= 3) {
      setState(() {
        status = 'Maximum 3 RFID tags allowed';
      });
      return;
    }

    setState(() {
      isScanning = true;
      status = 'Scanning for RFID tag...';
    });

    await RFIDPlugin.setPower(1);
    final epc = await RFIDPlugin.readSingleTag();

    setState(() {
      isScanning = false;
      if (epc != null) {
        status = 'Tag Scanned';
        if (!rfidTags.contains(epc)) {
          rfidTags.add(epc);
        } else {
          status = 'This tag is already added';
        }
      } else {
        status = 'No Tag Found';
      }
    });
  }

  Future<void> stopInventory() async {
    if (isScanning) {
      await RFIDPlugin.stopInventory();
      setState(() {
        isScanning = false;
        status = 'Scanning Stopped';
      });
    }
  }

  void removeRfidTag(int index) {
    setState(() {
      rfidTags.removeAt(index);
    });
  }

  Future<void> savePattern() async {
    final payload = {
      "pattern_code": selectedPattern?['code'],
      "pattern_name": selectedPattern?['name'],
      "rfids": rfidTags,
    };

    final uri = Uri.parse("http://:3000/patterns");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pattern saved successfully!')),
      );

      setState(() {
        selectedPattern = null;
        rfidTags.clear();
        _currentStep = 0;
        _searchController.clear();
        filteredPatterns = [];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save pattern')),
      );
    }
  }

  Future<bool?> _confirmPatternDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 10),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text(
              'Confirm Pattern',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            SizedBox(height: 10),
            Text('You selected:', style: TextStyle(fontSize: 14)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${selectedPattern?['name']} (${selectedPattern?['code']})',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Do you want to proceed to attach RFID tags?',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }


  bool canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return selectedPattern != null;
      case 1:
        return rfidTags.isNotEmpty;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Register New Pattern'),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6A5ACD),
              onPrimary: Colors.white,
              secondary: Color(0xFFB0B0B0),
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: _currentStep,
            onStepContinue: () async {
              if (!canProceedToNextStep()) {
                String message = _currentStep == 0
                    ? 'Please select a pattern'
                    : 'Please scan at least one RFID tag';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
                return;
              }
              if (_currentStep == 0) {
                final proceed = await _confirmPatternDialog();
                if (proceed == true) {
                  setState(() {
                    _currentStep += 1;
                    _searchController.clear();
                  });
                }
              } else if (_currentStep < 2) {
                setState(() => _currentStep += 1);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() => _currentStep -= 1);
              }
            },
            steps: [
              Step(
                title: Text("Select Pattern Name/Code"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: "Enter pattern name or code",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 12),
                    if (_searchController.text.isNotEmpty && filteredPatterns.isEmpty)
                      Text("No patterns found", style: TextStyle(color: Colors.grey)),
                    if (_searchController.text.isNotEmpty && filteredPatterns.isNotEmpty)
                      Container(
                        height: 140,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredPatterns.length,
                          itemBuilder: (context, idx) {
                            final pat = filteredPatterns[idx];
                            final isSelected = selectedPattern != null &&
                                selectedPattern!['code'] == pat['code'];
                            return ListTile(
                              tileColor: isSelected ? Colors.blue[100] : null,
                              title: Text('${pat['name']} (${pat['code']})'),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle, color: Colors.blue)
                                  : null,
                              onTap: () {
                                setState(() {
                                  selectedPattern = pat;
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text("Attach RFID Tags (1-3)"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Status: $status"),
                    SizedBox(height: 10),
                    if (rfidTags.isNotEmpty) ...[
                      Text("Scanned RFID Tags:", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      ...rfidTags.asMap().entries.map((entry) {
                        int idx = entry.key;
                        String tag = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Expanded(child: Text("${idx + 1}. $tag")),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeRfidTag(idx),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(),
                    ],
                    Text("${3 - rfidTags.length} more tag(s) can be added",
                        style: TextStyle(fontStyle: FontStyle.italic)),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E1E1E),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: rfidTags.length < 3 ? startInventory : null,
                      child: Text(isScanning ? "Scanning..." : "Scan RFID Tag"),
                    ),
                    if (isScanning)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: stopInventory,
                        child: Text("Stop Scanning"),
                      ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text("Review & Save"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Pattern: ${selectedPattern?['name']} (${selectedPattern?['code']})",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text("RFID Tags (${rfidTags.length}):",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ...rfidTags.asMap().entries.map((entry) {
                      int idx = entry.key;
                      String tag = entry.value;
                      return Text("${idx + 1}. $tag");
                    }).toList(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E1E1E),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: savePattern,
                      child: Text("Save Pattern"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentStep = 0;
                        });
                      },
                      child: Text("Cancel", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
                isActive: _currentStep >= 2,
                state: _currentStep == 2 ? StepState.complete : StepState.indexed,
              ),
            ],
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              if (_currentStep == 2) return SizedBox.shrink();
              return Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E1E),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: details.onStepContinue,
                    child: Text("Continue"),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text("Back", style: TextStyle(color: Colors.red)),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
