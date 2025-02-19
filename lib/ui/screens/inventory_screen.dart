import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  final List<String> patterns = [
    'Mould Pattern A',
    'Mould Pattern B',
    'Mould Pattern C',
    'Mould Pattern D',
    'Mould Pattern E',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory List'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: patterns.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListTile(
              title: Text(
                patterns[index],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Handle item tap
              },
            ),
          );
        },
      ),
    );
  }
}