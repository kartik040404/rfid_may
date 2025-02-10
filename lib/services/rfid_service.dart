import 'package:flutter/services.dart';

class RFIDService {
  static const MethodChannel _channel = MethodChannel('rfid_plugin');

  Function(double)? _onDistanceUpdate;

  /// Starts RFID scanning and listens for distance updates
  Future<void> startScanning(Function(double) onDistanceUpdate) async {
    _onDistanceUpdate = onDistanceUpdate;

    try {
      await _channel.invokeMethod('startInventoryTag');
      _listenForUpdates();
    } catch (e) {
      print("Error starting RFID scan: $e");
    }
  }

  /// Stops RFID scanning
  Future<void> stopScanning() async {
    try {
      await _channel.invokeMethod('stopInventory');
    } catch (e) {
      print("Error stopping RFID scan: $e");
    }
  }

  /// Listens for RFID scan updates (e.g., distance changes)
  void _listenForUpdates() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onTagRead") {
        double distance = call.arguments as double;
        _onDistanceUpdate?.call(distance);
      }
    });
  }

  /// Sets a custom inventory callback for handling tag reads
  Future<void> setInventoryCallback(Function callback) async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onTagRead") {
        callback(call.arguments);
      }
    });
  }

  /// Retrieves the current ANT settings
  Future<List<int>> getANT() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getANT');
      return result.cast<int>();
    } catch (e) {
      print("Error getting ANT: $e");
      return [];
    }
  }

  /// Sets new ANT values
  Future<void> setANT(List<int> antValues) async {
    try {
      await _channel.invokeMethod('setANT', {'values': antValues});
    } catch (e) {
      print("Error setting ANT: $e");
    }
  }
}
