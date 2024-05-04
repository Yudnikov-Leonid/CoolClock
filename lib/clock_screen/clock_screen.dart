import 'dart:async';

import 'package:cool_clock/clock_screen/clock_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends State<ClockScreen> {
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedTime = DateFormat('HH:mm:ss').format(now);
    final formattedDate = DateFormat('EEE, d MMM').format(now);
    final timeZone = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '-';
    if (!timeZone.startsWith('-')) offsetSign = '+';

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Clock',
              style: TextStyle(
                  fontSize: 36,
                  color: Colors.grey.shade100,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              formattedTime,
              style: TextStyle(color: Colors.grey.shade100, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            const Center(child: ClockWidget()),
            const SizedBox(
              height: 20,
            ),
            Text(formattedDate, style: TextStyle(color: Colors.grey.shade100),),
            const SizedBox(
              height: 100,
            ),
            Text(
              'Timezone',
              style: TextStyle(fontSize: 20,
                  color: Colors.grey.shade100, fontWeight: FontWeight.bold),
            ),
            Text('UTC$offsetSign$timeZone', style: TextStyle(color: Colors.grey.shade100),)
          ],
        ));
  }
}
