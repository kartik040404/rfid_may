import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';

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
    SizeConfig.init(context);
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
            padding: EdgeInsets.all(isWide ? SizeConfig.blockSizeHorizontal * 6 : SizeConfig.blockSizeHorizontal * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Attach RFID Tag",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.textMultiplier * 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 2),
                Text(
                  "Status: $status",
                  style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.7,
                    fontWeight: FontWeight.w500,
                    color: status.contains('Failed') || status.contains('Maximum') || status.contains('already added') ? Colors.red.shade700 : primaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 1.2),
                if (rfidTags.isNotEmpty) ...[
                  Text(
                    "Scanned RFID Tag:",
                    style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor, fontSize: SizeConfig.textMultiplier * 1.5),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 0.8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical, horizontal: SizeConfig.blockSizeHorizontal * 2),
                    decoration: BoxDecoration(
                      color: primaryColorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            rfidTags[0],
                            style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.6, fontWeight: FontWeight.w500),
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
                  SizedBox(height: SizeConfig.blockSizeVertical * 1.2),
                ],
                if (rfidTags.isEmpty) ...[
                  ElevatedButton.icon(
                    icon: isScanning
                        ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Icon(Icons.nfc, color: Colors.white),
                    label: Text(isScanning ? 'Scanning...' : 'Scan RFID Tag'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.4),
                      textStyle: TextStyle(fontSize: SizeConfig.textMultiplier * 1.6, fontWeight: FontWeight.bold),
                    ),
                    onPressed: isScanning ? null : () => onStartInventory(),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 1.2),
                ],
                if (isScanning && rfidTags.isEmpty) ...[
                  OutlinedButton.icon(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    label: const Text('Stop Scanning'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade700),
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.2),
                    ),
                    onPressed: () => onStopInventory(),
                  ),
                ],
                SizedBox(height: SizeConfig.blockSizeVertical * 8),
                Text(
                  "Only one RFID tag can be attached.",
                  style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.4, color: Colors.grey.shade700),
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
