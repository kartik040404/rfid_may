import 'package:flutter/services.dart';

class RFIDPlugin {
  static const MethodChannel _channel = MethodChannel('rfid_plugin');

  static Future<bool> initRFID() async {
    return await _channel.invokeMethod('initRFID');
  }

  static Future<void> startInventory() async {
    return await _channel.invokeMethod('startInventory');
  }

  static Future<void> stopInventory() async {
    return await _channel.invokeMethod('stopInventory');
  }

  static Future<void> releaseRFID() async {
    return await _channel.invokeMethod('releaseRFID');
  }
}
