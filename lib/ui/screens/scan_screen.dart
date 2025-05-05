// import 'package:flutter/material.dart';
// import '../../RFIDPlugin.dart';
// import '../../services/rfid_service.dart';
// import '../widgets/custom_button.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/info_card.dart';
// import '../widgets/scan_button.dart';
// import 'results_screen.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool isScanning = false;
//   double distance = 0.0;
//   String status = 'Idle';
//   final RFIDService _rfidService = RFIDService();
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
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
//     releaseRFID();
//   }
//
//   Future<void> initRFID() async {
//     bool success = await RFIDPlugin.initRFID();
//     setState(() {
//       status = success ? 'RFID Initialized' : 'Init Failed';
//     });
//     print("initRFID");
//   }
//
//   Future<void> startInventory() async {
//     await RFIDPlugin.startInventory();
//     setState(() {
//       status = 'Inventory Started';
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
//   Future<void> releaseRFID() async {
//     await RFIDPlugin.releaseRFID();
//     setState(() {
//       status = 'RFID Released';
//     });
//   }
//
//   void startScan() {
//     setState(()  {
//       isScanning = true;
//       startInventory();
//     });
//     _rfidService.startScanning((newDistance) {
//       setState(() {
//         distance = newDistance;
//       });
//     });
//   }
//
//   void stopScan() {
//     setState(() {
//       isScanning = false;
//       stopInventory();
//     });
//     _rfidService.stopScanning();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('RFID Scanner'),
//         centerTitle: true,
//       ),
//       body: GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               ElevatedButton(
//                 onPressed: startInventory,
//                 child: Text('Start Inventory'),
//               ),
//               Text('Status: $status', style: TextStyle(fontSize: 18)),
//               const SizedBox(height: 30),
//               CustomTextField(
//                 hintText: 'Hello...',
//                 icon: Icons.search,
//                 controller: _searchController,
//                 focusNode: _searchFocusNode,
//                 onChanged: (text) {
//                   if (isScanning) {
//                     stopScan();
//                   }
//                 },
//                 onSubmitted: (text) {
//                   if (text.isNotEmpty && !isScanning) {
//                     startScan();
//                   } else if (text.isEmpty && isScanning) {
//                     stopScan();
//                   }
//                 },
//               ),
//               const SizedBox(height: 20),
//               InfoCard(
//                 title: 'Distance to RFID',
//                 value: '${distance.toStringAsFixed(2)} m',
//               ),
//               const SizedBox(height: 30),
//               if (isScanning) ...[
//                 const Center(child: CircularProgressIndicator()),
//                 const SizedBox(height: 20),
//               //   CustomButton(
//               //     text: 'Stop Scan',
//               //     icon: Icons.stop,
//               //     color: Colors.red,
//               //     onPressed: stopScan,
//               //   ),
//               // ] else ...[
//               //   ScanButton(
//               //     isScanning: isScanning,
//               //     onStartScan: startScan,
//               //     onStopScan: stopScan,
//               //     focusNode: _searchFocusNode,
//               //     controller: _searchController,
//               //
//               //   ),
//                 ElevatedButton(
//                   onPressed: startInventory,
//                   child: Text('Start Inventory'),
//                 ),
//               ],
//               const SizedBox(height: 20),
//               CustomButton(
//                 text: 'View Results',
//                 icon: Icons.list,
//                 onPressed: () {
//                   _searchFocusNode.unfocus(); // Unfocus the search field
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const ResultsScreen()),
//                   );
//                 },
//                 color: Color(0xFF1E1E1E),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }