import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SearchPatternScreen()));
}

class SearchPatternScreen extends StatefulWidget {
  @override
  _SearchPatternScreenState createState() => _SearchPatternScreenState();
}

class _SearchPatternScreenState extends State<SearchPatternScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> patterns = [
    {
      "SupplierName": "S J IRON AND STEELS PVT LTD",
      "PatternCode": "1010602615",
      "PatternName": "PATTERN FOR 3L BED PLATE 5706 0110 3702/398534010000 (S)",
    },
    {
      "SupplierName": "RAJ PATTERN WORKS",
      "PatternCode": "1010602616",
      "PatternName": "PATTERN FOR 4L GEAR BOX HOUSING 5706 0110 3703/398534010001 (M)",
    },
    {
      "SupplierName": "SHREE MOULD TECH",
      "PatternCode": "1010602617",
      "PatternName": "PATTERN FOR 2L ENGINE COVER 5706 0110 3704/398534010002 (L)",
    },
    {
      "SupplierName": "INDUS CAST",
      "PatternCode": "1010602618",
      "PatternName": "PATTERN FOR CRANK CASE 5706 0110 3705/398534010003 (XL)",
    },
  ];

  List<Map<String, dynamic>> filteredList = [];

  void _filterResults(String query) {
    final results = patterns.where((pattern) =>
    pattern['PatternCode'].toString().contains(query) ||
        pattern['PatternName'].toLowerCase().contains(query.toLowerCase())).toList();

    setState(() {
      filteredList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Patterns')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search by Pattern Code or Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterResults,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final pattern = filteredList[index];
                  return ListTile(
                    title: Text(pattern['PatternName']),
                    subtitle: Text('Code: ${pattern['PatternCode']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PatternDetails(pattern: pattern),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatternDetails extends StatelessWidget {
  final Map<String, dynamic> pattern;

  const PatternDetails({required this.pattern});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pattern Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Supplier Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(pattern['SupplierName']),
                SizedBox(height: 10),
                Text('Pattern Code:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(pattern['PatternCode']),
                SizedBox(height: 10),
                Text('Pattern Name:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(pattern['PatternName']),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
