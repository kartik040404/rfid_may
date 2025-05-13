import 'package:flutter/material.dart';
import '../../RFIDPlugin.dart';
import '../../SearchTagPage.dart';
import '../../services/rfid_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/info_card.dart';
import 'result_details_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isScanning = false;
  double distance = 0.0;
  String status = 'Idle';
  final RFIDService _rfidService = RFIDService();
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
    releaseRFID();
  }



  Future<void> initRFID() async {
    bool success = await RFIDPlugin.initRFID();
    setState(() {
      status = success ? 'RFID Initialized' : 'Init Failed';
    });

    if (success) {
      int power = await RFIDPlugin.getPower();
      if (power != -1) {
        setState(() {
          selectedPower = power;
        });
      }
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
      status = 'Inventory Stopped';
    });
  }

  Future<void> releaseRFID() async {
    await RFIDPlugin.releaseRFID();
    setState(() {
      status = 'RFID Released';
    });
  }

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

    _rfidService.startScanning((newDistance) {
      setState(() {
        distance = newDistance;
      });
    });
  }

  void stopScan() {
    if (!isSingleTag) stopInventory();

    _rfidService.stopScanning();
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
                CustomTextField(
                  hintText: 'Search RFID tags...',
                  icon: Icons.search,
                  controller: _searchController,
                ),
                const SizedBox(height: 20),
                InfoCard(
                  title: 'Distance to RFID',
                  value: '${distance.toStringAsFixed(2)} m',
                ),
                const SizedBox(height: 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultDetailsScreen(
                          patternName: result['patternName']!,
                          rfidTagId: result['rfidTagId']!,
                          description: result['description']!,
                          lastScannedDate: result['lastScannedDate']!,
                        ),
                      ),
                    );
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