package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.content.ComponentName;
import android.content.Context;
import android.media.MediaMetadata;
import android.media.session.MediaController;
import android.media.session.MediaSessionManager;
import android.os.Build;
import android.service.notification.NotificationListenerService;
import android.util.Log;

import androidx.annotation.Nullable;

import java.util.List;

public class CurrentMetadataManagerService  {

    private static String TAG = "CurrentMetadataManagerService";

    private MediaSessionManager mediaSessionManager;
    private ComponentName componentName;
    private MediaController controller;

    MediaSessionManager.OnActiveSessionsChangedListener sessionsChangedListener = new MediaSessionManager.OnActiveSessionsChangedListener() {
        @Override
        public void onActiveSessionsChanged(@Nullable List<MediaController> controllers) {
            Log.d(TAG, "onActiveSessionsChanged: session is changed");
            for (MediaController controller : controllers) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    Log.d(TAG, "onActiveSessionsChanged: controller = " + controller.getPackageName());
                    MediaMetadata meta = controller.getMetadata();
                    Log.d(TAG, "onCreate: artist = " + meta.getString(MediaMetadata.METADATA_KEY_ARTIST));
                    Log.d(TAG, "onCreate: song = " + meta.getString(MediaMetadata.METADATA_KEY_TITLE));
                }
            }
        }
    };

   // @Override
    public void onCreate(Context context, ComponentName componentName) {
       // super.onCreate();
        //componentName = new ComponentName(this, CurrentMetadataManagerService.class);
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {
            mediaSessionManager = (MediaSessionManager) context.getSystemService(Context.MEDIA_SESSION_SERVICE);
            mediaSessionManager.addOnActiveSessionsChangedListener(sessionsChangedListener, componentName);

            List<MediaController> controllers = mediaSessionManager.getActiveSessions(componentName);
            Log.d(TAG, "onCreate listener: controllers size = " + controllers.size());
            for (MediaController mediaController : controllers) {
                controller = mediaController;
                Log.d(TAG, "onCreate: controller = " + controller.getPackageName());
                MediaMetadata meta = controller.getMetadata();
                Log.d(TAG, "onCreate: artist = " + meta.getString(MediaMetadata.METADATA_KEY_ARTIST));
                Log.d(TAG, "onCreate: song = " + meta.getString(MediaMetadata.METADATA_KEY_TITLE));
            }
        }
    }
}
