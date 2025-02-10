import 'package:flutter/material.dart';
import '../../services/rfid_service.dart'; // Separate file for RFID handling

void main() {
  runApp(const RFIDApp());
}

class RFIDApp extends StatelessWidget {
  const RFIDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RFID Scanner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isScanning = false;
  double distance = 0.0;
  final RFIDService _rfidService = RFIDService();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search RFID tags...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Distance to RFID',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${distance.toStringAsFixed(2)} m',
                    style: const TextStyle(
                      fontSize: 36,
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(isScanning ? Icons.stop : Icons.play_arrow, color: Colors.white),
              label: Text(
                isScanning ? 'Stop Scan' : 'Start Scan',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: isScanning ? Colors.red : Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isScanning ? stopScan : startScan,
            ),
          ],
        ),
      ),
    );
  }
}
