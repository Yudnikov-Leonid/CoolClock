import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  static const millisecondsKey = 'MILLISECONDS_KEY';
  static const lastUpdateKey = 'LAST_UPDATE_KEY';
  static const isRunningKey = 'IS_RUNNING_KEY';
  static const onPauseKey = 'ON_PAUSE_KEY';

  bool _onPause = false;
  bool _isRunning = false;

  Timer? _timer;

  String _timeString = '';

  @override
  void initState() {
    _handleTimer();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (value) async {
      if (mounted && _isRunning && !_onPause) {
        final pref = await SharedPreferences.getInstance();
        _timeString = _format(pref.getDouble(millisecondsKey) ?? 0);
        setState(() {
          final milliseconds = pref.getDouble(millisecondsKey) ?? 0;
          pref.setDouble(millisecondsKey, milliseconds + 100);
          pref.setInt(lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
        });
      }
    });
    super.initState();
  }

  void _handleTimer() async {
    final pref = await SharedPreferences.getInstance();
    _onPause = pref.getBool(onPauseKey) ?? false;
    _isRunning = pref.getBool(isRunningKey) ?? false;
    double milliseconds = pref.getDouble(millisecondsKey) ?? 0;
    if (_isRunning && !_onPause) {
      final lastUpdate = pref.getInt(lastUpdateKey) ?? 0;
      milliseconds += DateTime.now().millisecondsSinceEpoch - lastUpdate;
      await pref.setDouble(millisecondsKey, milliseconds);
    }
    _timeString = _format(milliseconds);
    setState(() {});
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
            _timeString,
            style: const TextStyle(color: Colors.white, fontSize: 40),
          )),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();
                    _onPause = pref.getBool(onPauseKey) ?? false;
                    _isRunning = pref.getBool(isRunningKey) ?? false;
                    if (_isRunning || _onPause) {
                      await pref.setDouble(millisecondsKey, 0);
                      _onPause = false;
                      await pref.setBool(onPauseKey, false);
                      _timeString = _format(0);
                    }
                    _isRunning = !_isRunning;
                    await pref.setBool(isRunningKey, _isRunning);
                    setState(() {});
                  },
                  child: Text(
                    _isRunning || _onPause ? 'Stop' : 'Start',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )),
              TextButton(
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();
                    if (_isRunning) {
                      _onPause = !_onPause;
                      pref.setBool(onPauseKey, _onPause);
                      setState(() {});
                    }
                  },
                  child: Text(
                    _onPause ? 'Resume' : 'Pause',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ))
            ],
          )
        ],
      ),
    );
  }

  String _format(double milliseconds) {
    final sec = milliseconds ~/ 1000;
    final seconds = sec % 60;
    final minutes = sec % 3600 ~/ 60;
    final hours = sec ~/ 3600;

    return '${hours < 10 ? '0$hours' : hours}:${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}';
  }
}
