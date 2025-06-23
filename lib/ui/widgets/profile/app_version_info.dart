import 'package:flutter/material.dart';

class AppVersionInfo extends StatelessWidget {
  const AppVersionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'v1.0.0 | Zanvar Group © 2025',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontFamily: 'Poppins',
      ),
    );
  }
}
