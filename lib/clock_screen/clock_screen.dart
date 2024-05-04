import 'dart:async';

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
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Clock',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        Text(formattedTime),
        Text(formattedDate),
        const SizedBox(
          height: 100,
        ),
        const Text(
          'Timezone',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('UTC$offsetSign$timeZone')
      ],
    ));
  }
}
