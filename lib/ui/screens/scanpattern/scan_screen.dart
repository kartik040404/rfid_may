import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/scanpattern/SearchTagPage.dart';
import '../../../RFIDPlugin.dart';
import '../../widgets/custom_app_bar.dart';

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
      appBar: const CustomAppBar(title: 'RFID Scanner'),
      body: SingleChildScrollView(
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
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.black),
                    SizedBox(width: 10),
                    Text(
                      "Search RFID Tags",
                      style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                            child: Text("Power $level", style: TextStyle(fontFamily: 'Poppins')),
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
                      child: const Text(
                        "Set Power",
                        style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: const Text("Single Tag Inventory", style: TextStyle(fontFamily: 'Poppins')),
              value: isSingleTag,
              activeColor: Colors.red,
              onChanged: (val) => setState(() => isSingleTag = val),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(isScanning ? Icons.stop : Icons.play_arrow),
              label: Text(
                isScanning ? "Stop Scanning" : "Start Scanning",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isScanning ? Colors.red[700] : Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: isScanning ? stopScan : startScan,
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Scanned Tags:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 100),
            epcList.isEmpty
                ? Center(
              child: Text("No tags scanned yet.", style: TextStyle(color: Colors.black45,)),
            )
                : ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: epcList.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.nfc, color: Colors.red),
                title: Text(epcList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}