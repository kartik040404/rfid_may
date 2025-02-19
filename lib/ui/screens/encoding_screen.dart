import 'package:flutter/material.dart';

class EncodingScreen extends StatefulWidget {
  @override
  _EncodingScreenState createState() => _EncodingScreenState();
}

class _EncodingScreenState extends State<EncodingScreen> {
  String patternName = '';
  String patternDescription = '';
  String rfidTagUid = '';
  bool isTagScanned = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pattern Registration"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Pattern Name
            Text("Pattern Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  patternName = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Pattern Name',
              ),
            ),
            SizedBox(height: 20),

            // Pattern Description
            Text("Pattern Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                setState(() {
                  patternDescription = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Pattern Description',
              ),
            ),
            SizedBox(height: 20),

            // UID from RFID Scanner
            Text("UID from RFID Scanner", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  rfidTagUid = 'TAG123'; // This simulates the scanner reading a tag
                  isTagScanned = true;
                });
              },
              child: Text('Scan RFID'),
            ),
            SizedBox(height: 8),
            if (isTagScanned)
              Text("UID Scanned: $rfidTagUid", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Save Pattern
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Here we would normally call a function to save the pattern to the database
                  isSaved = true;
                });
              },
              child: Text('Save Pattern'),
            ),
            SizedBox(height: 8),
            if (isSaved)
              Text("Pattern successfully saved to the database.", style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}