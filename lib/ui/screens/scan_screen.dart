import 'package:flutter/material.dart';
import '../../services/rfid_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/info_card.dart';
import '../widgets/scan_button.dart';
import 'results_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isScanning = false;
  double distance = 0.0;
  final RFIDService _rfidService = RFIDService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void startScan() {
    setState(() {
      isScanning = true;
    });
    _rfidService.startScanning((newDistance) {
      setState(() {
        distance = newDistance;
      });
    });
  }

  void stopScan() {
    setState(() {
      isScanning = false;
    });
    _rfidService.stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RFID Scanner'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Unfocus the search field when tapping outside
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                hintText: 'Search RFID tags...',
                icon: Icons.search,
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (text) {
                  if (isScanning) {
                    stopScan();
                  }
                },
                onSubmitted: (text) {
                  if (text.isNotEmpty && !isScanning) {
                    startScan();
                  } else if (text.isEmpty && isScanning) {
                    stopScan();
                  }
                },
              ),
              const SizedBox(height: 20),
              InfoCard(
                title: 'Distance to RFID',
                value: '${distance.toStringAsFixed(2)} m',
              ),
              const SizedBox(height: 30),
              if (isScanning) ...[
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Stop Scan',
                  icon: Icons.stop,
                  color: Colors.red,
                  onPressed: stopScan,
                ),
              ] else ...[
                ScanButton(
                  isScanning: isScanning,
                  onStartScan: startScan,
                  onStopScan: stopScan,
                  focusNode: _searchFocusNode,
                  controller: _searchController,

                ),
              ],
              const SizedBox(height: 20),
              CustomButton(
                text: 'View Results',
                icon: Icons.list,
                onPressed: () {
                  _searchFocusNode.unfocus(); // Unfocus the search field
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ResultsScreen()),
                  );
                },
                color: Color(0xFF1E1E1E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}