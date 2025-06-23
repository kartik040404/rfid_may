import 'package:flutter/material.dart';

class ReviewAndSaveStepWidget extends StatelessWidget {
  final Map<String, String>? selectedPattern;
  final List<String> rfidTags;
  final Function onSavePattern;

  const ReviewAndSaveStepWidget({
    super.key,
    required this.selectedPattern,
    required this.rfidTags,
    required this.onSavePattern,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.red.shade700;
    Color successColor = Colors.green.shade700;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Wrap scrollable content in Expanded
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Review & Save",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold,fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    _buildReviewInfo(
                      context,
                      icon: Icons.style_outlined,
                      title: "Selected Pattern",
                      content: selectedPattern != null
                          ? "${selectedPattern!['name']} (${selectedPattern!['code']})"
                          : "Not selected",
                      iconColor: primaryColor,
                    ),
                    const SizedBox(height: 14),
                    _buildReviewInfo(
                      context,
                      icon: Icons.qr_code_scanner_outlined,
                      title: "RFID Tags (${rfidTags.length})",
                      content: rfidTags.isNotEmpty
                          ? rfidTags.map((t) => "• $t").join('\n')
                          : "No tags attached",
                      iconColor: primaryColor,
                      isMultiline: true,
                    ),
                  ],
                ),
              ),
            ),
            // Remove the Save button from here
            // const SizedBox(height: 16),
            // ElevatedButton.icon(
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: successColor,
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            //     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //   ),
            //   onPressed: () => onSavePattern(),
            //   icon: const Icon(Icons.save_alt_outlined),
            //   label: const Text("Save Pattern"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewInfo(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String content,
        Color? iconColor,
        bool isMultiline = false,
      }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: iconColor ?? Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
