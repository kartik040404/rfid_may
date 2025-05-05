import 'package:flutter/material.dart';
import 'package:testing_aar_file/ui/screens/dashboard_screens/dashboard.dart';
import 'package:testing_aar_file/ui/screens/onboarding_screens/welcome_screen.dart';
import 'RFIDPlugin.dart';
import './routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: RFIDHomePage(),
      home: WelcomeScreen(),
      // home : DashboardScreen(),
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

  Future<void> initRFID() async {
    bool success = await RFIDPlugin.initRFID();
    setState(() {
      status = success ? 'RFID Initialized' : 'Init Failed';
    });
  }

  Future<void> startInventory() async {
    await RFIDPlugin.startInventory();
    setState(() {
      status = 'Inventory Started';
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

  @override
  void dispose() {
    releaseRFID(); // Automatically release on app close
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
          children: [
            Text('Status: $status', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: initRFID,
              child: Text('Init RFID'),
            ),
            ElevatedButton(
              onPressed: startInventory,
              child: Text('Start Inventory'),
            ),
            ElevatedButton(
              onPressed: stopInventory,
              child: Text('Stop Inventory'),
            ),
            ElevatedButton(
              onPressed: releaseRFID,
              child: Text('Release RFID'),
            ),
          ],
        ),
      ),
    );
  }
}
