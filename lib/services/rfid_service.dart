//------------------------------------------------- RFIDService --------------------------------------------------//
import 'package:flutter/services.dart';

//------------------------------------------------- Class Definition --------------------------------------------------//
class RFIDService {
  //------------------------------------------------- Channel --------------------------------------------------//
  static const MethodChannel _channel = MethodChannel('rfid_plugin');

  //------------------------------------------------- Distance Update Callback --------------------------------------------------//
  Function(double)? _onDistanceUpdate;

  //------------------------------------------------- Set Power --------------------------------------------------//
  Future<bool> setPower(int power) async {
    try {
      final bool result =
          await _channel.invokeMethod('setPower', {'power': power});
      return result;
    } catch (e) {
      print('Error setting power: $e');
      return false;
    }
  }

  //------------------------------------------------- Start Scanning --------------------------------------------------//
  Future<void> startScanning(Function(double) onDistanceUpdate) async {
    _onDistanceUpdate = onDistanceUpdate;

    try {
      await _channel.invokeMethod('startInventoryTag');
      _listenForUpdates();
    } catch (e) {
      print("Error starting RFID scan: $e");
    }
  }

  //------------------------------------------------- Stop Scanning --------------------------------------------------//
  Future<void> stopScanning() async {
    try {
      await _channel.invokeMethod('stopInventory');
    } catch (e) {
      print("Error stopping RFID scan: $e");
    }
  }

  //------------------------------------------------- Listen For Updates --------------------------------------------------//
  void _listenForUpdates() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onTagRead") {
        double distance = call.arguments as double;
        _onDistanceUpdate?.call(distance);
      }
    });
  }

  //------------------------------------------------- Set Inventory Callback --------------------------------------------------//
  Future<void> setInventoryCallback(Function callback) async {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "onTagRead") {
        callback(call.arguments);
      }
    });
  }

  //------------------------------------------------- Get ANT --------------------------------------------------//
  Future<List<int>> getANT() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getANT');
      return result.cast<int>();
    } catch (e) {
      print("Error getting ANT: $e");
      return [];
    }
  }

  //------------------------------------------------- Set ANT --------------------------------------------------//
  Future<void> setANT(List<int> antValues) async {
    try {
      await _channel.invokeMethod('setANT', {'values': antValues});
    } catch (e) {
      print("Error setting ANT: $e");
    }
  }
}
