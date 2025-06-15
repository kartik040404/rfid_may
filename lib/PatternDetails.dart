import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PatternDetails extends StatefulWidget {
  @override
  _PatternDetailsState createState() => _PatternDetailsState();
}

class _PatternDetailsState extends State<PatternDetails> {
  List<dynamic> patternList = [];
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    fetchPatternDetails();
  }

  Future<void> fetchPatternDetails() async {
    final response = await http.get(Uri.parse('http://10.10.1.7:8301/api/productionappservices/getpatterndetailslist'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        patternList = data;
        expanded = List.generate(data.length, (index) => false);
      });
    } else {
      print("Failed to load pattern data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pattern Details')),
      body: patternList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: patternList.length,
        itemBuilder: (context, index) {
          final item = patternList[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                setState(() {
                  expanded[index] = !expanded[index];
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['PatternName'] ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Code: ${item['PatternCode']}"),
                    Text("Supplier: ${item['SupplierName']}"),
                    if (expanded[index]) ...[
                      SizedBox(height: 10),
                      Text("Tool Life Start: ${item['ToolLifeStartDate']}"),
                      Text("Invoice No: ${item['InvoiceNo']}"),
                      Text("Invoice Date: ${item['InvoiceDate']}"),
                      Text("Number of Parts: ${item['NumberOfParts']}"),
                      Text("Parts Produced: ${item['PartsProduced']}"),
                      Text("Remaining: ${item['RemainingBalance']}"),
                      Text("Signal: ${item['Signal']}"),
                      Text("Last Produced: ${item['LastPrdDate']}"),
                      Text("Asset Name: ${item['AssetName']}"),
                    ]
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
