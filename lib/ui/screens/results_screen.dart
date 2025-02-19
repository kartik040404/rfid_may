import 'package:flutter/material.dart';
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
  final RFIDService _rfidService = RFIDService();
  final TextEditingController _searchController = TextEditingController();

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
          ],
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