package com.example.testing_aar_file;

import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.exception.ConfigurationException;
import com.rscja.deviceapi.interfaces.IUHFInventoryCallback;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "rfid_plugin";
    private RFIDWithUHFUART rfid;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "initRFID":
                            try {
                                rfid = RFIDWithUHFUART.getInstance(); // can throw ConfigurationException
                                boolean isConnected = rfid.init(this);
                                if (isConnected) {
                                    showToast("RFID device connected successfully");
                                } else {
                                    showToast("Failed to connect to RFID device");
                                }
                                result.success(isConnected);
                            } catch (ConfigurationException e) {
                                e.printStackTrace();
                                showToast("ConfigurationException: Failed to get RFID instance");
                                result.success(false);
                            }
                            break;

                        case "startInventory":
                            if (rfid != null) {
                                rfid.setInventoryCallback(new IUHFInventoryCallback() {
                                    @Override
                                    public void callback(UHFTAGInfo tagInfo) {
                                        String epc = tagInfo.getEPC();
                                        String rssi = tagInfo.getRssi();
                                        System.out.println("EPC: " + epc + ", RSSI: " + rssi);
                                    }
                                });
                                boolean started = rfid.startInventoryTag();
                                if (started) {
                                    showToast("Started inventory scan");
                                } else {
                                    showToast("Failed to start inventory");
                                }
                                result.success(started);
                            } else {
                                showToast("RFID not initialized");
                                result.success(false);
                            }
                            break;

                        case "stopInventory":
                            if (rfid != null) {
                                rfid.stopInventory();
                                showToast("Stopped inventory");
                            }
                            result.success(null);
                            break;

                        case "releaseRFID":
                            if (rfid != null) {
                                rfid.stopInventory();
                                rfid.free();
                                showToast("RFID device disconnected");
                            }
                            result.success(null);
                            break;

                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }

    private void showToast(String msg) {
        Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_SHORT).show();
    }
}
