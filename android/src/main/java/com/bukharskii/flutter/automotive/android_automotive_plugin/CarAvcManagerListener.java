package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.car.hardware.CarPropertyValue;
import android.car.hardware.CarSensorEvent;

public interface CarAvcManagerListener {
    void onHvacChangeEvent(CarPropertyValue carPropertyValue);

    void onCarSensorEvent(CarSensorEvent carSensorEvent);

    void onCarClusterInteractionEvent(String value);

    void onCarVendorExtensionCallback(CarPropertyValue carPropertyValue);

    void onLogEvent(String logEvent);
}
