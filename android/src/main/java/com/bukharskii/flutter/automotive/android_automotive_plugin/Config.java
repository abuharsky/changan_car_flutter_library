package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.content.Context;
import android.content.SharedPreferences;

public class Config {
    final SharedPreferences pref;

    public Config(Context context) {
        this.pref = context.getSharedPreferences("id.flutter.accessibility_background_service_android", Context.MODE_PRIVATE);
    }


    public long getBackgroundHandle() {
        return pref.getLong("background_handle", 0);
    }

    public void setBackgroundHandle(long value) {
        pref.edit().putLong("background_handle", value).apply();
    }

}
