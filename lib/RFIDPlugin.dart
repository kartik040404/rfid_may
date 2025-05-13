import 'package:flutter/services.dart';

class RFIDPlugin {
  static const MethodChannel _channel = MethodChannel('rfid_plugin');
  static const EventChannel _eventChannel = EventChannel('rfid_epc_stream');

  static Future<String?> readSingleTag() async {
    try {
      final String? epc = await _channel.invokeMethod<String>('readSingleTag');
      return epc;
    } catch (e) {
      print('Error reading single tag: $e');
      return null;
    }
  }

  static Future<bool> setPower(int power) async {
    try {
      final bool result = await _channel.invokeMethod('setPower', {'power': power});
      return result;
    } catch (e) {
      print('Error setting power: $e');
      return false;
    }
  }
  static Future<int> getPower() async {
    try {
      final int power = await _channel.invokeMethod('getPower');
      return power;
    } catch (e) {
      print('Error getting power: $e');
      return -1;
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

  static Future<bool> startMultiSearchTags(
      List<String> epcs, Function(String epc) onTagFound) async {
    _eventChannel.receiveBroadcastStream().listen((dynamic scannedEpc) {
      if (scannedEpc is String &&
          epcs.any((epc) => epc.toLowerCase() == scannedEpc.toLowerCase())) {
        onTagFound(scannedEpc);
      }
    });

    try {
      final bool started = await _channel.invokeMethod('startSearchForTags', {
        'epcs': epcs,
      });
      return started;
    } catch (e) {
      print('Error starting multi-tag search: $e');
      return false;
    }
  }

  static Future<void> stopSearchTag() async {
    try {
      await _channel.invokeMethod('stopSearchForTag');
    } catch (e) {
      print('Error stopping search: $e');
    }
  }


}