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
    final media = MediaQuery.of(context);
    final isWide = media.size.width > 600;
    Color primaryColor = Colors.red.shade700;
    Color primaryColorLight = Colors.red.shade100;

    return Center(
      child: SizedBox(
        width: isWide ? 500 : double.infinity,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(isWide ? 32.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Attach RFID Tag",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: status.contains('Failed') || status.contains('Maximum') || status.contains('already added') ? Colors.red.shade700 : primaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                if (rfidTags.isNotEmpty) ...[
                  Text(
                    "Scanned RFID Tag:",
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    decoration: BoxDecoration(
                      color: primaryColorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            rfidTags[0],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade700),
                          onPressed: () => onRemoveRfidTag(0),
                          tooltip: 'Remove',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (rfidTags.isEmpty) ...[
                  ElevatedButton.icon(
                    icon: isScanning
                        ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(Icons.nfc, color: Colors.white),
                    label: Text(isScanning ? 'Scanning...' : 'Scan RFID Tag'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isScanning ? null : () => onStartInventory(),
                  ),
                  const SizedBox(height: 10),
                ],
                if (isScanning && rfidTags.isEmpty) ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    label: const Text('Stop Scanning'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade700),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => onStopInventory(),
                  ),
                ],
SizedBox(height: 100,),
                Text(
                  "Only one RFID tag can be attached.",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
