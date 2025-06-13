// import 'package:flutter/material.dart';
// import '../../RFIDPlugin.dart';
// import '../../SearchTagPage.dart';
// import '../../services/rfid_service.dart';
// import '../widgets/custom_button.dart';
//
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
//   // final RFIDService _rfidService = RFIDService();
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//   final List<String> epcList = [];
//   bool isSingleTag = false;
//
//   int selectedPower = 30;
//   final List<int> powerLevels = List.generate(30, (index) => index + 1);
//
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
//     // releaseRFID();
//   }
//
//
//
//   Future<void> initRFID() async {
//     // bool success = await RFIDPlugin.initRFID();
//     // setState(() {
//     //   status = success ? 'RFID Initialized' : 'Init Failed';
//     // });
//
//     // if (success) {
//     int power = await RFIDPlugin.getPower();
//     if (power != -1) {
//       setState(() {
//         selectedPower = power;
//       });
//     }
//     // }
//   }
//
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
//   Future<void> stopInventory() async {
//     await RFIDPlugin.stopInventory();
//     setState(() {
//       status = 'Inventory Stopped';
//     });
//   }
//
//   // Future<void> releaseRFID() async {
//   //   await RFIDPlugin.releaseRFID();
//   //   setState(() {
//   //     status = 'RFID Released';
//   //   });
//   // }
//
//   // void startScan() {
//   //   setState(()  {
//   //     isScanning = true;
//   //     startInventory();
//   //
//   //   });
//   //   _rfidService.startScanning((newDistance) {
//   //     setState(() {
//   //       distance = newDistance;
//   //     });
//   //   });
//   // }
//   //
//   // void stopScan() {
//   //   setState(() {
//   //     isScanning = false;
//   //     stopInventory();
//   //   });
//   //   _rfidService.stopScanning();
//   // }
//   void startScan() async {
//     setState(() {
//       isScanning = true;
//       epcList.clear();
//       status = 'Scanning...';
//     });
//
//     if (isSingleTag) {
//       final epc = await RFIDPlugin.readSingleTag();
//       if (epc != null && !epcList.contains(epc)) {
//         setState(() {
//           epcList.add(epc);
//           status = 'Single Tag Scanned';
//         });
//       } else {
//         setState(() {
//           status = 'No Tag Found';
//         });
//       }
//       setState(() {
//         isScanning = false; // reset scan flag
//       });
//     } else {
//       await startInventory();
//     }
//
//     // _rfidService.startScanning((newDistance) {
//     //   setState(() {
//     //     distance = newDistance;
//     //   });
//     // });
//   }
//
//   void stopScan() {
//     if (!isSingleTag) stopInventory();
//
//     // _rfidService.stopScanning();
//     setState(() {
//       isScanning = false;
//       status = 'Scan Stopped';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('RFID Scanner',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//         centerTitle: true,
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
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => SearchTagPage()),
//                     );
//                   },
//                 ),
//
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButton<int>(
//                         value: selectedPower,
//                         isExpanded: true,
//                         items: powerLevels.map((level) {
//                           return DropdownMenuItem<int>(
//                             value: level,
//                             child: Text('Power $level'),
//                           );
//                         }).toList(),
//                         onChanged: (value) {
//                           if (value != null) {
//                             setState(() {
//                               selectedPower = value;
//                             });
//                           }
//                         },
//                       ),
//                     ),
//
//                     const SizedBox(width: 10),
//
//                     ElevatedButton(
//                       onPressed: () async {
//                         final bool success = await RFIDPlugin.setPower(selectedPower);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(success ? 'Power set successfully' : 'Failed to set power')),
//                         );
//                       },
//                       child: const Text('Set Power'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 10),
//                 CheckboxListTile(
//                   title: const Text('Use Single Tag Inventory'),
//                   value: isSingleTag,
//                   onChanged: (bool? value) {
//                     if (value != null) {
//                       setState(() {
//                         isSingleTag = value;
//                       });
//                     }
//                   },
//                 ),
//
//                 const SizedBox(height: 30),
//                 CustomButton(
//                   text: isScanning ? 'Stop Scan' : 'Start Scan',
//                   icon: isScanning ? Icons.stop : Icons.play_arrow,
//                   color: isScanning ? Colors.red : Color(0xFF1E1E1E),
//                   onPressed: isScanning ? stopScan : startScan,
//                 ),
//                 const SizedBox(height: 20),
//                 CustomButton(
//                   text: 'View Results',
//                   icon: Icons.list,
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => const ResultsScreen()),
//                     );
//                   },
//                 ),
//                 Text('Scanned EPCs:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: epcList.length,
//                     itemBuilder: (_, index) => ListTile(title: Text(epcList[index])),
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
//       appBar: AppBar(
//         title: const Text('Results'),
//         centerTitle: true,
//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: fetchResults(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No results found.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 final result = snapshot.data![index];
//                 return ListTile(
//                   title: Text(result['patternName']!),
//                   subtitle: Text(result['description']!),
//                   onTap: () {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (context) => ResultDetailsScreen(
//                     //       patternName: result['patternName']!,
//                     //       rfidTagId: result['rfidTagId']!,
//                     //       description: result['description']!,
//                     //       lastScannedDate: result['lastScannedDate']!,
//                     //     ),
//                     //   ),
//                     // );
//                   },
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

import 'package:flutter/material.dart';
import '../../RFIDPlugin.dart';
import '../../SearchTagPage.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScanning = false;
  String status = 'Idle';
  final List<String> epcList = [];
  bool isSingleTag = false;
  int selectedPower = 30;
  final List<int> powerLevels = List.generate(30, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    initRFID();
  }

  Future<void> initRFID() async {
    int power = await RFIDPlugin.getPower();
    if (power != -1) {
      setState(() {
        selectedPower = power;
      });
    }
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
      isScanning = false;
      status = 'Stopped';
    });
  }

  void startScan() async {
    setState(() {
      isScanning = true;
      epcList.clear();
      status = 'Scanning...';
    });

    if (isSingleTag) {
      final epc = await RFIDPlugin.readSingleTag();
      setState(() {
        if (epc != null && !epcList.contains(epc)) {
          epcList.add(epc);
          status = 'Tag Scanned';
        } else {
          status = 'No Tag Found';
        }
        isScanning = false;
      });
    } else {
      await startInventory();
    }
  }

  void stopScan() {
    if (!isSingleTag) stopInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2, // No shadow
        title: const Text(
          'RFID Scanner',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20, fontFamily: 'Poppins',
          ),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchTagPage())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.black),
                    SizedBox(width: 10),
                    Text("Search RFID Tags", style: TextStyle(fontSize: 16,fontFamily: 'Poppins',
                    )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Power selector card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedPower,
                        underline: const SizedBox(),
                        items: powerLevels.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Text("Power $level",style: TextStyle(fontFamily: 'Poppins'),),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedPower = value);
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final success = await RFIDPlugin.setPower(selectedPower);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(success ? "Power Set!" : "Failed to Set Power"),
                        ));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text("Set Power", style: TextStyle(color: Colors.white,fontFamily: 'Poppins',)),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Single Tag Inventory",style: TextStyle(fontFamily: 'Poppins',),),
              value: isSingleTag,
              activeColor: Colors.red,
              onChanged: (val) => setState(() => isSingleTag = val),
            ),

            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(isScanning ? Icons.stop : Icons.play_arrow),
              label: Text(isScanning ? "Stop Scanning" : "Start Scanning",style: TextStyle(fontFamily: 'Poppins',color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: isScanning ? Colors.red[700] : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: isScanning ? stopScan : startScan,
            ),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Scanned Tags:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: epcList.isEmpty
                  ? Center(
                child: Text("No tags scanned yet.", style: TextStyle(color: Colors.black45)),
              )
                  : ListView.separated(
                itemCount: epcList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.nfc, color: Colors.red),
                  title: Text(epcList[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
