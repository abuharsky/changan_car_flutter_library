import 'package:android_automotive_plugin_example/new/automotive_adapter.dart';

import 'seat_controller.dart';
import '../model.dart';

class SeatManager {
  final AutomotiveAdapter automotiveAdapter;
  final SeatController driverSeatController;
  final SeatController passengerSeatController;

  bool _previousIgnitionState =
      false; // Сохраняем предыдущее состояние зажигания

  SeatManager({
    required this.automotiveAdapter,
    required SeatSettings driverSettings,
    required SeatSettings passengerSettings,
  })  : driverSeatController = SeatController(
          settings: driverSettings,
          onHeatChange: (level) => automotiveAdapter.setDriverHeatLevel(level),
          onVentilationChange: (level) =>
              automotiveAdapter.setDriverVentilationLevel(level),
        ),
        passengerSeatController = SeatController(
          settings: passengerSettings,
          onHeatChange: (level) =>
              automotiveAdapter.setPassengerHeatLevel(level),
          onVentilationChange: (level) =>
              automotiveAdapter.setPassengerVentilationLevel(level),
        ) {
    _initialize();
  }

  void _initialize() async {
    automotiveAdapter.onSeatHeatChange = (isDriver, heatLevel) {
      final seat = isDriver ? driverSeatController : passengerSeatController;
      seat.externalChange(heatLevel: heatLevel, ventilationLevel: 0);
    };

    automotiveAdapter.onSeatVentilationChange = (isDriver, ventilationLevel) {
      final seat = isDriver ? driverSeatController : passengerSeatController;
      seat.externalChange(heatLevel: 0, ventilationLevel: ventilationLevel);
    };

    // Подписываемся на изменения зажигания
    automotiveAdapter.onIgnitionChange = _handleIgnitionChange;
    _handleIgnitionChange(await automotiveAdapter.getIgnitionOn());
  }

  void _handleIgnitionChange(bool ignitionOn) {
    final currentIgnitionState = ignitionOn;

    // Если зажигание включилось, запускаем логику
    if (currentIgnitionState && !_previousIgnitionState) {
      _handleIgnitionOn();
    }
    // Если зажигание выключилось, сбрасываем состояние
    else if (!currentIgnitionState && _previousIgnitionState) {
      _handleIgnitionOff();
    }

    _previousIgnitionState = currentIgnitionState;
  }

  // Логика при включении зажигания
  void _handleIgnitionOn() async {
    final insideTemperature = await automotiveAdapter.getInsideTemperature();

    driverSeatController.applyState(insideTemperature);
    passengerSeatController.applyState(insideTemperature);
  }

  // Логика при выключении зажигания
  void _handleIgnitionOff() {
    driverSeatController.reset();
    passengerSeatController.reset();
  }
}
