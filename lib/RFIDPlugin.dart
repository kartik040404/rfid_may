import 'package:flutter/services.dart';

class RFIDPlugin {
  static const MethodChannel _channel = MethodChannel('rfid_plugin');
  static const EventChannel _eventChannel = EventChannel('rfid_epc_stream');

 static Future<bool> setPower(int power) async {
    try {
      final bool result = await _channel.invokeMethod('setPower', {'power': power});
      return result;
    } catch (e) {
      print('Error setting power: $e');
      return false;
    }
  }

  static Future<bool> initRFID() async {
    return await _channel.invokeMethod('initRFID');
  }

  static Future<bool> startInventory(Function(String epc) onEpcRead) async {
    _eventChannel.receiveBroadcastStream().listen((dynamic epc) {
      if (epc is String) {
        onEpcRead(epc);
      }
    });

    return await _channel.invokeMethod('startInventory');
  }

  static Future<void> stopInventory() async {
    return await _channel.invokeMethod('stopInventory');
  }

  static Future<void> releaseRFID() async {
    return await _channel.invokeMethod('releaseRFID');
  }
}