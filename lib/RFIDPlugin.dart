// lib/RFIDPlugin.dart

import 'package:flutter/services.dart';

class RFIDPlugin {
  static const MethodChannel _channel = MethodChannel('rfid_plugin');
  static const EventChannel _eventChannel = EventChannel('rfid_epc_stream');

  // User-supplied toggleScan callback
  static VoidCallback? _onToggleScan;

  // Internal: ensure we only register the handler once
  static bool _handlerRegistered = false;
  static void _ensureHandler() {
    if (_handlerRegistered) return;
    _handlerRegistered = true;

    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'toggleScan':
          if (_onToggleScan != null) {
            _onToggleScan!();
          }
          break;
      // you could handle more incoming calls here
      }
      return null;
    });
  }

  /// Call this in your screen’s initState:
  /// RFIDPlugin.setToggleScanHandler(() { /* start/stop scan */ });
  static void setToggleScanHandler(VoidCallback onToggle) {
    _ensureHandler();
    _onToggleScan = onToggle;
  }

  static Future<String?> readSingleTag() async {
    _ensureHandler();
    try {
      final String? epc = await _channel.invokeMethod<String>('readSingleTag');
      return epc;
    } catch (e) {
      print('Error reading single tag: $e');
      return null;
    }
  }

  static Future<bool> setPower(int power) async {
    _ensureHandler();
    try {
      final bool result = await _channel.invokeMethod('setPower', {'power': power});
      return result;
    } catch (e) {
      print('Error setting power: $e');
      return false;
    }
  }

  static Future<int> getPower() async {
    _ensureHandler();
    try {
      final int power = await _channel.invokeMethod('getPower');
      return power;
    } catch (e) {
      print('Error getting power: $e');
      return -1;
    }
  }

  static Future<bool> initRFID() async {
    _ensureHandler();
    try {
      return await _channel.invokeMethod<bool>('initRFID') ?? false;
    } catch (e) {
      print('Error initRFID: $e');
      return false;
    }
  }

  static Future<bool> startInventory(Function(String epc) onEpcRead) async {
    _ensureHandler();
    _eventChannel.receiveBroadcastStream().listen((dynamic epc) {
      if (epc is String) {
        onEpcRead(epc);
      }
    });
    try {
      final bool started = await _channel.invokeMethod('startInventory');
      return started;
    } catch (e) {
      print('Error startInventory: $e');
      return false;
    }
  }

  static Future<void> stopInventory() async {
    _ensureHandler();
    try {
      await _channel.invokeMethod('stopInventory');
    } catch (e) {
      print('Error stopInventory: $e');
    }
  }

  static Future<void> releaseRFID() async {
    _ensureHandler();
    try {
      await _channel.invokeMethod('releaseRFID');
    } catch (e) {
      print('Error releaseRFID: $e');
    }
  }

  static Future<bool> startMultiSearchTags(
      List<String> epcs, Function(String epc) onTagFound) async {
    _ensureHandler();
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
    _ensureHandler();
    try {
      await _channel.invokeMethod('stopSearchForTag');
    } catch (e) {
      print('Error stopping search: $e');
    }
  }
}
