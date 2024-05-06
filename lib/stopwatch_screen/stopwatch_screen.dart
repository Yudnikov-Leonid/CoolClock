import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? timer;
  int seconds = 0;
  bool isRunning = false;
  bool onPause = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (value) {
      if (mounted && isRunning && !onPause) {
        setState(() {
          seconds++;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stopwatch',
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 200,
          ),
          Center(
              child: Text(
            _format(seconds),
            style: const TextStyle(color: Colors.white, fontSize: 40),
          )),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                      if (isRunning || onPause) {
                        seconds = 0;
                      }
                      onPause = false;
                    });
                  },
                  child: Text(
                    isRunning || onPause ? 'Stop' : 'Start',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    if (isRunning) {
                      setState(() {
                        onPause = !onPause;
                      });
                    }
                  },
                  child: Text(
                    onPause ? 'Resume' : 'Pause',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          )
        ],
      ),
    );
  }

  String _format(int sec) {
    final seconds = sec % 60;
    final minutes = sec % 3600 ~/ 60;
    final hours = sec ~/ 3600;

    return '${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
  }
}
