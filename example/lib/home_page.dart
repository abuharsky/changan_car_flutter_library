import 'package:android_automotive_plugin_example/automotive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'log_page.dart';

class HomePage extends StatelessWidget {
  final AutomotiveStore store;

  const HomePage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 24);
    const textStyle2 = TextStyle(fontWeight: FontWeight.w400, fontSize: 24);

    Widget buildChairSegment(bool isDriver, int seatHeatLevel,
        SeatHeatTime heatTime, SeatHeatTempThreshold heatThreshold) {
      const charColor = Colors.white10;
      final chairSegment = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/chair.png",
            color: charColor,
            // height: 100,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 8),
              Icon(
                Icons.circle_rounded,
                color: seatHeatLevel > 0 ? Colors.red : charColor,
              ),
              Icon(
                Icons.circle_rounded,
                color: seatHeatLevel > 1 ? Colors.red : charColor,
              ),
              Icon(
                Icons.circle_rounded,
                color: seatHeatLevel > 2 ? Colors.red : charColor,
              ),
            ],
          ),
        ],
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
              ],
              Column(
                crossAxisAlignment: isDriver
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Включать автоподогрев", style: textStyle2),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 500,
                    child: SegmentedButton(
                      segments: [
                        const ButtonSegment(
                            value: SeatHeatTime.off,
                            label: Text("откл.", style: textStyle2)),
                        ButtonSegment(
                            value: SeatHeatTime.short,
                            label: Text(
                                "${SeatHeatTime.short.getDurationInMinutes} мин",
                                style: textStyle2)),
                        ButtonSegment(
                            value: SeatHeatTime.medium,
                            label: Text(
                                "${SeatHeatTime.medium.getDurationInMinutes} мин",
                                style: textStyle2)),
                        ButtonSegment(
                            value: SeatHeatTime.long,
                            label: Text(
                                "${SeatHeatTime.long.getDurationInMinutes} мин",
                                style: textStyle2))
                      ],
                      selected: {heatTime},
                      onSelectionChanged: (selection) {
                        store.setSeatAutoHeatTime(
                          isDriver,
                          selection.first,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text("когда температура в салоне ниже",
                      style: textStyle2),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 400,
                    child: SegmentedButton(
                      segments: [
                        ButtonSegment(
                            value: SeatHeatTempThreshold.low,
                            label: Text(
                                "${SeatHeatTempThreshold.low.getTempInCelcius} °C",
                                style: textStyle2)),
                        ButtonSegment(
                            value: SeatHeatTempThreshold.medium,
                            label: Text(
                                "${SeatHeatTempThreshold.medium.getTempInCelcius} °C",
                                style: textStyle2)),
                        ButtonSegment(
                            value: SeatHeatTempThreshold.high,
                            label: Text(
                                "${SeatHeatTempThreshold.high.getTempInCelcius} °C",
                                style: textStyle2))
                      ],
                      selected: {heatThreshold},
                      onSelectionChanged: heatTime == SeatHeatTime.off
                          ? null
                          : (selection) {
                              if (selection.isNotEmpty &&
                                  selection.first is SeatHeatTempThreshold) {
                                final temp =
                                    selection.first as SeatHeatTempThreshold;
                                store.setSeatAutoHeatTempTheshold(
                                  isDriver,
                                  temp,
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
              if (isDriver) ...[
                const SizedBox(width: 72),
                chairSegment,
              ],
            ],
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
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
                    color: store.ignitionOn ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 32),
                  Text(
                      "ТЕМПЕРАТУРА В САЛОНЕ ${store.insideTemp == null ? "--" : store.insideTemp!}°C",
                      style: textStyle),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      store.setTestCover();
                    },
                    child: const Text("Test Cover"),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LogPage(automotiveStore: store),
                        ),
                      );
                    },
                    child: const Text("Logs"),
                  ),
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
                        store.driverSeatHeatLevel,
                        store.driverSeatAutoHeatTime,
                        store.driverSeatAutoHeatTempThreshold,
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
                        store.passengerSeatHeatLevel,
                        store.passengerSeatAutoHeatTime,
                        store.passengerSeatAutoHeatTempThreshold,
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
    );
  }
}
