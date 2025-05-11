import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/dashboard_screens/dashboard.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/welcome_screen.dart';
import 'package:testing_aar_file/ui/screens/results_screen.dart';
import 'RFIDPlugin.dart';
import './routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID UHF Demo',
      // home: RFIDHomePage(),
      home: HomePage(),
      // home: DashboardScreen(),
      routes: AppRoutes.getRoutes(),
    );
  }
}

class RFIDHomePage extends StatefulWidget {
  @override
  _RFIDHomePageState createState() => _RFIDHomePageState();
}

class _RFIDHomePageState extends State<RFIDHomePage> {
  String status = 'Idle';
  final List<String> epcList = [];
  bool isScanning = false;

  Future<void> initRFID() async {
    bool success = await RFIDPlugin.initRFID();
    setState(() {
      status = success ? 'RFID Initialized' : 'Init Failed';
    });
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
      status = 'Inventory Stopped';
    });
  }

  Future<void> releaseRFID() async {
    await RFIDPlugin.releaseRFID();
    setState(() {
      status = 'RFID Released';
      isScanning = false;
    });
  }

  @override
  void dispose() {
    releaseRFID();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RFID UHF Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: $status', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: initRFID, child: Text('Init RFID')),
            ElevatedButton(
              onPressed: isScanning ? null : startInventory,
              child: Text('Start Inventory'),
            ),
            ElevatedButton(
              onPressed: isScanning ? stopInventory : null,
              child: Text('Stop Inventory'),
            ),
            ElevatedButton(onPressed: releaseRFID, child: Text('Release RFID')),
            const SizedBox(height: 30),
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
    );
  }
}