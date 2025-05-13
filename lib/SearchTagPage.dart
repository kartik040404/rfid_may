import 'package:flutter/material.dart';
import '../../RFIDPlugin.dart';

class SearchTagPage extends StatefulWidget {
  const SearchTagPage({super.key});

  @override
  State<SearchTagPage> createState() => _SearchTagPageState();
}

class _SearchTagPageState extends State<SearchTagPage> {
  final TextEditingController _epcController = TextEditingController();
  String status = 'Enter EPC to search';
  bool isSearching = false;

  double signalStrength = 0.0;

  void startSearch() async {
    final epc = _epcController.text.trim();
    if (epc.isEmpty) {
      setState(() {
        status = 'EPC cannot be empty';
      });
      return;
    }

    setState(() {
      isSearching = true;
      status = 'Searching for $epc...';
    });

    final started = await RFIDPlugin.startSearchTag(epc, (matchedEpc) {
      setState(() {
        status = 'Tag Found: $matchedEpc';
        signalStrength = 1.0;
      });
    });

    if (!started) {
      setState(() {
        isSearching = false;
        status = 'Failed to start search';
      });
    }
  }

  void stopSearch() async {
    await RFIDPlugin.stopSearchTag();
    setState(() {
      isSearching = false;
      status = 'Search stopped';
      signalStrength = 0.0;
    });
  }

  @override
  void dispose() {
    _epcController.dispose();
    stopSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search RFID Tag")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _epcController,
              decoration: const InputDecoration(
                labelText: "Enter EPC",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSearching ? stopSearch : startSearch,
              child: Text(isSearching ? "Stop Search" : "Start Search"),
            ),
            const SizedBox(height: 20),
            Text(status),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: signalStrength,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
            ),
            const SizedBox(height: 10),
            const Text("Signal Strength Indicator"),
          ],
        ),
      ),
    );
  }
}
