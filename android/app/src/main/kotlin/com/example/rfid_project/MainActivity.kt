package com.example.rfid_project

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
    private val CHANNEL = "rfid_plugin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startInventoryTag" -> {
                    startInventoryTag()
                    result.success(null)
                }
                "stopInventory" -> {
                    stopInventory()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startInventoryTag() {
        Log.d("RFID", "RFID Scanning Started")
    }

    private fun stopInventory() {
        Log.d("RFID", "RFID Scanning Stopped")
    }
}
