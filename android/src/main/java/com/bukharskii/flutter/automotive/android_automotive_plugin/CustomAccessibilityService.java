package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.accessibilityservice.AccessibilityService;
import android.annotation.SuppressLint;
import android.content.ComponentName;
import android.content.Intent;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CustomAccessibilityService extends AccessibilityService implements MethodChannel.MethodCallHandler {
    private static final String TAG = "CustomAccessibilityService";

    private FlutterEngine backgroundEngine;
    private MethodChannel methodChannel;
    private DartExecutor.DartEntrypoint dartEntrypoint;

    private Config config;

    AtomicBoolean isRunning = new AtomicBoolean(false);

    private CurrentMetadataManagerService currentMetadataManagerService;

    @SuppressLint("WakelockTimeout")
    private void runService() {


        currentMetadataManagerService = new CurrentMetadataManagerService();
        currentMetadataManagerService.onCreate(this, new ComponentName(this, CustomAccessibilityService.class));

        try {
            if (isRunning.get() || (backgroundEngine != null && !backgroundEngine.getDartExecutor().isExecutingDart())) {
                Log.v(TAG, "CustomAccessibilityService already running, using existing service");
                return;
            }

            Log.v(TAG, "Starting flutter engine for CustomAccessibilityService service");

            FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
            // initialize flutter if it's not initialized yet
            if (!flutterLoader.initialized()) {
                flutterLoader.startInitialization(getApplicationContext());
            }

            flutterLoader.ensureInitializationComplete(getApplicationContext(), null);

            isRunning.set(true);
            backgroundEngine = new FlutterEngine(this);


            config = new Config(getApplicationContext());

            backgroundEngine.getServiceControlSurface().attachToService(CustomAccessibilityService.this, null, false);

            methodChannel = new MethodChannel(backgroundEngine.getDartExecutor().getBinaryMessenger(), "id.flutter/accessibility_background_service_android", JSONMethodCodec.INSTANCE);
            methodChannel.setMethodCallHandler(this);

            dartEntrypoint = new DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), "package:android_automotive_plugin/android_automotive_plugin.dart", "entrypoint");

            final List<String> args = new ArrayList<>();
            long backgroundHandle = config.getBackgroundHandle();
            args.add(String.valueOf(backgroundHandle));


            backgroundEngine.getDartExecutor().executeDartEntrypoint(dartEntrypoint, args);

        } catch (UnsatisfiedLinkError e) {
            Log.w(TAG, "UnsatisfiedLinkError: After a reboot this may happen for a short period and it is ok to ignore then!" + e.getMessage());
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
    }

    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        Log.d(TAG, event.toString());
    }

    @Override
    public void onInterrupt() {
        Log.d(TAG, "onInterrupt");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand: " + startId);
        return START_STICKY;
    }


    @Override
    public void onServiceConnected() {
        Log.d(TAG, "onServiceConnected");
        runService();
    }

}
