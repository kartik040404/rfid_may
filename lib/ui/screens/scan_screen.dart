import 'package:flutter/material.dart';
import '../../RFIDPlugin.dart';
import '../../SearchTagPage.dart';
import '../../services/rfid_service.dart';
import '../widgets/custom_button.dart';


class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScanning = false;
  double distance = 0.0;
  String status = 'Idle';
  // final RFIDService _rfidService = RFIDService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final List<String> epcList = [];
  bool isSingleTag = false;

  int selectedPower = 30;
  final List<int> powerLevels = List.generate(30, (index) => index + 1);


  @override
  void initState() {
    super.initState();
    initRFID();
    print("initState");
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
    // releaseRFID();
  }



  Future<void> initRFID() async {
    // bool success = await RFIDPlugin.initRFID();
    // setState(() {
    //   status = success ? 'RFID Initialized' : 'Init Failed';
    // });

    // if (success) {
    int power = await RFIDPlugin.getPower();
    if (power != -1) {
      setState(() {
        selectedPower = power;
      });
    }
    // }
  }


  Future<void> startInventory() async {
    setState(() {
      isScanning = true;
      status = 'Scanning...';
      epcList.clear();
    });

    await RFIDPlugin.startInventory((String epc) {
      if (!epcList.contains(epc)) {
        setState(() {
          epcList.add(epc);
        });
      }
    });
  }
  Future<void> stopInventory() async {
    await RFIDPlugin.stopInventory();
    setState(() {
      status = 'Inventory Stopped';
    });
  }

  // Future<void> releaseRFID() async {
  //   await RFIDPlugin.releaseRFID();
  //   setState(() {
  //     status = 'RFID Released';
  //   });
  // }

  // void startScan() {
  //   setState(()  {
  //     isScanning = true;
  //     startInventory();
  //
  //   });
  //   _rfidService.startScanning((newDistance) {
  //     setState(() {
  //       distance = newDistance;
  //     });
  //   });
  // }
  //
  // void stopScan() {
  //   setState(() {
  //     isScanning = false;
  //     stopInventory();
  //   });
  //   _rfidService.stopScanning();
  // }
  void startScan() async {
    setState(() {
      isScanning = true;
      epcList.clear();
      status = 'Scanning...';
    });

    if (isSingleTag) {
      final epc = await RFIDPlugin.readSingleTag();
      if (epc != null && !epcList.contains(epc)) {
        setState(() {
          epcList.add(epc);
          status = 'Single Tag Scanned';
        });
      } else {
        setState(() {
          status = 'No Tag Found';
        });
      }
      setState(() {
        isScanning = false; // reset scan flag
      });
    } else {
      await startInventory();
    }

    // _rfidService.startScanning((newDistance) {
    //   setState(() {
    //     distance = newDistance;
    //   });
    // });
  }

  void stopScan() {
    if (!isSingleTag) stopInventory();

    // _rfidService.stopScanning();
    setState(() {
      isScanning = false;
      status = 'Scan Stopped';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFID Scanner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomButton(
                  text: 'Search RFID',
                  icon: Icons.search,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchTagPage()),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        value: selectedPower,
                        isExpanded: true,
                        items: powerLevels.map((level) {
                          return DropdownMenuItem<int>(
                            value: level,
                            child: Text('Power $level'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPower = value;
                            });
                          }
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: () async {
                        final bool success = await RFIDPlugin.setPower(selectedPower);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? 'Power set successfully' : 'Failed to set power')),
                        );
                      },
                      child: const Text('Set Power'),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CheckboxListTile(
                  title: const Text('Use Single Tag Inventory'),
                  value: isSingleTag,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        isSingleTag = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 30),
                CustomButton(
                  text: isScanning ? 'Stop Scan' : 'Start Scan',
                  icon: isScanning ? Icons.stop : Icons.play_arrow,
                  color: isScanning ? Colors.red : Color(0xFF1E1E1E),
                  onPressed: isScanning ? stopScan : startScan,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'View Results',
                  icon: Icons.list,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResultsScreen()),
                    );
                  },
                ),
                Text('Scanned EPCs:', style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: epcList.length,
                    itemBuilder: (_, index) => ListTile(title: Text(epcList[index])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  Future<List<Map<String, String>>> fetchResults() async {
    // Simulate a network call or data fetching
    await Future.delayed(const Duration(seconds: 2));
    return [
      {
        'patternName': 'Pattern 1',
        'rfidTagId': 'RFID123456',
        'description': 'Description of Pattern 1',
        'lastScannedDate': '2025-02-10',
      },
      {
        'patternName': 'Pattern 2',
        'rfidTagId': 'RFID654321',
        'description': 'Description of Pattern 2',
        'lastScannedDate': '2025-02-09',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: fetchResults(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final result = snapshot.data![index];
                return ListTile(
                  title: Text(result['patternName']!),
                  subtitle: Text(result['description']!),
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ResultDetailsScreen(
                    //       patternName: result['patternName']!,
                    //       rfidTagId: result['rfidTagId']!,
                    //       description: result['description']!,
                    //       lastScannedDate: result['lastScannedDate']!,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../../RFIDPlugin.dart';
// import '../../SearchTagPage.dart';
// import '../../services/rfid_service.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/info_card.dart';
// import '../widgets/scan_button.dart';
//
// // Define a theme class to maintain consistent colors
// class AppTheme {
//   static const Color primaryBlack = Color(0xFF121212);
//   static const Color secondaryBlack = Color(0xFF1E1E1E);
//   static const Color accentRed = Color(0xFFE53935);
//   static const Color lightRed = Color(0xFFFF5252);
//   static const Color textColor = Colors.white;
// }
//
// class ScanScreen extends StatefulWidget {
//   const ScanScreen({super.key});
//
//   @override
//   State<ScanScreen> createState() => _ScanScreenState();
// }
//
// class _ScanScreenState extends State<ScanScreen> {
//   bool isScanning = false;
//   double distance = 0.0;
//   String status = 'Idle';
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   final List<String> epcList = [];
//   bool isSingleTag = false;
//
//   int selectedPower = 30;
//   final List<int> powerLevels = List.generate(30, (index) => index + 1);
//
//   @override
//   void initState() {
//     super.initState();
//     initRFID();
//     print("initState");
//   }
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     _searchFocusNode.dispose();
//     super.dispose();
//   }
//
//   Future<void> initRFID() async {
//     int power = await RFIDPlugin.getPower();
//     if (power != -1) {
//       setState(() {
//         selectedPower = power;
//       });
//     }
//   }
//
//   Future<void> startInventory() async {
//     setState(() {
//       isScanning = true;
//       status = 'Scanning...';
//       epcList.clear();
//     });
//
//     await RFIDPlugin.startInventory((String epc) {
//       if (!epcList.contains(epc)) {
//         setState(() {
//           epcList.add(epc);
//         });
//       }
//     });
//   }
//
//   Future<void> stopInventory() async {
//     await RFIDPlugin.stopInventory();
//     setState(() {
//       status = 'Inventory Stopped';
//     });
//   }
//
//   void startScan() async {
//     // Check if search field has value (if we're using it)
//     if (_searchController.text.isNotEmpty || !_searchFocusNode.hasFocus) {
//       // setState(() {
//       //   isScanning = true;
//       //   epcList.clear();
//       //   status = 'Scanning...';
//       // }
//       // );
//
//       if (isSingleTag) {
//         final epc = await RFIDPlugin.readSingleTag();
//         if (epc != null && !epcList.contains(epc)) {
//           setState(() {
//             epcList.add(epc);
//             status = 'Single Tag Scanned';
//           });
//         } else {
//           setState(() {
//             status = 'No Tag Found';
//           });
//         }
//         setState(() {
//           isScanning = false; // reset scan flag
//         });
//       } else {
//         await startInventory();
//       }
//     } else {
//       // Show error dialog if search field is empty and focused
//       // showDialog(
//       //   context: context,
//       //   builder: (BuildContext context) {
//       //     return AlertDialog(
//       //       backgroundColor: AppTheme.secondaryBlack,
//       //       title: const Text('Error', style: TextStyle(color: Colors.white)),
//       //       content: const Text(
//       //         'Please enter a RFID tag to begin searching.',
//       //         style: TextStyle(color: Colors.white),
//       //       ),
//       //       actions: <Widget>[
//       //         TextButton(
//       //           style: TextButton.styleFrom(
//       //             foregroundColor: AppTheme.accentRed,
//       //           ),
//       //           child: const Text('OK'),
//       //           onPressed: () {
//       //             Navigator.of(context).pop();
//       //           },
//       //         ),
//       //       ],
//       //     );
//       //   },
//       // );
//     }
//   }
//
//   void stopScan() {
//     if (!isSingleTag) stopInventory();
//
//     setState(() {
//       isScanning = false;
//       status = 'Scan Stopped';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primaryBlack,
//       appBar: AppBar(
//         backgroundColor: AppTheme.secondaryBlack,
//         title: const Text('RFID Scanner', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           height: 800,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 CustomButton(
//                   text: 'Search RFID',
//                   icon: Icons.search,
//                   color: AppTheme.secondaryBlack,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SearchTagPage()),
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   decoration: BoxDecoration(
//                     color: AppTheme.secondaryBlack,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Theme(
//                           data: Theme.of(context).copyWith(
//                             canvasColor: AppTheme.secondaryBlack,
//                           ),
//                           child: DropdownButton<int>(
//                             value: selectedPower,
//                             isExpanded: true,
//                             dropdownColor: AppTheme.secondaryBlack,
//                             style: const TextStyle(color: Colors.white),
//                             icon: const Icon(Icons.arrow_drop_down, color: AppTheme.accentRed),
//                             underline: Container(
//                               height: 2,
//                               color: AppTheme.accentRed,
//                             ),
//                             items: powerLevels.map((level) {
//                               return DropdownMenuItem<int>(
//                                 value: level,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 16.0),
//                                   child: Text('Power $level'),
//                                 ),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               if (value != null) {
//                                 setState(() {
//                                   selectedPower = value;
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 10),
//
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppTheme.accentRed,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                         onPressed: () async {
//                           final bool success = await RFIDPlugin.setPower(selectedPower);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(success ? 'Power set successfully' : 'Failed to set power'),
//                               backgroundColor: success ? Colors.green : AppTheme.accentRed,
//                             ),
//                           );
//                         },
//                         child: const Text('Set Power'),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                     unselectedWidgetColor: Colors.white70,
//                     checkboxTheme: CheckboxThemeData(
//                       fillColor: MaterialStateProperty.resolveWith<Color>((states) {
//                         if (states.contains(MaterialState.selected)) {
//                           return AppTheme.accentRed;
//                         }
//                         return Colors.white70;
//                       }),
//                       checkColor: MaterialStateProperty.all(Colors.white),
//                     ),
//                   ),
//                   child: CheckboxListTile(
//                     title: const Text('Use Single Tag Inventory', style: TextStyle(color: Colors.white)),
//                     value: isSingleTag,
//                     activeColor: AppTheme.accentRed,
//                     checkColor: Colors.white,
//                     onChanged: (bool? value) {
//                       if (value != null) {
//                         setState(() {
//                           isSingleTag = value;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//
//                 const SizedBox(height: 30),
//
//                 // Using the ScanButton when we have both a search field and scan functionality
//                 ScanButton(
//                   isScanning: isScanning,
//                   onStartScan: startScan,
//                   onStopScan: stopScan,
//                   focusNode: _searchFocusNode,
//                   controller: _searchController,
//                 ),
//
//                 const SizedBox(height: 20),
//                 CustomButton(
//                   text: 'View Results',
//                   icon: Icons.list,
//                   color: AppTheme.secondaryBlack,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ResultsScreen()),
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 15),
//                 Text(
//                     'Scanned EPCs:',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 16,
//                     )
//                 ),
//                 const SizedBox(height: 5),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppTheme.secondaryBlack,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListView.builder(
//                       itemCount: epcList.length,
//                       itemBuilder: (_, index) => ListTile(
//                         title: Text(
//                           epcList[index],
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         leading: const Icon(Icons.radio_button_checked, color: AppTheme.accentRed),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class ResultsScreen extends StatelessWidget {
//   const ResultsScreen({super.key});
//
//   Future<List<Map<String, String>>> fetchResults() async {
//     // Simulate a network call or data fetching
//     await Future.delayed(const Duration(seconds: 2));
//     return [
//       {
//         'patternName': 'Pattern 1',
//         'rfidTagId': 'RFID123456',
//         'description': 'Description of Pattern 1',
//         'lastScannedDate': '2025-02-10',
//       },
//       {
//         'patternName': 'Pattern 2',
//         'rfidTagId': 'RFID654321',
//         'description': 'Description of Pattern 2',
//         'lastScannedDate': '2025-02-09',
//       },
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.primaryBlack,
//       appBar: AppBar(
//         backgroundColor: AppTheme.secondaryBlack,
//         title: const Text('Results', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: fetchResults(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator(color: AppTheme.accentRed));
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No results found.', style: TextStyle(color: Colors.white)));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final result = snapshot.data![index];
//                 return Container(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: AppTheme.secondaryBlack,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: ListTile(
//                     leading: const Icon(Icons.radio_button_checked, color: AppTheme.accentRed),
//                     title: Text(result['patternName']!, style: const TextStyle(color: Colors.white)),
//                     subtitle: Text(result['description']!, style: const TextStyle(color: Colors.white70)),
//                     onTap: () {
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => ResultDetailsScreen(
//                       //       patternName: result['patternName']!,
//                       //       rfidTagId: result['rfidTagId']!,
//                       //       description: result['description']!,
//                       //       lastScannedDate: result['lastScannedDate']!,
//                       //     ),
//                       //   ),
//                       // );
//                     },
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//
