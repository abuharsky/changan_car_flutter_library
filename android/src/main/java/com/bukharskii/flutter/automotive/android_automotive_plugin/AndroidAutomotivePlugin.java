package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.car.VehicleAreaSeat;
import android.car.VehiclePropertyIds;
import android.car.hardware.CarPropertyValue;
import android.car.hardware.CarSensorEvent;
import android.car.hardware.hvac.CarHvacManager;
import android.content.Intent;
import android.content.IntentFilter;
import android.view.Surface;
import android.view.SurfaceControl;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import androidx.annotation.NonNull;

//import com.autonavi.amapauto.jni.AutoCarAppFocusManager;
//import com.autonavi.amapauto.jni.MultiScreenNative;
//import com.autonavi.extscreen.dto.PresentationConfig;
import com.incall.serversdk.interactive.media.CaMediaSource;
import com.incall.serversdk.interactive.media.DoubleMediaProxy;
//import com.neusoft.na.ocservice.Binder.ChangAnSDKBinder;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Arrays;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.TextureRegistry;

/** AndroidAutomotivePlugin */
public class AndroidAutomotivePlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private FlutterPluginBinding flutterPluginBinding;
  private MethodChannel channel;
  private CarAvcManagerUtils carAvcManagerUtils;

  private  CurrentMetadataManagerService currentMetadataManagerService;

  private Config config;

  public AndroidAutomotivePlugin() {

        Thread.setDefaultUncaughtExceptionHandler((thread, e) -> {
          // Get the stack trace.
          StringWriter sw = new StringWriter();
          PrintWriter pw = new PrintWriter(sw);
          e.printStackTrace(pw);

          String crash = sw.toString();

          if (channel != null) {
            channel.invokeMethod("onCrash", crash);
          }
        });


  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding;

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "android_automotive_plugin");
    channel.setMethodCallHandler(this);

    config = new Config(flutterPluginBinding.getApplicationContext());

//    currentMetadataManagerService = new CurrentMetadataManagerService();

//    Intent intent = new Intent(flutterPluginBinding.getApplicationContext(), CurrentMetadataManagerService.class);
//    flutterPluginBinding.getApplicationContext().startService(intent);
  }

  private static String carPropertyValueToString(Object value) {
    StringBuilder var2;
    if (value instanceof Object[]) {
      return Arrays.toString((Object[])value);
    } else if (value instanceof byte[]) {
      return Arrays.toString((byte[]) value);
    } else if (value instanceof  Float) {
      double converted = ((Float) value).doubleValue();
      return Double.toString(converted);
    } else {
      return value.toString();
    }
  }

  private  String carPropertyToJsonString(CarPropertyValue carPropertyValue) {
      StringBuilder str = new StringBuilder();

      str.append("{");

      str.append("\"propertyId\":");
      str.append(carPropertyValue.getPropertyId());
      str.append(",");

      str.append("\"areaId\":");
      str.append(carPropertyValue.getAreaId());
      str.append(",");

      str.append("\"status\":");
      str.append(carPropertyValue.getStatus());
      str.append(",");

      str.append("\"timestamp\":");
      str.append(carPropertyValue.getTimestamp());
      str.append(",");

      str.append("\"value\":");
      try {
        str.append("\""+carPropertyValueToString(carPropertyValue.getValue())+"\"");
      } catch (Exception e) {
        str.append("\"0\"");
        carAvcManagerUtils.carAvcManagerListener.onLogEvent(">>>>>> [Convert To Double] exception: " + e.toString());
      }

      str.append("}");


      return str.toString();
  }

  private  String carSensorEventToJsonString(CarSensorEvent carSensorEvent) {
    StringBuilder str = new StringBuilder();

    str.append("{");

    str.append("\"sensorType\":");
    str.append(carSensorEvent.sensorType);
    str.append(",");

    str.append("\"timestamp\":");
    str.append(carSensorEvent.timestamp);
    str.append(",");

    str.append("\"intValues\":");
    str.append(Arrays.toString(carSensorEvent.intValues));
    str.append(",");

    str.append("\"floatValues\":");
    str.append(Arrays.toString(carSensorEvent.floatValues));
    str.append(",");

    str.append("\"longValues\":");
    str.append(Arrays.toString(carSensorEvent.longValues));

    str.append("}");

    return str.toString();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("connect")) {
      carAvcManagerUtils = new CarAvcManagerUtils(flutterPluginBinding.getApplicationContext(), new CarAvcManagerListener() {
        @Override
        public void onHvacChangeEvent(CarPropertyValue carPropertyValue) {
          channel.invokeMethod("onHvacChangeEvent", carPropertyToJsonString(carPropertyValue));

          try {
            if (carPropertyValue.getPropertyId() == CarHvacManager.ID_HVAC_IN_OUT_TEMP) {
              onLogEvent(">>>>>> [ID_HVAC_IN_OUT_TEMP]");
              float floatValue = ((Integer) carPropertyValue.getValue()).floatValue();
              onLogEvent(">>>>>> [ID_HVAC_IN_OUT_TEMP] CarHvacManager onChangeEvent: CarHvacManager.ID_HVAC_IN_OUT_TEMP value = " + floatValue);
              if (carPropertyValue.getAreaId() == 1) {
                onLogEvent(">>>>>> [ID_HVAC_IN_OUT_TEMP] CarHvacManager onChangeEvent: InOutCAR_INSIDE value = " + floatValue);
              } else if (carPropertyValue.getAreaId() == 4) {
                onLogEvent(">>>>>> [ID_HVAC_IN_OUT_TEMP] CarHvacManager onChangeEvent: InOutCAR_OUTSIDE value = " + floatValue);
              }
            }
          } catch (Exception e) {
            onLogEvent(">>>>>> [ID_HVAC_IN_OUT_TEMP] ((Float) carPropertyValue.getValue()).floatValue(); exception: " + e.toString());
          }
        }

        @Override
        public void onCarSensorEvent(CarSensorEvent carSensorEvent) {
          channel.invokeMethod("onCarSensorEvent", carSensorEventToJsonString(carSensorEvent));
        }

        @Override
        public void onCarClusterInteractionEvent(String value) {
          channel.invokeMethod("onCarClusterInteractionEvent", value);
        }

        @Override
        public void onCarVendorExtensionCallback(CarPropertyValue carPropertyValue) {
          channel.invokeMethod("onCarVendorExtensionCallback", carPropertyToJsonString(carPropertyValue));
        }

        @Override
        public void onLogEvent(String logEvent) {
          channel.invokeMethod("onLogEvent", logEvent);
        }
      });
      result.success(null);
    }
    //
    else if (call.method.equals("setHvacIntProperty")) {
      int propertyId = call.argument("propertyId");
      int area = call.argument("area");
      int value = call.argument("value");

      carAvcManagerUtils.setHvacIntProperty(propertyId, area, value);
      result.success(null);
    }
    //
    else if (call.method.equals("getHvacIntProperty")) {
      int propertyId = call.argument("propertyId");
      int area = call.argument("area");

      int value = carAvcManagerUtils.getHvacIntProperty(propertyId, area);
      result.success(value);
    }
    //
    else if (call.method.equals("setHvacFloatProperty")) {
      int propertyId = call.argument("propertyId");
      int area = call.argument("area");
      float value = ((Double) call.argument("value")).floatValue();

      carAvcManagerUtils.setHvacFloatProperty(propertyId, area, value);
      result.success(null);
    }
    //
    else if (call.method.equals("getHvacFloatProperty")) {
      int propertyId = call.argument("propertyId");
      int area = call.argument("area");

      float value = carAvcManagerUtils.getHvacFloatProperty(propertyId, area);
      result.success(value);
    }
    //
    else if (call.method.equals("getLatestSensorEvent")) {
      int sensorType = call.argument("sensorType");

      if (carAvcManagerUtils != null) {
        CarSensorEvent value = carAvcManagerUtils.getLatestSensorEvent(sensorType);
        if (value != null) {
          result.success(carSensorEventToJsonString(value));
        }
        else {
          result.success(null);
        }
      }
      else {
        result.success(null);
      }
    }
    //
    else if (call.method.equals("setAccessibilityServiceCallbackHandler")) {
      config.setBackgroundHandle(call.argument("handleId"));

      /// Set up listener intent
      Intent listenerIntent = new Intent(this.flutterPluginBinding.getApplicationContext(), CustomAccessibilityService.class);
      this.flutterPluginBinding.getApplicationContext().startService(listenerIntent);


      result.success(null);
    }
    //
    else if (call.method.equals("setVehicleSettingMusicAlbumPictureFilePath")) {
      try {
//        boolean res = VehicleSettingManager.getInstance(flutterPluginBinding.getApplicationContext()).musicAlbumPicture(call.argument("path"));
        result.success(true);
      } catch(Exception e) {
        e.printStackTrace();

        result.error("error", "setVehicleSettingManagerMusicAlbumPictureFilePath Error", e);
      }
    }
    else if (call.method.equals("setNaviSurface")) {
      try {

        TextureRegistry.SurfaceTextureEntry entry = flutterPluginBinding.getTextureRegistry().createSurfaceTexture();
        Surface surface = new Surface(entry.surfaceTexture());

 //       com.autonavi.amapauto.jni.AutoCarAppFocusManager.jniRequestAppFocus(1);



        result.success(null);
      } catch(Exception e) {
        e.printStackTrace();

        result.error("error", "resetDoubleMediaPicture Error", e);
      }
    }
    else if (call.method.equals("resetDoubleMediaPicture")) {
      try {
//        int doublePlayingId = call.argument("doublePlayingId");
//        com.incall.serversdk.interactive.media.DoubleMediaProxy.getInstance().sendMediaAlbum(doublePlayingId, "default", null);
        result.success(null);
      } catch(Exception e) {
        e.printStackTrace();

        result.error("error", "resetDoubleMediaPicture Error", e);
      }
    }
    else if (call.method.equals("setDoubleMediaMusicSource")) {
      try {
        int playingId = call.argument("playingId");
        String programName = call.argument("programName");
        String singerName = call.argument("singerName");
        String songName = call.argument("songName");
        int sourceType = call.argument("sourceType");

        CaMediaSource source = new CaMediaSource();
        source.playingId = playingId;
        source.programName = programName;
        source.singerName = singerName;
        source.songName = songName;
        source.sourceType = sourceType;

        DoubleMediaProxy.getInstance().sendMediaSource(source);
        result.success(null);
      } catch(Exception e) {
        e.printStackTrace();

        result.error("error", "setDoubleMediaMusicSource Error", e);
      }
    }
    //
    else if (call.method.equals("setDoubleMediaMusicAlbumPictureFilePath")) {
      try {
        int doublePlayingId = call.argument("doublePlayingId");
        String songId = call.argument("songId");
        String path = call.argument("path");

        DoubleMediaProxy.getInstance().sendMediaAlbumPath(doublePlayingId, songId, path);
        result.success(null);
      } catch(Exception e) {
        e.printStackTrace();

        result.error("error", "setDoubleMediaMusicAlbumPictureFilePath Error", e);
      }
    }
    //
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
