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
      // body: SingleChildScrollView(
      //   padding: const EdgeInsets.all(16),
      //   child: Column(
      //     children: [
      //       GestureDetector(
      //         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchTagPage())),
      //         child: Container(
      //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //           decoration: BoxDecoration(
      //             color: Colors.grey[100],
      //             borderRadius: BorderRadius.circular(12),
      //             border: Border.all(color: Colors.grey.shade300),
      //           ),
      //           child: const Row(
      //             children: [
      //               Icon(Icons.search, color: Colors.black),
      //               SizedBox(width: 10),
      //               Text(
      //                 "Search RFID Tags",
      //                 style: TextStyle(fontSize: 16, fontFamily: 'Poppins'),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       Card(
      //         elevation: 2,
      //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      //         child: Padding(
      //           padding: const EdgeInsets.all(16.0),
      //           child: Row(
      //             children: [
      //               Expanded(
      //                 child: DropdownButton<int>(
      //                   isExpanded: true,
      //                   value: selectedPower,
      //                   underline: const SizedBox(),
      //                   items: powerLevels.map((level) {
      //                     return DropdownMenuItem(
      //                       value: level,
      //                       child: Text("Power $level", style: TextStyle(fontFamily: 'Poppins')),
      //                     );
      //                   }).toList(),
      //                   onChanged: (value) {
      //                     if (value != null) {
      //                       setState(() => selectedPower = value);
      //                     }
      //                   },
      //                 ),
      //               ),
      //               ElevatedButton(
      //                 onPressed: () async {
      //                   final success = await RFIDPlugin.setPower(selectedPower);
      //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //                     content: Text(success ? "Power Set!" : "Failed to Set Power"),
      //                   ));
      //                 },
      //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
      //                 child: const Text(
      //                   "Set Power",
      //                   style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           const Text(
      //             "Single Tag Inventory",
      //             style: TextStyle(fontFamily: 'Poppins'),
      //           ),
      //           Switch(
      //             value: isSingleTag,
      //             activeColor: Colors.red,
      //             onChanged: (val) => setState(() => isSingleTag = val),
      //           ),
      //         ],
      //       ),
      //       const SizedBox(height: 10),
      //       ElevatedButton.icon(
      //         icon: Icon(isScanning ? Icons.stop : Icons.play_arrow),
      //         label: Text(
      //           isScanning ? "Stop Scanning" : "Start Scanning",
      //           style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
      //         ),
      //         style: ElevatedButton.styleFrom(
      //           backgroundColor: isScanning ? Colors.red[700] : Colors.black,
      //           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //         ),
      //         onPressed: isScanning ? stopScan : startScan,
      //       ),
      //       const SizedBox(height: 30),
      //       Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text("Scanned Tags:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      //       ),
      //       const SizedBox(height: 100),
      //       epcList.isEmpty
      //           ? Center(
      //         child: Text("No tags scanned yet.", style: TextStyle(color: Colors.black45,)),
      //       )
      //           : ListView.separated(
      //         shrinkWrap: true,
      //         physics: NeverScrollableScrollPhysics(),
      //         itemCount: epcList.length,
      //         separatorBuilder: (_, __) => const Divider(),
      //         itemBuilder: (context, index) => ListTile(
      //           leading: const Icon(Icons.nfc, color: Colors.red),
      //           title: Text(epcList[index]),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

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
          padding: const EdgeInsets.only(left: 16,right: 16,top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchTagPage())),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.withOpacity(0.2), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.search, color: Colors.red[700], size: 20),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Search RFID Tags",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Power Control Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
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
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.power_settings_new, color: Colors.black87, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Power Control",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: DropdownButton<int>(
                              isExpanded: true,
                              value: selectedPower,
                              underline: const SizedBox(),
                              icon: Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                              items: powerLevels.map((level) {
                                return DropdownMenuItem(
                                  value: level,
                                  child: Text(
                                    "Power Level $level",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedPower = value);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red[600]!, Colors.red[700]!],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final success = await RFIDPlugin.setPower(selectedPower);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(success ? "Power Set Successfully!" : "Failed to Set Power"),
                                  backgroundColor: success ? Colors.green[600] : Colors.red[600],
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              "Set Power",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Single Tag Toggle
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSingleTag ? Colors.red.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.inventory,
                            color: isSingleTag ? Colors.red[700] : Colors.grey[600],
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Single Tag Inventory",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              isSingleTag ? "Enabled" : "Disabled",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 1.2,
                      child: Switch(
                        value: isSingleTag,
                        activeColor: Colors.red[600],
                        activeTrackColor: Colors.red.withOpacity(0.3),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        onChanged: (val) => setState(() => isSingleTag = val),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              // Scan Button
              Center(
                child: Container(
                  width: 210,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isScanning
                          ? [Colors.red[700]!, Colors.red[800]!]
                          : [Colors.black87, Colors.black],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (isScanning ? Colors.red : Colors.black).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        isScanning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    label: Text(
                      isScanning ? "Stop Scanning" : "Start Scanning",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: isScanning ? stopScan : startScan,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Scanned Tags Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
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
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.nfc, color: Colors.red[700], size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Scanned Tags",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        if (epcList.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Text(
                              "${epcList.length}",
                              style: TextStyle(
                                color: Colors.red[700],
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    epcList.isEmpty
                        ? Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.nfc_outlined,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No tags scanned yet",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Start scanning to see RFID tags here",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    )
                        : ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: epcList.length,
                      separatorBuilder: (_, __) => Divider(
                        color: Colors.grey[200],
                        thickness: 1,
                        height: 1,
                      ),
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.nfc,
                                color: Colors.red[600],
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    epcList[index],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Tag ${index + 1}",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}