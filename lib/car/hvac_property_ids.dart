// ignore_for_file: constant_identifier_names

final class CarHvacPropertyIds {
  static const int FAN_DIRECTION_DEFROST = 4;
  static const int FAN_DIRECTION_FACE = 1;
  static const int FAN_DIRECTION_FLOOR = 2;
  static const int HVAC_AUTO_DEFOG_SWITCH = 557855762;
  static const int ID_HVAC_ACTIVE_VENTILATION_ON = 557848832;
  static const int ID_HVAC_AIR_DRYIONG_ON = 557848833;
  static const int ID_HVAC_AIR_QUALITY_IN_OUT_CAR = 675289346;
  static const int ID_HVAC_AIR_QUALITY_RATING_INNER = 557848836;
  static const int ID_HVAC_APU_CTR = 692073591;
  static const int ID_HVAC_AQS_MODE_ON = 557848837;
  static const int ID_HVAC_COMFORT_MODE = 557848838;
  static const int ID_HVAC_CONTROL_MODE = 557848857;
  static const int ID_HVAC_DISPLAY_REQ = 557848839;
  static const int ID_HVAC_DUAL_STATE = 557848851;
  static const int ID_HVAC_FAN_SPEED_ACK = 356517140;
  static const int ID_HVAC_FAN_SPEED_ADJUST = 624957704;
  static const int ID_HVAC_FRONTWIND_SHIELD_WARM = 557855830;
  static const int ID_HVAC_IN_OUT_TEMP = 675289370;
  static const int ID_HVAC_ION_GENERATOR_ON = 557848841;
  static const int ID_HVAC_REFRESH_MODE_FEEDBACK = 557855867;
  static const int ID_HVAC_SCENE_MODE_ACT = 557848854;
  static const int ID_HVAC_SCENE_MODE_CTL_ON = 557848853;
  static const int ID_HVAC_SCENE_MODE_FEEDBACK = 557848856;
  static const int ID_HVAC_SCENE_MODE_REQ = 557848855;
  static const int ID_HVAC_SEAT_VENTILATION = 356517139;
  static const int ID_HVAC_SETTING_LOCK = 624957706;
  static const int ID_HVAC_TEMPERATURE_ADJUST = 624957714;
  static const int ID_HVAC_TEMPERATURE_LV_SET = 624957707;
  static const int ID_HVAC_TIMING_VENTILATION_MODE = 557848844;
  static const int ID_HVAC_VENTILATION_USER_DEFINED_SETTING_AFTERNOON =
      557848845;
  static const int ID_HVAC_VENTILATION_USER_DEFINED_SETTING_EVENING = 557848846;
  static const int ID_HVAC_VENTILATION_USER_DEFINED_SETTING_MORNING = 557848847;
  static const int ID_HVAC_VIBRATION_FEEDBACK = 557906432;
  static const int ID_HVAC_WAKE_REQ = 557848859;
  static const int ID_HVAC_WINDOW_VENTILATION_ON = 557848849;
  static const int ID_MIRROR_DEFROSTER_ON = 339739916;

  //@Deprecated
  static const int ID_OUTSIDE_AIR_TEMP = 291505923;
  static const int ID_STEERING_WHEEL_HEAT = 289408269;
  static const int ID_TEMPERATURE_DISPLAY_UNITS = 289408270;
  static const int ID_WINDOW_DEFROSTER_ON = 322962692;
  static const int ID_ZONED_AC_ON = 356517125;
  static const int ID_ZONED_AIR_RECIRCULATION_ON = 356517128;
  static const int ID_ZONED_AUTOMATIC_MODE_ON = 356517130;
  static const int ID_ZONED_DUAL_ZONE_ON = 356517129;
  static const int ID_ZONED_FAN_DIRECTION = 356517121;
  static const int ID_ZONED_FAN_DIRECTION_AVAILABLE = 356582673;
  static const int ID_ZONED_FAN_SPEED_RPM = 356517135;

  //@Deprecated
  static const int ID_ZONED_FAN_SPEED_SETPOINT = 356517120;
  static const int ID_ZONED_HVAC_AUTO_RECIRC_ON = 354419986;
  static const int ID_ZONED_HVAC_POWER_ON = 356517136;
  static const int ID_ZONED_MAX_AC_ON = 356517126;
  static const int ID_ZONED_MAX_DEFROST_ON = 354419975;
  static const int ID_ZONED_SEAT_TEMP = 356517131;
  static const int ID_ZONED_TEMP_ACTUAL = 358614274;
  static const int ID_ZONED_TEMP_SETPOINT = 358614275;

  static valueToString(int value) {
    if (value == FAN_DIRECTION_DEFROST) {
      return "FAN_DIRECTION_DEFROST";
    } else if (value == FAN_DIRECTION_FACE) {
      return "FAN_DIRECTION_FACE";
    } else if (value == FAN_DIRECTION_FLOOR) {
      return "FAN_DIRECTION_FLOOR";
    } else if (value == HVAC_AUTO_DEFOG_SWITCH) {
      return "HVAC_AUTO_DEFOG_SWITCH";
    } else if (value == ID_HVAC_ACTIVE_VENTILATION_ON) {
      return "ID_HVAC_ACTIVE_VENTILATION_ON";
    } else if (value == ID_HVAC_AIR_DRYIONG_ON) {
      return "ID_HVAC_AIR_DRYIONG_ON";
    } else if (value == ID_HVAC_AIR_QUALITY_IN_OUT_CAR) {
      return "ID_HVAC_AIR_QUALITY_IN_OUT_CAR";
    } else if (value == ID_HVAC_AIR_QUALITY_RATING_INNER) {
      return "ID_HVAC_AIR_QUALITY_RATING_INNER";
    } else if (value == ID_HVAC_APU_CTR) {
      return "ID_HVAC_APU_CTR";
    } else if (value == ID_HVAC_AQS_MODE_ON) {
      return "ID_HVAC_AQS_MODE_ON";
    } else if (value == ID_HVAC_COMFORT_MODE) {
      return "ID_HVAC_COMFORT_MODE";
    } else if (value == ID_HVAC_CONTROL_MODE) {
      return "ID_HVAC_CONTROL_MODE";
    } else if (value == ID_HVAC_DISPLAY_REQ) {
      return "ID_HVAC_DISPLAY_REQ";
    } else if (value == ID_HVAC_DUAL_STATE) {
      return "ID_HVAC_DUAL_STATE";
    } else if (value == ID_HVAC_FAN_SPEED_ACK) {
      return "ID_HVAC_FAN_SPEED_ACK";
    } else if (value == ID_HVAC_FAN_SPEED_ADJUST) {
      return "ID_HVAC_FAN_SPEED_ADJUST";
    } else if (value == ID_HVAC_FRONTWIND_SHIELD_WARM) {
      return "ID_HVAC_FRONTWIND_SHIELD_WARM";
    } else if (value == ID_HVAC_IN_OUT_TEMP) {
      return "ID_HVAC_IN_OUT_TEMP";
    } else if (value == ID_HVAC_ION_GENERATOR_ON) {
      return "ID_HVAC_ION_GENERATOR_ON";
    } else if (value == ID_HVAC_REFRESH_MODE_FEEDBACK) {
      return "ID_HVAC_REFRESH_MODE_FEEDBACK";
    } else if (value == ID_HVAC_SCENE_MODE_ACT) {
      return "ID_HVAC_SCENE_MODE_ACT";
    } else if (value == ID_HVAC_SCENE_MODE_CTL_ON) {
      return "ID_HVAC_SCENE_MODE_CTL_ON";
    } else if (value == ID_HVAC_SCENE_MODE_FEEDBACK) {
      return "ID_HVAC_SCENE_MODE_FEEDBACK";
    } else if (value == ID_HVAC_SCENE_MODE_REQ) {
      return "ID_HVAC_SCENE_MODE_REQ";
    } else if (value == ID_HVAC_SEAT_VENTILATION) {
      return "ID_HVAC_SEAT_VENTILATION";
    } else if (value == ID_HVAC_SETTING_LOCK) {
      return "ID_HVAC_SETTING_LOCK";
    } else if (value == ID_HVAC_TEMPERATURE_ADJUST) {
      return "ID_HVAC_TEMPERATURE_ADJUST";
    } else if (value == ID_HVAC_TEMPERATURE_LV_SET) {
      return "ID_HVAC_TEMPERATURE_LV_SET";
    } else if (value == ID_HVAC_TIMING_VENTILATION_MODE) {
      return "ID_HVAC_TIMING_VENTILATION_MODE";
    } else if (value == ID_HVAC_VENTILATION_USER_DEFINED_SETTING_AFTERNOON) {
      return "ID_HVAC_VENTILATION_USER_DEFINED_SETTING_AFTERNOON";
    } else if (value == ID_HVAC_VENTILATION_USER_DEFINED_SETTING_EVENING) {
      return "ID_HVAC_VENTILATION_USER_DEFINED_SETTING_EVENING";
    } else if (value == ID_HVAC_VENTILATION_USER_DEFINED_SETTING_MORNING) {
      return "ID_HVAC_VENTILATION_USER_DEFINED_SETTING_MORNING";
    } else if (value == ID_HVAC_VIBRATION_FEEDBACK) {
      return "ID_HVAC_VIBRATION_FEEDBACK";
    } else if (value == ID_HVAC_WAKE_REQ) {
      return "ID_HVAC_WAKE_REQ";
    } else if (value == ID_HVAC_WINDOW_VENTILATION_ON) {
      return "ID_HVAC_WINDOW_VENTILATION_ON";
    } else if (value == ID_MIRROR_DEFROSTER_ON) {
      return "ID_MIRROR_DEFROSTER_ON";

      //@Deprecated
    } else if (value == ID_OUTSIDE_AIR_TEMP) {
      return "ID_OUTSIDE_AIR_TEMP";
    } else if (value == ID_STEERING_WHEEL_HEAT) {
      return "ID_STEERING_WHEEL_HEAT";
    } else if (value == ID_TEMPERATURE_DISPLAY_UNITS) {
      return "ID_TEMPERATURE_DISPLAY_UNITS";
    } else if (value == ID_WINDOW_DEFROSTER_ON) {
      return "ID_WINDOW_DEFROSTER_ON";
    } else if (value == ID_ZONED_AC_ON) {
      return "ID_ZONED_AC_ON";
    } else if (value == ID_ZONED_AIR_RECIRCULATION_ON) {
      return "ID_ZONED_AIR_RECIRCULATION_ON";
    } else if (value == ID_ZONED_AUTOMATIC_MODE_ON) {
      return "ID_ZONED_AUTOMATIC_MODE_ON";
    } else if (value == ID_ZONED_DUAL_ZONE_ON) {
      return "ID_ZONED_DUAL_ZONE_ON";
    } else if (value == ID_ZONED_FAN_DIRECTION) {
      return "ID_ZONED_FAN_DIRECTION";
    } else if (value == ID_ZONED_FAN_DIRECTION_AVAILABLE) {
      return "ID_ZONED_FAN_DIRECTION_AVAILABLE";
    } else if (value == ID_ZONED_FAN_SPEED_RPM) {
      return "ID_ZONED_FAN_SPEED_RPM";

      //@Deprecated
    } else if (value == ID_ZONED_FAN_SPEED_SETPOINT) {
      return "ID_ZONED_FAN_SPEED_SETPOINT";
    } else if (value == ID_ZONED_HVAC_AUTO_RECIRC_ON) {
      return "ID_ZONED_HVAC_AUTO_RECIRC_ON";
    } else if (value == ID_ZONED_HVAC_POWER_ON) {
      return "ID_ZONED_HVAC_POWER_ON";
    } else if (value == ID_ZONED_MAX_AC_ON) {
      return "ID_ZONED_MAX_AC_ON";
    } else if (value == ID_ZONED_MAX_DEFROST_ON) {
      return "ID_ZONED_MAX_DEFROST_ON";
    } else if (value == ID_ZONED_SEAT_TEMP) {
      return "ID_ZONED_SEAT_TEMP";
    } else if (value == ID_ZONED_TEMP_ACTUAL) {
      return "ID_ZONED_TEMP_ACTUAL";
    } else if (value == ID_ZONED_TEMP_SETPOINT) {
      return "ID_ZONED_TEMP_SETPOINT";
    }

    return "$value";
  }
}
