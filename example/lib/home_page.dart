import 'dart:math';

import 'package:android_automotive_plugin_example/model.dart';
import 'package:android_automotive_plugin_example/new/preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'new/automotive_adapter.dart';

class HomePage extends StatefulWidget {
  final AutomotiveAdapter automotiveAdapter;

  const HomePage({
    super.key,
    required this.automotiveAdapter,
  });

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _ignitionOn = false;
  double? _insideTemp;

  int _driverSeatHeatLevel = 0;
  int _driverSeatVentilationLevel = 0;

  int _passengerSeatHeatLevel = 0;
  int _passengerSeatVentilationLevel = 0;

  SeatSettings _driverSeatSettings = SeatSettings.defaultSettings();
  SeatSettings _passengerSeatSettings = SeatSettings.defaultSettings();

  @override
  void initState() {
    super.initState();

    PreferencesManager.loadDriverSeatSettings().then(
      (value) => setState(() {
        _driverSeatSettings = value;
      }),
    );

    PreferencesManager.loadPassengerSeatSettings().then(
      (value) => setState(() {
        _passengerSeatSettings = value;
      }),
    );

    widget.automotiveAdapter.onIgnitionChange = (ignition) {
      setState(() {
        _ignitionOn = ignition;
      });
    };

    widget.automotiveAdapter.onTemperatureChange = (temp) {
      setState(() {
        _insideTemp = temp;
      });
    };

    widget.automotiveAdapter.onSeatHeatChange = (isDriver, level) {
      setState(() {
        if (isDriver) {
          _driverSeatHeatLevel = level;
        } else {
          _passengerSeatHeatLevel = level;
        }
      });
    };

    widget.automotiveAdapter.onSeatVentilationChange = (isDriver, level) {
      setState(() {
        if (isDriver) {
          _driverSeatVentilationLevel = level;
        } else {
          _passengerSeatVentilationLevel = level;
        }
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 24);
    const textStyle2 = TextStyle(
        fontWeight: FontWeight.w400, fontSize: 30, color: Colors.white);

    Widget buildChairSegment(
      bool isDriver,
      int heatLevel,
      int ventilationLevel,
      SeatSettings seat,
      Function(SeatSettings) onChanged,
    ) {
      const chairColor = Colors.white10;

      final level = heatLevel > 0 ? heatLevel : ventilationLevel;
      final indicatorColor = heatLevel > 0 ? Colors.red : Colors.blueAccent;

      final chairSegment = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/chair.png",
            color: chairColor,
            // height: 350,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 8),
              Icon(
                Icons.circle_rounded,
                color: level > 0 ? indicatorColor : chairColor,
              ),
              Icon(
                Icons.circle_rounded,
                color: level > 1 ? indicatorColor : chairColor,
              ),
              Icon(
                Icons.circle_rounded,
                color: level > 2 ? indicatorColor : chairColor,
              ),
            ],
          ),
        ],
      );

      final rangeSlider = SliderTheme(
        data: const SliderThemeData(
          activeTrackColor: Colors.white24,
          inactiveTrackColor: Colors.blue,
          thumbColor: Colors.blue,
          minThumbSeparation: 2.0,
          trackHeight: 16,
          rangeTrackShape: CustomRoundedRectRangeSliderTrackShape(
              Colors.red, Colors.white24, Colors.blue),
          rangeThumbShape: CustomRoundRangeSliderThumbShape(
              Colors.red, Colors.blue,
              enabledThumbRadius: 20),
        ),
        child: SizedBox(
          width: 100,
          height: 500,
          child: RotatedBox(
            quarterTurns: 3,
            child: RangeSlider(
              min: 0,
              max: 30,
              values: RangeValues(seat.autoHeatTempThreshold.toDouble(),
                  seat.autoVentilationTempThreshold.toDouble()),
              onChanged: (rangeValues) {
                if (rangeValues.end - rangeValues.start >= 5) {
                  onChanged(
                    seat.copyWith(
                      autoHeatTempThreshold: rangeValues.start.toInt(),
                      autoVentilationTempThreshold: rangeValues.end.toInt(),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      );

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              (isDriver ? "Водительское сиденье" : "Пассажирское сиденье")
                  .toUpperCase(),
              style: textStyle),
          const SizedBox(height: 24),
          Row(
            children: [
              if (!isDriver) ...[
                chairSegment,
                const SizedBox(width: 72),
              ] else
                rangeSlider,
              Column(
                // crossAxisAlignment: isDriver
                //     ? CrossAxisAlignment.end
                //     : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Включать автовентиляцию: ${seat.autoVentilationTime == 0 ? "откл." : "${seat.autoVentilationTime} мин."}",
                    style: textStyle2,
                  ),
                  SizedBox(
                    width: 600,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          activeTrackColor: Colors.white54,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          trackHeight: 56,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 30)),
                      child: Slider(
                        min: 0,
                        max: 30,
                        value: seat.autoVentilationTime.toDouble(),
                        onChanged: (value) {
                          onChanged(seat.copyWith(
                              autoVentilationTime: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                      "когда температура в салоне выше: ${seat.autoVentilationTempThreshold} °C",
                      style: textStyle2),
                  const SizedBox(height: 44),
                  const SizedBox(
                    width: 300,
                    child: Divider(
                      height: 32,
                    ),
                  ),
                  const SizedBox(height: 44),
                  Text(
                      "Включать автоподогрев: ${seat.autoHeatTime == 0 ? "откл." : "${seat.autoHeatTime} мин."}",
                      style: textStyle2),
                  SizedBox(
                    width: 600,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          activeTrackColor: Colors.white54,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: Colors.white,
                          trackHeight: 56,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 30)),
                      child: Slider(
                        min: 0,
                        max: 30,
                        value: seat.autoHeatTime.toDouble(),
                        onChanged: (value) {
                          onChanged(seat.copyWith(autoHeatTime: value.toInt()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                      "когда температура в салоне ниже: ${seat.autoHeatTempThreshold} °C ",
                      style: textStyle2),
                ],
              ),
              if (isDriver) ...[
                const SizedBox(width: 72),
                chairSegment,
              ] else
                rangeSlider,
            ],
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: SafeArea(
        child: FittedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.2,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Observer(
                  builder: (ctx) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 40),
                      const Spacer(),
                      const Text("ЗАЖИГАНИЕ", style: textStyle),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.circle_rounded,
                        color: _ignitionOn ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 32),
                      Text(
                          "ТЕМПЕРАТУРА В САЛОНЕ ${_insideTemp == null ? "--" : _insideTemp!}°C",
                          style: textStyle),
                      const Spacer(),
                      // const SizedBox(width: 16),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             LogPage(automotiveStore: automotiveStore),
                      //       ),
                      //     );
                      //   },
                      //   child: const Text("Logs"),
                      // ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(32),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Observer(
                          builder: (context) => buildChairSegment(
                            true,
                            _driverSeatHeatLevel,
                            _driverSeatVentilationLevel,
                            _driverSeatSettings,
                            (seatSettings) {
                              PreferencesManager.saveDriverSeatSettings(
                                  seatSettings);
                              setState(() {
                                _driverSeatSettings = seatSettings;
                              });
                            },
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          height: 300,
                          child: VerticalDivider(),
                        ),
                        const Spacer(),
                        Observer(
                          builder: (context) => buildChairSegment(
                            false,
                            _passengerSeatHeatLevel,
                            _passengerSeatVentilationLevel,
                            _passengerSeatSettings,
                            (seatSettings) {
                              PreferencesManager.savePassengerSeatSettings(
                                  seatSettings);
                              setState(() {
                                _passengerSeatSettings = seatSettings;
                              });
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppSliderShape extends SliderComponentShape {
  final double thumbRadius;

  const AppSliderShape({required this.thumbRadius});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    // draw icon with text painter
    const iconData = Icons.drag_handle;
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.rtl);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: thumbRadius * 2,
          fontFamily: iconData.fontFamily,
          color: sliderTheme.thumbColor,
        ));
    textPainter.layout();

    final Offset textCenter = Offset(center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2));
    const cornerRadius = 4.0;

    // draw the background shape here..
    canvas.drawRRect(
      RRect.fromRectXY(Rect.fromCenter(center: center, width: 30, height: 20),
          cornerRadius, cornerRadius),
      paint,
    );

    textPainter.paint(canvas, textCenter);
  }
}

class CustomRoundedRectRangeSliderTrackShape extends RangeSliderTrackShape
    with BaseRangeSliderTrackShape {
  /// Create a slider track with rounded outer edges.
  ///
  /// The middle track segment is the selected range and is active, and the two
  /// outer track segments are inactive.

  ///

  final Color _startTrackColor;
  final Color _normalTrackColor;
  final Color _endTrackColor;

  const CustomRoundedRectRangeSliderTrackShape(
    this._startTrackColor,
    this._normalTrackColor,
    this._endTrackColor,
  );

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.rangeThumbShape != null);

    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final ColorTween startTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: _startTrackColor,
    );
    final ColorTween normalTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: _normalTrackColor,
    );
    final ColorTween endTrackColorTween = ColorTween(
      begin: sliderTheme.disabledInactiveTrackColor,
      end: _endTrackColor,
    );

    final Paint startPaint = Paint()
      ..color = startTrackColorTween.evaluate(enableAnimation)!;
    final Paint normalPaint = Paint()
      ..color = normalTrackColorTween.evaluate(enableAnimation)!;
    final Paint endPaint = Paint()
      ..color = endTrackColorTween.evaluate(enableAnimation)!;

    final (Offset leftThumbOffset, Offset rightThumbOffset) =
        switch (textDirection) {
      TextDirection.ltr => (startThumbCenter, endThumbCenter),
      TextDirection.rtl => (endThumbCenter, startThumbCenter),
    };
    final Size thumbSize =
        sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final double thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      startPaint,
    );
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top - (additionalActiveTrackHeight / 2),
        rightThumbOffset.dx,
        trackRect.bottom + (additionalActiveTrackHeight / 2),
      ),
      normalPaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      endPaint,
    );
  }
}

class CustomRoundRangeSliderThumbShape extends RangeSliderThumbShape {
  /// Create a slider thumb that draws a circle.
  ///
  final Color _startColor;
  final Color _endColor;
  const CustomRoundRangeSliderThumbShape(
    this._startColor,
    this._endColor, {
    this.enabledThumbRadius = 10.0,
    this.disabledThumbRadius,
    this.elevation = 1.0,
    this.pressedElevation = 6.0,
  });

  /// The preferred radius of the round thumb shape when the slider is enabled.
  ///
  /// If it is not provided, then the Material Design default of 10 is used.
  final double enabledThumbRadius;

  /// The preferred radius of the round thumb shape when the slider is disabled.
  ///
  /// If no disabledRadius is provided, then it is equal to the
  /// [enabledThumbRadius].
  final double? disabledThumbRadius;
  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  /// The resting elevation adds shadow to the unpressed thumb.
  ///
  /// The default is 1.
  final double elevation;

  /// The pressed elevation adds shadow to the pressed thumb.
  ///
  /// The default is 6.
  final double pressedElevation;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled ? enabledThumbRadius : _disabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    assert(sliderTheme.showValueIndicator != null);
    assert(sliderTheme.overlappingShapeStrokeColor != null);
    final Canvas canvas = context.canvas;
    final Tween<double> radiusTween = Tween<double>(
      begin: _disabledThumbRadius,
      end: enabledThumbRadius,
    );
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: thumb == Thumb.start ? _startColor : _endColor,
    );
    final double radius = radiusTween.evaluate(enableAnimation);
    final Tween<double> elevationTween = Tween<double>(
      begin: elevation,
      end: pressedElevation,
    );

    // Add a stroke of 1dp around the circle if this thumb would overlap
    // the other thumb.
    if (isOnTop ?? false) {
      final Paint strokePaint = Paint()
        ..color = sliderTheme.overlappingShapeStrokeColor!
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, strokePaint);
    }

    final Color color = colorTween.evaluate(enableAnimation)!;

    final double evaluatedElevation =
        isPressed! ? elevationTween.evaluate(activationAnimation) : elevation;
    final Path shadowPath = Path()
      ..addArc(
          Rect.fromCenter(
              center: center, width: 2 * radius, height: 2 * radius),
          0,
          pi * 2);

    bool paintShadows = true;
    assert(() {
      if (debugDisableShadows) {
        // _debugDrawShadow(canvas, shadowPath, evaluatedElevation);
        paintShadows = false;
      }
      return true;
    }());

    if (paintShadows) {
      canvas.drawShadow(shadowPath, Colors.black, evaluatedElevation, true);
    }

    canvas.drawCircle(
      center,
      radius,
      Paint()..color = color,
    );
  }
}
