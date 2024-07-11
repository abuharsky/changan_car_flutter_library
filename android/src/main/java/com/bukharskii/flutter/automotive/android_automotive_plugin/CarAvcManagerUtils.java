package com.bukharskii.flutter.automotive.android_automotive_plugin;

import android.car.Car;
import android.car.CarNotConnectedException;
import android.car.VehicleAreaSeat;
import android.car.VehiclePropertyIds;
import android.car.cluster.CarInstrumentClusterManager;
import android.car.hardware.CarPropertyConfig;
import android.car.hardware.CarPropertyValue;
import android.car.hardware.CarSensorEvent;
import android.car.hardware.CarSensorManager;
import android.car.hardware.CarVendorExtensionManager;
import android.car.hardware.cluster.CarClusterInteractionManager;
import android.car.hardware.hvac.CarHvacManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;

import java.io.StringWriter;
import java.io.PrintWriter;

public class CarAvcManagerUtils {

    Context context;

    CarAvcManagerListener carAvcManagerListener;

    CarHvacManager carHvacManager;
    CarHvacManager.CarHvacEventCallback carHvacEventCallback = initCarHvacCallback();

    CarSensorManager carSensorManager;
    CarSensorManager.OnSensorChangedListener carSensorCallback = initCarSensorCallback();


    CarInstrumentClusterManager carInstrumentClusterManager;
    CarInstrumentClusterManager.Callback carInstrumentClusterCallback = initCarClusterInteractionEventCallback();


    CarVendorExtensionManager carVendorExtensionManager;
    CarVendorExtensionManager.CarVendorExtensionCallback carVendorExtensionCallback = initCarVendorExtensionCallback();

    private CarVendorExtensionManager.CarVendorExtensionCallback initCarVendorExtensionCallback() {
        return new CarVendorExtensionManager.CarVendorExtensionCallback() {
            @Override
            public void onChangeEvent(CarPropertyValue carPropertyValue) {
                carAvcManagerListener.onCarVendorExtensionCallback(carPropertyValue);
            }

            @Override
            public void onErrorEvent(int i, int i1) {
                carAvcManagerListener.onLogEvent("CarVendorExtensionCallback.onErrorEvent "+i+", "+i1);
            }
        };
    }

    private CarInstrumentClusterManager.Callback initCarClusterInteractionEventCallback() {
        return new CarInstrumentClusterManager.Callback() {
            @Override
            public void onClusterActivityStateChanged(String s, Bundle bundle) {
                carAvcManagerListener.onCarClusterInteractionEvent(s);
            }

        };
    }

    private CarSensorManager.OnSensorChangedListener initCarSensorCallback() {

        return new CarSensorManager.OnSensorChangedListener() {
            @Override
            public void onSensorChanged(CarSensorEvent carSensorEvent) {
                carAvcManagerListener.onCarSensorEvent(carSensorEvent);
            }
        };
    }

    CarServiceConnection carServiceConnection = new CarServiceConnection();

    private CarHvacManager.CarHvacEventCallback initCarHvacCallback() {
        return new CarHvacManager.CarHvacEventCallback() {
            @Override
            public void onChangeEvent(CarPropertyValue carPropertyValue) {
                carAvcManagerListener.onHvacChangeEvent(carPropertyValue);
            }

            @Override
            public void onErrorEvent(int i, int i1) {
                carAvcManagerListener.onLogEvent("CarHvacEventCallback.onErrorEvent "+i+", "+i1);
            }
        };
    }

    private Car car;

    private class CarServiceConnection implements ServiceConnection {

        @Override
        public void onServiceConnected(ComponentName componentName, IBinder iBinder) {
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.onServiceConnected, component: "+componentName.toString()+", threadId:"+Thread.currentThread().getId());

            initManager();
            //AirConditionerExecutor.executorService().execute(() -> initManager());
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.initManager success");
        }

        @Override
        public void onServiceDisconnected(ComponentName componentName) {
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.onServiceDisconnected");

            try {
                CarAvcManagerUtils carAvcManagerUtils = CarAvcManagerUtils.this;
                if (carAvcManagerUtils.carHvacManager != null) {
                    carAvcManagerUtils.carHvacManager .unregisterCallback(carAvcManagerUtils.carHvacEventCallback);
                    carAvcManagerUtils.carHvacManager  = null;
                }

                if (carAvcManagerUtils.carSensorManager != null) {
                    carAvcManagerUtils.carSensorManager.unregisterListener(carAvcManagerUtils.carSensorCallback);
                    CarAvcManagerUtils.this.carSensorManager = null;
                }

                if (carAvcManagerUtils.carInstrumentClusterManager != null) {
                    carAvcManagerUtils.carInstrumentClusterManager.unregisterCallback(carAvcManagerUtils.carInstrumentClusterCallback);
                    carAvcManagerUtils.carInstrumentClusterManager  = null;
                }

                if (carAvcManagerUtils.carVendorExtensionManager != null) {
                    carAvcManagerUtils.carVendorExtensionManager.unregisterCallback(carAvcManagerUtils.carVendorExtensionCallback);
                    carAvcManagerUtils.carVendorExtensionManager  = null;
                }
            }
            catch(Exception e) {
                e.printStackTrace();
            }

        }
    }

    private void initManager() {
        try {
            this.carHvacManager = (CarHvacManager) this.car.getCarManager(Car.HVAC_SERVICE);
            this.carHvacManager.registerCallback(carHvacEventCallback);
            carAvcManagerListener.onLogEvent("carHvacManager init ok");
            carAvcManagerListener.onLogEvent("[HVAC property list]");

            carAvcManagerListener.onLogEvent("[---------------]");
            for(CarPropertyConfig config:carHvacManager.getPropertyList()) {
                carAvcManagerListener.onLogEvent("[property: "+HvacPropertyIds.valueToString(config.getPropertyId())+"] "+config.toString());
            }
            carAvcManagerListener.onLogEvent("[---------------]");
        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String sStackTrace = sw.toString();

            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.initManager error: "+sStackTrace);
        }
        try {
            this.carSensorManager = (CarSensorManager) this.car.getCarManager(Car.SENSOR_SERVICE);
            this.carSensorManager.registerListener(carSensorCallback, CarSensorManager.SENSOR_TYPE_IGNITION_STATE, CarSensorManager.SENSOR_RATE_NORMAL);
            this.carSensorManager.registerListener(carSensorCallback, CarSensorManager.SENSOR_TYPE_FUEL_LEVEL, CarSensorManager.SENSOR_RATE_NORMAL);
            this.carSensorManager.registerListener(carSensorCallback, CarSensorManager.SENSOR_TYPE_CAR_SPEED, CarSensorManager.SENSOR_RATE_NORMAL);
            this.carSensorManager.registerListener(carSensorCallback, CarSensorManager.SENSOR_TYPE_BODY_STEERING_WHEEL_STEERING_ANGLE, CarSensorManager.SENSOR_RATE_NORMAL);
            carAvcManagerListener.onLogEvent("carSensorManager init ok");
            carAvcManagerListener.onLogEvent("[SENSOR sensor list] "+carSensorManager.getSupportedSensors().toString());
            carAvcManagerListener.onLogEvent("[SENSOR property list]");

            carAvcManagerListener.onLogEvent("[---------------]");
            for(CarPropertyConfig config:carSensorManager.getPropertyList()) {
                carAvcManagerListener.onLogEvent("[property: "+VehiclePropertyIds.toString(config.getPropertyId())+"] "+config.toString());
            }
            carAvcManagerListener.onLogEvent("[---------------]");
        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String sStackTrace = sw.toString();

            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.initManager error: "+sStackTrace);
        }

        try {
            this.carVendorExtensionManager = (CarVendorExtensionManager) this.car.getCarManager(Car.VENDOR_EXTENSION_SERVICE);
            this.carVendorExtensionManager.registerCallback(carVendorExtensionCallback);
            carAvcManagerListener.onLogEvent("carVendorExtensionManager init ok");
            carAvcManagerListener.onLogEvent("[VendorExtension property list]");


            carAvcManagerListener.onLogEvent("[---------------]");
            for(CarPropertyConfig config:carVendorExtensionManager.getProperties()) {
                carAvcManagerListener.onLogEvent("[property: "+VehiclePropertyIds.toString(config.getPropertyId())+"] "+config.toString());
            }
            carAvcManagerListener.onLogEvent("[---------------]");

        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String sStackTrace = sw.toString();

            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.initManager error: "+sStackTrace);
        }

        try {
            this.carInstrumentClusterManager = (CarInstrumentClusterManager) this.car.getCarManager(Car.CAR_INSTRUMENT_CLUSTER_SERVICE);
            this.carInstrumentClusterManager.registerCallback(CarInstrumentClusterManager.CATEGORY_NAVIGATION, carInstrumentClusterCallback);
            carAvcManagerListener.onLogEvent("carClusterInteractionManager init ok");
            carAvcManagerListener.onLogEvent("[ClusterInteraction property list]");


//            carAvcManagerListener.onLogEvent("[---------------]");
//            for(CarPropertyConfig config:carInstrumentClusterManager.) {
//                carAvcManagerListener.onLogEvent("[property: "+VehiclePropertyIds.toString(config.getPropertyId())+"] "+config.toString());
//            }
//            carAvcManagerListener.onLogEvent("[---------------]");

        } catch (Exception e) {
            e.printStackTrace();

            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            String sStackTrace = sw.toString();

            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.initManager error: "+sStackTrace);
        }
    }

    public CarAvcManagerUtils(Context context, CarAvcManagerListener carAvcManagerListener) {
        this.context = context;
        this.carAvcManagerListener = carAvcManagerListener;

        carAvcManagerListener.onLogEvent("createCar");
        car = Car.createCar(context, carServiceConnection);
        if (car == null) {
            carAvcManagerListener.onLogEvent("car is null ..............");
        } else {
            try {
                car.connect();
                carAvcManagerListener.onLogEvent("car is connect ..............");
            } catch (Exception e) {
                e.printStackTrace();
                carAvcManagerListener.onLogEvent("car connect error: "+e.toString());
            }
            carAvcManagerListener.onLogEvent("create car finished..............");
        }
        carAvcManagerListener.onLogEvent("createCar end!");
    }

    public final boolean isConnected() {
        if (car == null || !car.isConnected() || this.carHvacManager == null || this.carSensorManager == null) {
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.isConnect car is not connected!!!!");
            return false;
        }
        return true;
    }


    public int getHvacIntProperty(int propertyId, int area) {
        try {
            return carHvacManager.getIntProperty(propertyId, area);
        } catch (Exception e2) {
            e2.printStackTrace();
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.getHvacIntProperty: proId=" + VehiclePropertyIds.toString(propertyId) + ", area=" + area + ". " + e2.toString());
            return -1;
        }
    }

    public void setHvacIntProperty(int propertyId, int area, int value) {
        try {
            this.carHvacManager.setIntProperty(propertyId, area, value);
        } catch (Exception e) {
            e.printStackTrace();
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setHvacIntProperty error Other: proId=" + VehiclePropertyIds.toString(propertyId) + ", area=" + area + ", value=" + value + ". " + e.toString());
        }
        carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setIntProperty success! value = "+ value);
    }

    public void setHvacFloatProperty(int propertyId, int area, float value) {
        try {
            carHvacManager.setFloatProperty(propertyId, area, value);
        } catch (Exception e) {
            e.printStackTrace();
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setHvacIntProperty error Other: proId=" + VehiclePropertyIds.toString(propertyId) + ", area=" + area + ", value=" + value + ". " + e.toString());
        }
        carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setIntProperty success! value = "+ value);
    }

    public float getHvacFloatProperty(int propertyId, int area) {
        try {
            return carHvacManager.getFloatProperty(propertyId, area);
        } catch (Exception e) {
            e.printStackTrace();
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.getHvacFloatProperty error Other: proId=" + VehiclePropertyIds.toString(propertyId) + ", area=" + area);
        }

        return -1;
    }

    public CarSensorEvent getLatestSensorEvent(int sensorType) {
        try {
            if (carSensorManager != null) {
                return carSensorManager.getLatestSensorEvent(sensorType);
            }
        } catch (Exception e) {
            e.printStackTrace();
            carAvcManagerListener.onLogEvent("CarAvcManagerUtils.getLatestSensorEvent error Other: proId=" + sensorType);
        }

        return null;
    }

    public void setAcTemperature(boolean isDriver, float temp) {
        carAvcManagerListener.onLogEvent("FrontAirPresenter.requestACTemp: isDriver = " + isDriver + "--temp = " + temp);
        int area = isDriver ? VehicleAreaSeat.SEAT_MAIN_DRIVER : VehicleAreaSeat.SEAT_PASSENGER;
        if (carHvacManager != null) {
            if (!isConnected()) {
                carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setIntProperty......................return");
            } else {
                try {
                    carHvacManager.setFloatProperty(CarHvacManager.ID_ZONED_TEMP_SETPOINT, area, temp);
                } catch (Exception e2) {
                    e2.printStackTrace();
                    carAvcManagerListener.onLogEvent("CarAvcManagerUtils.Other: proId=ID_ZONED_TEMP_SETPOINT, area=" + area + ", value=" + temp + ". " + e2.toString());
                }
                carAvcManagerListener.onLogEvent("CarAvcManagerUtils.setFloatProperty success! value = " + temp);
            }

        }
    }

    public void setSeatTempLevel(boolean isDriver, int level) {
        carAvcManagerListener.onLogEvent("ChairPresenter.requestSeatHeat: isDriver =" + isDriver+", SeatHeatLevel ="+level);

        setHvacIntProperty(VehiclePropertyIds.HVAC_SEAT_TEMPERATURE,
                isDriver ? VehicleAreaSeat.SEAT_MAIN_DRIVER : VehicleAreaSeat.SEAT_PASSENGER,
                level);
    }

}


