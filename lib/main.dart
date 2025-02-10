import 'package:flutter/material.dart';
import 'homeScreen.dart';

void main() {
  runApp(const RFIDApp());
}

class RFIDApp extends StatelessWidget {
  const RFIDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RFID Scanner',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}