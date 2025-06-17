import 'package:flutter/material.dart';

class RfidAttachmentStepWidget extends StatelessWidget {
  final String status;
  final List<String> rfidTags;
  final bool isScanning;
  final Function onStartInventory;
  final Function onStopInventory;
  final Function(int) onRemoveRfidTag;

  const RfidAttachmentStepWidget({
    super.key,
    required this.status,
    required this.rfidTags,
    required this.isScanning,
    required this.onStartInventory,
    required this.onStopInventory,
    required this.onRemoveRfidTag,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.red.shade700;
    Color primaryColorLight = Colors.red.shade100;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Attach RFID Tags (1-3)",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Status: $status",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: status.contains('Failed') || status.contains('Maximum') || status.contains('already added') ? Colors.red.shade700 : primaryColor,
              ),
            ),
            const SizedBox(height: 10),
            if (rfidTags.isNotEmpty) ...[
              Text(
                "Scanned RFID Tags:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: rfidTags.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 1,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: primaryColorLight,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(rfidTags[index], style: const TextStyle(fontSize: 15)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                          onPressed: () => onRemoveRfidTag(index),
                          tooltip: 'Remove Tag',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Divider(height: 20),
            ],
            if (rfidTags.isEmpty && !isScanning)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_outlined, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        "No RFID tags scanned yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Click below to start scanning.",
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ),
              ) else if (rfidTags.isEmpty && isScanning)
                 Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: primaryColor),
                        const SizedBox(height: 20),
                        Text(status, style: TextStyle(fontSize: 16, color: primaryColor)),
                      ],
                    )
                  )
                 ),

            const SizedBox(height: 10),
            Text(
              rfidTags.length < 3 ? "${3 - rfidTags.length} more tag(s) can be added." : "Maximum tags added.",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                disabledBackgroundColor: Colors.grey.shade300,
              ),
              onPressed: rfidTags.length < 3 && !isScanning ? () => onStartInventory() : null,
              icon: isScanning
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.qr_code_scanner),
              label: Text(isScanning ? "Scanning..." : "Scan RFID Tag"),
            ),
            if (isScanning)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
                  onPressed: () => onStopInventory(),
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text("Stop Scanning"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
