import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/dashboard_screens/SearchTagPage.dart';
import '../../../RFIDPlugin.dart';
import '../../widgets/custom_app_bar.dart';
import '../../../utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Dummy RFID tag mapping
  final Map<String, Map<String, String>> rfidTagMap = {
    'E200001D880601882800A28A': {
      'name': 'PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)',
      'code': '1010602615',
      'rfdId': 'E200001D880601882800A28A',
    },
    'E20000162015005719704BE1': {
      'name': 'PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)',
      'code': '1010602615',
      'rfdId': 'E200001D880601882800A28A',
    },
  };

  bool isScanning = false;
  String status = 'Idle';
  final List<String> epcList = [];
  bool isSingleTag = false;
  int selectedPower = 30;
  final List<int> powerLevels = List.generate(30, (index) => index + 1);
  // final Map<String, Map<String, String>> rfidTagMap = {};

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
  // Future<void> initRFID() async {
  //   int power = await RFIDPlugin.getPower();
  //   if (powerLevels.contains(power)) {
  //     setState(() {
  //       selectedPower = power;
  //     });
  //   } else {
  //     setState(() {
  //       selectedPower = powerLevels.first; // fallback to a valid value
  //     });
  //   }
  // }

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
    }

    );
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

  // Future<Map<String, String>?> fetchTagDetails(String epc) async {
  //   final response = await http.get(Uri.parse('https://your-api.com/tags/$epc'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return {
  //       'name': data['name'] ?? '',
  //       'code': data['code'] ?? '',
  //       'rfdId': data['rfdId'] ?? '',
  //       'supplier': data['supplier'] ?? '',
  //     };
  //   }
  //   return null;
  // }
  //
  //
  // Future<void> startInventory() async {
  //   setState(() {
  //     isScanning = true;
  //     status = 'Scanning...';
  //     epcList.clear();
  //   });
  //
  //   await RFIDPlugin.startInventory((String epc) async {
  //     if (!epcList.contains(epc)) {
  //       final details = await fetchTagDetails(epc);
  //       setState(() {
  //         epcList.add(epc);
  //         if (details != null) {
  //           rfidTagMap[epc] = details;
  //         }
  //       });
  //     }
  //   });
  // }
  //
  // void startScan() async {
  //   setState(() {
  //     isScanning = true;
  //     epcList.clear();
  //     status = 'Scanning...';
  //   });
  //
  //   if (isSingleTag) {
  //     final epc = await RFIDPlugin.readSingleTag();
  //     if (epc != null && !epcList.contains(epc)) {
  //       final details = await fetchTagDetails(epc);
  //       setState(() {
  //         epcList.add(epc);
  //         if (details != null) {
  //           rfidTagMap[epc] = details;
  //         }
  //         status = 'Tag Scanned';
  //         isScanning = false;
  //       });
  //     } else {
  //       setState(() {
  //         status = 'No Tag Found';
  //         isScanning = false;
  //       });
  //     }
  //   } else {
  //     await startInventory();
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context); // Initialize SizeConfig
    return Scaffold(
      appBar: const CustomAppBar(title: 'RFID Scanner'),
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
          padding: EdgeInsets.only(
            left: 4 * SizeConfig.widthMultiplier,
            right: 4 * SizeConfig.widthMultiplier,
            top: 2 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchTagPage())),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3 * SizeConfig.widthMultiplier,
                    vertical: 1.5 * SizeConfig.heightMultiplier,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromRGBO(255, 0, 0, 0.2), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.08),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.search, color: Colors.red[700], size: 2.5 * SizeConfig.textMultiplier),
                      ),
                      SizedBox(width: 2 * SizeConfig.widthMultiplier),
                      Text(
                        "Search RFID Tags",
                        style: TextStyle(
                          fontSize: 2.2 * SizeConfig.textMultiplier,
                          fontFamily: 'Poppins',
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 2.2 * SizeConfig.textMultiplier),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 1.5 * SizeConfig.heightMultiplier),

              // Power Control Section
              Container(
                padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color.fromRGBO(128, 128, 128, 0.2)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
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
                          padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.power_settings_new, color: Colors.black87, size: 2.5 * SizeConfig.textMultiplier),
                        ),
                        SizedBox(width: 2 * SizeConfig.widthMultiplier),
                        Text(
                          "Power Control",
                          style: TextStyle(
                            fontSize: 2.4 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1 * SizeConfig.heightMultiplier),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color.fromRGBO(128, 128, 128, 0.3)),
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
                                    style: const TextStyle(
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
                        SizedBox(width: 2 * SizeConfig.widthMultiplier),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red[600]!, Colors.red[700]!],
                            ),
                            borderRadius: BorderRadius.circular(10),
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
                            child: const Text(
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


              // Single Tag Toggle
              Container(
                padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Single Tag Inventory",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 2.2 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          isSingleTag ? "Enabled" : "Disabled",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 1.8 * SizeConfig.textMultiplier,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: 1,
                      child: Switch(
                        value: isSingleTag,
                        activeColor: Colors.red[600],
                        activeTrackColor: Color.fromRGBO(255, 0, 0, 0.3),
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Color.fromRGBO(128, 128, 128, 0.3),
                        onChanged: (val) => setState(() => isSingleTag = val),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
              // Scan Button
              Center(
                child: Container(
                  width: 55 * SizeConfig.widthMultiplier,
                  height: 8 * SizeConfig.heightMultiplier,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isScanning
                          ? [Colors.red[700]!, Colors.red[800]!]
                          : [Colors.black87, Colors.black],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (isScanning ? Color.fromRGBO(255, 0, 0, 1) : Color.fromRGBO(0, 0, 0, 1)).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: Container(
                      padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                      child: Icon(
                        isScanning ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                        size: 2.5 * SizeConfig.textMultiplier,
                      ),
                    ),
                    label: Text(
                      isScanning ? "Stop Scanning" : "Start Scanning",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 2.5 * SizeConfig.textMultiplier,
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

              SizedBox(height: 2.5 * SizeConfig.heightMultiplier),

              // Scanned Tags Section
              Container(
                padding: EdgeInsets.all(2.5 * SizeConfig.widthMultiplier),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Color.fromRGBO(128, 128, 128, 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
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
                          padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.nfc, color: Colors.red[700], size: 2.5 * SizeConfig.textMultiplier),
                        ),
                        SizedBox(width: 2 * SizeConfig.widthMultiplier),
                        Text(
                          "Scanned Tags",
                          style: TextStyle(
                            fontSize: 2.8 * SizeConfig.textMultiplier,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                          ),
                        ),
                        Spacer(),
                        if (epcList.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    SizedBox(height: 1.5 * SizeConfig.heightMultiplier),
                    epcList.isEmpty
                        ? Container(
                      padding: EdgeInsets.all(10 * SizeConfig.widthMultiplier),
                      child: Column(
                        children: [
                          Icon(
                            Icons.nfc_outlined,
                            size: 15 * SizeConfig.textMultiplier,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 4 * SizeConfig.heightMultiplier),
                          Text(
                            "No tags scanned yet",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 2.5 * SizeConfig.textMultiplier,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2 * SizeConfig.heightMultiplier),
                          Text(
                            "Start scanning to see RFID tags here",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 2 * SizeConfig.textMultiplier,
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
                      itemBuilder: (context, index) {
                        final epc = epcList[index];
                        final mapped = rfidTagMap[epc];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 1.2 * SizeConfig.heightMultiplier),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(1 * SizeConfig.widthMultiplier),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.nfc,
                                  color: Colors.red[600],
                                  size: 2.5 * SizeConfig.textMultiplier,
                                ),
                              ),
                              SizedBox(width: 2 * SizeConfig.widthMultiplier),
                              Expanded(
                                child: mapped != null
                                    ? GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Row(
                                                children: [
                                                  Text(
                                                    'Tag Details',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red[600],
                                                      fontSize: 2.2 * SizeConfig.textMultiplier,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Container(
                                                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),

                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Name: ${mapped['name'] ?? ''}',
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Code: ${mapped['code'] ?? ''}',
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Tag ID: ${mapped['rfdId'] ?? ''}',
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                                                    ),
                                                    SizedBox(height: 10),
                                                    const Text(
                                                      'Supplier: Demo Supplier',
                                                      style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red[50],
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  ),
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                      color: Colors.red[600],
                                                      fontWeight: FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    mapped['name'] ?? '',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.black87,
                                                      fontSize: 2 * SizeConfig.textMultiplier,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Code: ${mapped['code'] ?? ''}',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      color: Colors.grey[600],
                                                      fontSize: 1.5 * SizeConfig.textMultiplier,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            epc,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                              fontSize: 2 * SizeConfig.textMultiplier,
                                            ),
                                          ),
                                          SizedBox(height: 0.5 * SizeConfig.heightMultiplier),
                                          Text(
                                            'Unknown Tag',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.grey[600],
                                              fontSize: 1.5 * SizeConfig.textMultiplier,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1 * SizeConfig.heightMultiplier),
            ],
          ),
        ),
      ),
    );
  }
}
