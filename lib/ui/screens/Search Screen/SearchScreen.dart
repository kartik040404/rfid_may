import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SearchScreen(),
    theme: ThemeData(primarySwatch: Colors.indigo),
  ));
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> _filters = ['Type', 'AssetID', 'Name', 'RFID Tag'];
  String? _selectedFilter; // 🔸 Start as null, so no default
  String _searchText = '';
  List<Map<String, String>> _searchResults = [];
  bool _isLoading = false;

  // Simulated API call (replace with your actual logic)
  Future<List<Map<String, String>>> fetchItemsByFilter(
      String filterType, String searchValue) async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate API delay

    final List<Map<String, String>> allItems = [
      {'Type': 'Laptop', 'AssetID': 'A123', 'Name': 'Dell XPS', 'RFID Tag': 'RF1001'},
      {'Type': 'Phone', 'AssetID': 'A124', 'Name': 'iPhone 13', 'RFID Tag': 'RF1002'},
      {'Type': 'Tablet', 'AssetID': 'A125', 'Name': 'iPad Air', 'RFID Tag': 'RF1003'},
    ];

    return allItems.where((item) {
      final value = item[filterType]?.toLowerCase() ?? '';
      return value.contains(searchValue.toLowerCase());
    }).toList();
  }

  void _onSearchChanged(String value) async {
    _searchText = value;

    if (_selectedFilter == null || _searchText.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);

    final results = await fetchItemsByFilter(_selectedFilter!, _searchText);

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  Widget _buildResultCard(Map<String, String> item) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item['Name'] ?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
          SizedBox(height: 8),
          Text('Type: ${item['Type']}'),
          Text('AssetID: ${item['AssetID']}'),
          Text('RFID Tag: ${item['RFID Tag']}'),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          // 🔸 Filter Dropdown
          DropdownButtonFormField<String>(
            value: _selectedFilter,
            hint: Text("Select Filter"),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Filter By',
            ),
            items: _filters.map((filter) {
              return DropdownMenuItem(value: filter, child: Text(filter));
            }).toList(),
            onChanged: (newFilter) {
              setState(() {
                _selectedFilter = newFilter;
              });
              if (_searchText.isNotEmpty) {
                _onSearchChanged(_searchText);
              }
            },
          ),
          SizedBox(height: 16),
          // 🔍 Search Input
          TextField(
            decoration: InputDecoration(
              labelText: 'Search...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: 20),
          // 🔽 Results
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty
                ? Center(child: Text('No results found.'))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) =>
                  _buildResultCard(_searchResults[index]),
            ),
          ),
        ]),
      ),
    );
  }
}
