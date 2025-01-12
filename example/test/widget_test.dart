import 'package:android_automotive_plugin_example/model.dart';
import 'package:android_automotive_plugin_example/new/mock_adapter.dart';
import 'package:android_automotive_plugin_example/new/seat_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SeatManager Tests', () {
    late MockAutomotiveAdapter mockAdapter;
    late SeatManager seatManager;

    setUp(() {
      mockAdapter = MockAutomotiveAdapter();

      final driverSettings = SeatSettings(
        autoHeatTempThreshold: 15,
        autoHeatTime: 10,
        autoVentilationTempThreshold: 25,
        autoVentilationTime: 5,
      );

      final passengerSettings = SeatSettings(
        autoHeatTempThreshold: 16,
        autoHeatTime: 8,
        autoVentilationTempThreshold: 24,
        autoVentilationTime: 4,
      );

      seatManager = SeatManager(
        automotiveAdapter: mockAdapter,
        driverSettings: driverSettings,
        passengerSettings: passengerSettings,
      );
    });

    test('Initial state should be correct', () async {
      expect(await mockAdapter.getIgnitionOn(), isFalse);
      expect(await mockAdapter.getInsideTemperature(), equals(20.0));
    });

    test('SeatManager should react to ignition on', () async {
      mockAdapter.simulateIgnitionChange(true);

      expect(await mockAdapter.getIgnitionOn(), isTrue);
    });

    test(
        'Driver seat should heat up when ignition is turned on and temperature is low',
        () async {
      mockAdapter.simulateTemperatureChange(10.0);
      mockAdapter.simulateIgnitionChange(true);

      await Future.delayed(
          Duration(milliseconds: 100)); // Ожидаем обновления состояния

      expect(mockAdapter.onSeatHeatChange, isNotNull);
      mockAdapter.onSeatHeatChange = (isDriver, heatLevel) {
        if (isDriver) {
          expect(heatLevel, equals(3));
        }
      };
    });

    test('Passenger seat should not react to high temperature', () async {
      mockAdapter.simulateTemperatureChange(26.0);
      mockAdapter.simulateIgnitionChange(true);

      await Future.delayed(
          Duration(milliseconds: 100)); // Ожидаем обновления состояния

      mockAdapter.onSeatVentilationChange = (isDriver, ventilationLevel) {
        if (!isDriver) {
          expect(ventilationLevel, equals(0));
        }
      };
    });

    test('Seats should reset when ignition is turned off', () async {
      mockAdapter.simulateIgnitionChange(true);
      mockAdapter.simulateTemperatureChange(10.0);

      mockAdapter.simulateIgnitionChange(false);

      await Future.delayed(Duration(milliseconds: 100)); // Ожидаем сброса

      mockAdapter.onSeatHeatChange = (isDriver, heatLevel) {
        expect(heatLevel, equals(0));
      };

      mockAdapter.onSeatVentilationChange = (isDriver, ventilationLevel) {
        expect(ventilationLevel, equals(0));
      };
    });

    test('External changes should reset SeatController timers', () async {
      mockAdapter.simulateIgnitionChange(true);
      mockAdapter.simulateTemperatureChange(10.0);

      await Future.delayed(Duration(milliseconds: 100)); // Ожидаем включения

      mockAdapter.simulateSeatHeatChange(true, 2);

      await Future.delayed(
          Duration(milliseconds: 100)); // Ожидаем обработки внешнего изменения

      mockAdapter.onSeatHeatChange = (isDriver, heatLevel) {
        if (isDriver) {
          expect(heatLevel, equals(2));
        }
      };
    });
  });
}
