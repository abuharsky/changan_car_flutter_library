import 'dart:async';

import 'package:flutter/foundation.dart';

import '../model.dart';

class SeatController {
  final SeatSettings settings; // Настройки автонагрева/вентиляции
  final Function(int level) onHeatChange; // Коллбек для изменения нагрева
  final Function(int level)
      onVentilationChange; // Коллбек для изменения вентиляции

  Timer? _timer; // Таймер для автоматического отключения
  int _currentHeatLevel = 0; // Текущий уровень нагрева
  int _currentVentilationLevel = 0; // Текущий уровень вентиляции

  SeatController({
    required this.settings,
    required this.onHeatChange,
    required this.onVentilationChange,
  });

  // Применение состояния в зависимости от температуры
  void applyState(double temperature) {
    // Если температура ниже порога автонагрева
    if (temperature < settings.autoHeatTempThreshold &&
        settings.autoHeatTime > 0) {
      _setHeatLevel(3, settings.autoHeatTime);
    }
    // Если температура выше порога автовентиляции
    else if (temperature > settings.autoVentilationTempThreshold &&
        settings.autoVentilationTime > 0) {
      _setVentilationLevel(3, settings.autoVentilationTime);
    }
    // Если ничего не требуется включать
    else {
      _reset();
    }
  }

  // Обработка внешнего изменения состояния нагрева/вентиляции
  void externalChange({required int heatLevel, required int ventilationLevel}) {
    // Если внешнее состояние не совпадает, сбрасываем таймеры
    if (heatLevel != _currentHeatLevel ||
        ventilationLevel != _currentVentilationLevel) {
      _reset();
    }
  }

  // Сброс состояния
  void reset() {
    _reset();
  }

  // Включение нагрева с таймером
  void _setHeatLevel(int level, int duration) {
    // Уже установлено, ничего не делаем
    if (_currentHeatLevel == level) return;

    _currentHeatLevel = level;
    onHeatChange(level); // Вызываем коллбек

    _startTimer(duration, () {
      _currentHeatLevel = 0;
      onHeatChange(0); // Сбрасываем нагрев
    });
  }

  // Включение вентиляции с таймером
  void _setVentilationLevel(int level, int duration) {
    // Уже установлено, ничего не делаем
    if (_currentVentilationLevel == level) return;

    _currentVentilationLevel = level;
    onVentilationChange(level); // Вызываем коллбек

    _startTimer(duration, () {
      _currentVentilationLevel = 0;
      onVentilationChange(0); // Сбрасываем вентиляцию
    });
  }

  // Сброс нагрева и вентиляции
  void _reset() {
    _timer?.cancel();
    _timer = null;

    _currentHeatLevel = 0;
    _currentVentilationLevel = 0;
  }

  // Запуск таймера
  void _startTimer(int duration, VoidCallback onTimeout) {
    _timer?.cancel(); // Сбрасываем предыдущий таймер
    _timer = Timer(Duration(minutes: duration), onTimeout);
  }
}
