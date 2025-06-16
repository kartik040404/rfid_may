// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../../RFIDPlugin.dart';
//
// class RegisterPatternPage extends StatefulWidget {
//   @override
//   _RegisterPatternPageState createState() => _RegisterPatternPageState();
// }
//
// class _RegisterPatternPageState extends State<RegisterPatternPage> {
//   int _currentStep = 0;
//   String status = 'Idle';
//   final TextEditingController _patternNameController = TextEditingController();
//   final TextEditingController _metadataController = TextEditingController();
//
//   final List<String> rfidTags = [];
//   String currentRfid = 'No RFID Found';
//   bool isScanning = false;
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   initRFID();
//   //   print("initState");
//   // }
//
//   @override
//   void dispose() {
//     _patternNameController.dispose();
//     _metadataController.dispose();
//     // releaseRFID();
//     print("===========================Dispose");
//     super.dispose();
//   }
//
//   // Future<void> initRFID() async {
//   //   bool success = await RFIDPlugin.initRFID();
//   //   setState(() {
//   //     status = success ? 'RFID Initialized' : 'Init Failed';
//   //   });
//   //   print("initRFID");
//   // }
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
//         currentRfid = epc;
//         status = 'Tag Scanned';
//
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
//   // Future<void> releaseRFID() async {
//   //   await RFIDPlugin.releaseRFID();
//   //   setState(() {
//   //     status = 'RFID Released';
//   //   });
//   // }
//
//   void removeRfidTag(int index) {
//     setState(() {
//       rfidTags.removeAt(index);
//     });
//   }
//
//   Future<void> savePattern() async {
//     final patternName = _patternNameController.text;
//     final metadata = _metadataController.text;
//     // final shelfLife = double.tryParse(_shelfLifeController.text) ?? 0.0;
//
//     final payload = {
//       "pattern_name": patternName,
//       "metadata": metadata,
//       "rfids": rfidTags
//       // "shelf_life": shelfLife
//     };
//
//     final uri = Uri.parse("http://:3000/patterns"); //server IP address
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
//       print('Pattern Saved: $payload');
//
//       setState(() {
//         _patternNameController.clear();
//         _metadataController.clear();
//         // _shelfLifeController.clear();
//         rfidTags.clear();
//         _currentStep = 0;
//       });
//     } else {
//       print('Error saving pattern: ${response.body}');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save pattern')),
//       );
//     }
//   }
//
//
//   bool canProceedToNextStep() {
//     switch (_currentStep) {
//       case 0:
//         return _patternNameController.text.isNotEmpty;
//       case 1:
//         return _metadataController.text.isNotEmpty;
//       case 2:
//         return rfidTags.isNotEmpty;
//       default:
//         return true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // await releaseRFID();
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           backgroundColor: Colors.white,
//           elevation: 2, // No shadow
//           title: const Text(
//             'Register New Pattern',
//             style: TextStyle(color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20,
//                fontFamily: 'Poppins',
//
//             ),
//           ),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(1.0),
//             child: Container(
//               color: Colors.grey.shade200, // Divider color
//               height: 1.0,
//             ),
//           ),
//         ),
//         body: Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Color(0xFF6A5ACD),
//               onPrimary: Colors.white,
//               secondary: Color(0xFFB0B0B0),
//             ),
//           ),
//           child: Stepper(
//             type: StepperType.vertical,
//             currentStep: _currentStep,
//             onStepContinue: () {
//               if (canProceedToNextStep()) {
//                 if (_currentStep < 3) {
//                   setState(() => _currentStep += 1);
//                 }
//               }
//               else {
//                 String message = '';
//                 switch (_currentStep) {
//                   case 0:
//                     message = 'Please enter a pattern name';
//                     break;
//                   case 1:
//                     message = 'Please enter metadata details';
//                     break;
//                   case 2:
//                     message = 'Please scan at least one RFID tag';
//                     break;
//                 }
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(message)),
//                 );
//               }
//             },
//             onStepCancel: () {
//               if (_currentStep > 0) {
//                 setState(() => _currentStep -= 1);
//               }
//             },
//             steps: [
//               Step(
//                 title: Text("Register New Pattern",style: TextStyle(fontFamily: 'Poppins',fontSize: 15),),
//                 content: TextField(
//                   controller: _patternNameController,
//                   decoration: InputDecoration(
//                     labelText: "Pattern Name",
//                     labelStyle: TextStyle(fontFamily: 'Poppins',fontSize: 14),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 isActive: _currentStep >= 0,
//                 state: _currentStep > 0 ? StepState.complete : StepState.indexed,
//               ),
//               Step(
//                 title: Text("Enter Pattern Metadata"),
//                 content: TextField(
//                   controller: _metadataController,
//                   decoration: InputDecoration(
//                     labelText: "Metadata Details",
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 isActive: _currentStep >= 1,
//                 state: _currentStep > 1 ? StepState.complete : StepState.indexed,
//               ),
//               Step(
//                 title: Text("Attach RFID Tags (1-3)"),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Text("Status: $status"),
//                     SizedBox(height: 10),
//
//                     // Display currently scanned tags
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
//                               Expanded(child: Text("${idx+1}. $tag")),
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
//                     // Show how many more tags can be added
//                     Text("${3 - rfidTags.length} more tag(s) can be added",
//                         style: TextStyle(fontStyle: FontStyle.italic)),
//                     SizedBox(height: 10),
//
//                     // Scan button
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF1E1E1E),
//                         foregroundColor: Colors.white,
//                       ),
//                       onPressed: rfidTags.length < 3 ? startInventory : null,
//                       child: Text(isScanning ? "Scanning..." : "Scan RFID Tag"),
//                     ),
//
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
//                 isActive: _currentStep >= 2,
//                 state: _currentStep > 2 ? StepState.complete : StepState.indexed,
//               ),
//               Step(
//                 title: Text("Save New Pattern"),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     // Summary of data
//                     Text("Pattern Name: ${_patternNameController.text}",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 5),
//                     Text("Metadata: ${_metadataController.text}"),
//                     SizedBox(height: 5),
//                     Text("RFID Tags (${rfidTags.length}):",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 5),
//                     ...rfidTags.asMap().entries.map((entry) {
//                       int idx = entry.key;
//                       String tag = entry.value;
//                       return Text("${idx+1}. $tag");
//                     }).toList(),
//                     SizedBox(height: 20),
//
//                     // Save button
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
//                 isActive: _currentStep >= 3,
//                 state: _currentStep == 3 ? StepState.complete : StepState.indexed,
//               ),
//             ],
//             controlsBuilder: (BuildContext context, ControlsDetails details) {
//               if (_currentStep == 3) {
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
import 'package:testing_aar_file/newpatternregisterscreen.dart';
import '../../RFIDPlugin.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_error_dialog.dart';

class RegisterPatternPage extends StatefulWidget {
  @override
  _RegisterPatternPageState createState() => _RegisterPatternPageState();
}

class _RegisterPatternPageState extends State<RegisterPatternPage> {
  int _currentStep = 0;
  String status = 'Idle';
  final TextEditingController _patternNameController = TextEditingController();
  final TextEditingController _metadataController = TextEditingController();
  final List<String> rfidTags = [];
  String currentRfid = 'No RFID Found';
  bool isScanning = false;

  @override
  void dispose() {
    _patternNameController.dispose();
    _metadataController.dispose();
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
        currentRfid = epc;
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
    final patternName = _patternNameController.text;
    final metadata = _metadataController.text;

    final payload = {
      "pattern_name": patternName,
      "metadata": metadata,
      "rfids": rfidTags
    };

    final uri = Uri.parse("http://192.168.15.253:3000/patterns");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pattern saved successfully!')),
      );

      setState(() {
        _patternNameController.clear();
        _metadataController.clear();
        rfidTags.clear();
        _currentStep = 0;
      });
    } else {
      showErrorDialog(context, 'Failed to save pattern');
    }
  }

  bool canProceedToNextStep() {
    switch (_currentStep) {
      case 0:
        return _patternNameController.text.isNotEmpty;
      case 1:
        return _metadataController.text.isNotEmpty;
      case 2:
        return rfidTags.isNotEmpty;
      default:
        return true;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CustomErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Register New Pattern'),

        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Theme(
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
                    onStepContinue: () {
                      if (canProceedToNextStep()) {
                        if (_currentStep < 3) {
                          setState(() => _currentStep += 1);
                        }
                      } else {
                        String message = '';
                        switch (_currentStep) {
                          case 0:
                            message = 'Please enter a pattern name';
                            break;
                          case 1:
                            message = 'Please enter metadata details';
                            break;
                          case 2:
                            message = 'Please scan at least one RFID tag';
                            break;
                        }
                        showErrorDialog(context, message);
                      }
                    },
                    onStepCancel: () {
                      if (_currentStep > 0) {
                        setState(() => _currentStep -= 1);
                      }
                    },
                    steps: [
                      Step(
                        title: Text("Register New Pattern"),
                        content: TextField(
                          controller: _patternNameController,
                          decoration: InputDecoration(
                            labelText: "Pattern Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        isActive: _currentStep >= 0,
                        state: _currentStep > 0
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text("Enter Pattern Metadata"),
                        content: TextField(
                          controller: _metadataController,
                          decoration: InputDecoration(
                            labelText: "Metadata Details",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        isActive: _currentStep >= 1,
                        state: _currentStep > 1
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text("Attach RFID Tags (1-3)"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Status: $status"),
                            SizedBox(height: 10),
                            if (rfidTags.isNotEmpty) ...[
                              Text("Scanned RFID Tags:",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              ...rfidTags.asMap().entries.map((entry) {
                                int idx = entry.key;
                                String tag = entry.value;
                                return Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("${idx + 1}. $tag")),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => removeRfidTag(idx),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                              Divider(),
                            ],
                            Text("${3 - rfidTags.length} more tag(s) can be added",
                                style:
                                TextStyle(fontStyle: FontStyle.italic)),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1E1E1E),
                                foregroundColor: Colors.white,
                              ),
                              onPressed:
                              rfidTags.length < 3 ? startInventory : null,
                              child: Text(
                                  isScanning ? "Scanning..." : "Scan RFID Tag"),
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
                        isActive: _currentStep >= 2,
                        state: _currentStep > 2
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                      Step(
                        title: Text("Save New Pattern"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Pattern Name: ${_patternNameController.text}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
                            Text("Metadata: ${_metadataController.text}"),
                            SizedBox(height: 5),
                            Text("RFID Tags (${rfidTags.length}):",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 5),
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
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
                              child: Text("Cancel",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                        isActive: _currentStep >= 3,
                        state: _currentStep == 3
                            ? StepState.complete
                            : StepState.indexed,
                      ),
                    ],
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      if (_currentStep == 3) {
                        return SizedBox.shrink();
                      }
                      return Row(
                        children: <Widget>[
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
                            child: Text("Back",
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRegisterPatternScreen(),
                    ),
                  );
                },
                child: Text("Go to New Register Pattern Page"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
