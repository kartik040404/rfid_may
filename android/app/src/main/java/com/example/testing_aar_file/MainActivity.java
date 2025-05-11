package com.example.testing_aar_file;

import static android.content.Context.AUDIO_SERVICE;

import android.media.AudioManager;
import android.media.SoundPool;
import android.os.Handler;
import android.os.Looper;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.rscja.deviceapi.RFIDWithUHFUART;
import com.rscja.deviceapi.entity.UHFTAGInfo;
import com.rscja.deviceapi.exception.ConfigurationException;
import com.rscja.deviceapi.interfaces.IUHFInventoryCallback;

import java.util.HashMap;

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

    // Sound
    private SoundPool soundPool;
    private HashMap<Integer, Integer> soundMap = new HashMap<>();
    private AudioManager audioManager;
    private float volumeRatio;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "initRFID":
                            try {
                                rfid = RFIDWithUHFUART.getInstance();
                                boolean isConnected = rfid.init(this);
                                showToast(isConnected ? "RFID connected" : "RFID connection failed");

                                if (isConnected) {
                                    initSound(); // Initialize sound here
                                }

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
                                                playSound(1); // 🔊 Beep here
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
                                releaseSoundPool(); // Release sound resources
                                showToast("RFID released");
                            }
                            result.success(null);
                            break;
                        case "setPower":
                            int power = call.argument("power");
                            boolean powerResult = rfid.setPower(power);
                            result.success(powerResult);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });

        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
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

    private void showToast(String msg) {
        Toast.makeText(getApplicationContext(), msg, Toast.LENGTH_SHORT).show();
    }

    // ------------------ Sound Methods ------------------

    private void initSound() {
        soundPool = new SoundPool(5, AudioManager.STREAM_MUSIC, 0);
        soundMap.put(1, soundPool.load(this, R.raw.barcodebeep, 1)); // Ensure barcodebeep.wav is in res/raw
        audioManager = (AudioManager) getSystemService(AUDIO_SERVICE);
    }

    private void playSound(int soundId) {
        if (soundPool != null && soundMap.containsKey(soundId)) {
            float maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC);
            float currentVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
            volumeRatio = currentVolume / maxVolume;
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
