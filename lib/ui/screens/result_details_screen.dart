import 'package:flutter/material.dart';

class ResultDetailsScreen extends StatelessWidget {
  final String patternName;
  final String rfidTagId;
  final String description;
  final String lastScannedDate;

  const ResultDetailsScreen({
    Key? key,
    required this.patternName,
    required this.rfidTagId,
    required this.description,
    required this.lastScannedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pattern Name: $patternName',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'RFID Tag ID: $rfidTagId',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: $description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Last Scanned Date: $lastScannedDate',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}