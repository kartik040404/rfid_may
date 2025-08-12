package com.example.testing_aar_file;

import static android.content.Context.AUDIO_SERVICE;

import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Handler;
import android.os.Looper;
import android.view.KeyEvent;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.exception.ConfigurationException;
import com.rscja.deviceapi.interfaces.IUHFInventoryCallback;

import java.util.HashMap;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String METHOD_CHANNEL = "rfid_plugin";
    private static final String EVENT_CHANNEL = "rfid_epc_stream";

    private RFIDWithUHFUART rfid;
    private EventChannel.EventSink epcSink;
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    // For invoking plugin calls from onKeyDown
    private MethodChannel methodChannel;

    // Sound
    private SoundPool soundPool;
    private HashMap<Integer, Integer> soundMap = new HashMap<>();
    private AudioManager audioManager;
    private float volumeRatio;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // Keep a field reference so we can call it from onKeyDown
        methodChannel = new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                METHOD_CHANNEL
        );
        methodChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "initRFID":
                    try {
                        rfid = RFIDWithUHFUART.getInstance();
                        boolean isConnected = rfid.init(this);
                        showToast(isConnected ? "RFID connected" : "RFID connection failed");
                        if (isConnected) initSound();
                        result.success(isConnected);
                    } catch (ConfigurationException e) {
                        e.printStackTrace();
                        showToast("ConfigurationException");
                        result.success(false);
                    }
                    break;

                case "startInventory":
                    if (rfid != null) {
                        rfid.setInventoryCallback(new IUHFInventoryCallback() {
                            @Override
                            public void callback(UHFTAGInfo tagInfo) {
                                String epc = tagInfo.getEPC();
                                if (epcSink != null) {
                                    mainHandler.post(() -> {
                                        epcSink.success(epc);
                                        playSound(1);
                                    });
                                }
                            }
                        });
                        boolean started = rfid.startInventoryTag();
                        showToast(started ? "Inventory started" : "Start failed");
                        result.success(started);
                    } else {
                        showToast("RFID not initialized");
                        result.success(false);
                    }
                    break;

                case "stopInventory":
                    if (rfid != null) {
                        rfid.stopInventory();
                        showToast("Inventory stopped");
                    }
                    result.success(null);
                    break;

                case "releaseRFID":
                    if (rfid != null) {
                        rfid.stopInventory();
                        rfid.free();
                        releaseSoundPool();
                        showToast("RFID released");
                    }
                    result.success(null);
                    break;

                case "setPower":
                    int power = call.argument("power");
                    boolean powerResult = rfid.setPower(power);
                    result.success(powerResult);
                    break;

                case "getPower":
                    if (rfid != null) {
                        result.success(rfid.getPower());
                    } else {
                        result.success(-1);
                    }
                    break;

                case "readSingleTag":
                    if (rfid != null) {
                        UHFTAGInfo tagInfo = rfid.inventorySingleTag();
                        if (tagInfo != null) {
                            result.success(tagInfo.getEPC());
                            playSound(1);
                        } else {
                            result.success(null);
                        }
                    } else {
                        result.success(null);
                    }
                    break;

                case "startSearchForTags":
                    List<String> epcs = call.argument("epcs");
                    if (rfid != null && epcs != null && !epcs.isEmpty()) {
                        rfid.setInventoryCallback(tagInfo -> {
                            String scannedEpc = tagInfo.getEPC();
                            if (epcSink != null && scannedEpc != null) {
                                for (String target : epcs) {
                                    if (scannedEpc.equalsIgnoreCase(target)) {
                                        mainHandler.post(() -> {
                                            epcSink.success(scannedEpc);
                                            playSound(1);
                                        });
                                        break;
                                    }
                                }
                            }
                        });
                        boolean started = rfid.startInventoryTag();
                        result.success(started);
                    } else {
                        result.success(false);
                    }
                    break;

                case "stopSearchForTag":
                    if (rfid != null) {
                        rfid.stopInventory();
                    }
                    result.success(null);
                    break;

                default:
                    result.notImplemented();
                    break;
            }
        });

        new EventChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                EVENT_CHANNEL
        ).setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                epcSink = events;
            }

            @Override
            public void onCancel(Object arguments) {
                epcSink = null;
            }
        });
    }

    // === Capture physical scan button as a toggle ===
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        // Same scan-key codes used in the demo
        if (keyCode == 139 || keyCode == 280 || keyCode == 291 ||
                keyCode == 293 || keyCode == 294 ||
                keyCode == 311 || keyCode == 312 ||
                keyCode == 313 || keyCode == 315) {

            if (event.getRepeatCount() == 0) {
                mainHandler.post(() -> {
                    // Tell Dart to toggle scanning on/off
                    methodChannel.invokeMethod("toggleScan", null);
                });
            }
            return true;  // consume so Flutter UI doesn’t intercept it
        }
        return super.onKeyDown(keyCode, event);
    }

    // === Toast helper ===
    private void showToast(String msg) {
        Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_SHORT).show();
    }

    // === Sound helpers ===
    private void initSound() {
        soundPool = new SoundPool(5, AudioManager.STREAM_MUSIC, 0);
        soundMap.put(1, soundPool.load(this, R.raw.barcodebeep, 1));
        audioManager = (AudioManager) getSystemService(AUDIO_SERVICE);
    }

    private void playSound(int soundId) {
        if (soundPool != null && soundMap.containsKey(soundId)) {
            float maxVol = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            float curVol = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
            volumeRatio = curVol / maxVol;
            soundPool.play(soundMap.get(soundId), volumeRatio, volumeRatio, 1, 0, 1f);
        }
    }

    private void releaseSoundPool() {
        if (soundPool != null) {
            soundPool.release();
            soundPool = null;
        }
    }
}
