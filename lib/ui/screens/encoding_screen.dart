import 'package:flutter/material.dart';

class EncodingScreen extends StatefulWidget {
  @override
  _EncodingScreenState createState() => _EncodingScreenState();
}

class _EncodingScreenState extends State<EncodingScreen> {
  // List of patterns for the dropdown menu
  List<String> patterns = ['Mould Pattern A', 'Mould Pattern B', 'Mould Pattern C'];
  String? selectedPattern;
  String rfidTagUid = '';
  bool isTagScanned = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RFID Encoding System"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Step 1: Select Pattern
            Text("Step 1: Select the Pattern", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedPattern,
              hint: Text('Select Pattern'),
              items: patterns.map((String pattern) {
                return DropdownMenuItem<String>(
                  value: pattern,
                  child: Text(pattern),
                );
              }).toList(),
              onChanged: (newPattern) {
                setState(() {
                  selectedPattern = newPattern;
                  isTagScanned = false;
                  isSaved = false;
                  rfidTagUid = ''; // Reset UID after selecting a new pattern
                });
              },
            ),
            SizedBox(height: 20),

            // Step 2: Attach RFID Tag (Instruction)
            Text("Step 2: Attach the RFID Tag", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Physically attach the RFID tag to the selected pattern.", style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),

            // Step 3: Write Unique ID to Tag
            Text("Step 3: Write a Unique ID to the Tag", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  rfidTagUid = 'TAG123'; // This simulates the scanner reading a tag
                  isTagScanned = true;
                });
              },
              child: Text('Scan RFID Tag'),
            ),
            SizedBox(height: 8),
            if (isTagScanned)
              Text("UID Scanned: $rfidTagUid", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            // Step 4: Save the Link in the Database
            Text("Step 4: Save the Link in the Database", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Here we would normally call a function to save the link to the database
                  isSaved = true;
                });
              },
              child: Text('Save Link to Database'),
            ),
            SizedBox(height: 8),
            if (isSaved)
              Text("Link successfully saved to the database.", style: TextStyle(fontSize: 14, color: Colors.green)),
            SizedBox(height: 20),

            // Step 5: Scanning the Tag to View Info
            Text("Step 5: Scan the RFID Tag Later", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Simulate fetching data from the database
                  if (rfidTagUid.isNotEmpty) {
                    // Display some info related to the scanned UID
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Pattern Info'),
                        content: Text('Pattern: $selectedPattern\nUID: $rfidTagUid\nMould Information: XYZ details...'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
              child: Text('Scan RFID Tag to View Info'),
            ),
            SizedBox(height: 20),

            // Summary Section
            Text(
              "Summary: The RFID tag stores only a unique ID. All detailed information is saved in the database.",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}