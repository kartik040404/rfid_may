import 'package:flutter/material.dart';
import 'custom_button.dart';

class ScanButton extends StatelessWidget {
  final bool isScanning;
  final VoidCallback onStartScan;
  final VoidCallback onStopScan;
  final FocusNode focusNode;
  final TextEditingController controller;

  const ScanButton({
    Key? key,
    required this.isScanning,
    required this.onStartScan,
    required this.onStopScan,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: isScanning ? 'Stop Scan' : 'Start Scan',
      icon: isScanning ? Icons.stop : Icons.play_arrow,
      color: isScanning ? Colors.red : Color(0xFF1E1E1E),
      onPressed: () {
        focusNode.unfocus(); // Unfocus the search field

        if (isScanning) {
          onStopScan();
        } else {
          onStartScan();
        }
      },
    );
  }
}