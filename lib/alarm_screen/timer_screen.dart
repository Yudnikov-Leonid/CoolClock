import 'package:cool_clock/alarm_screen/alarm_helper.dart';
import 'package:cool_clock/main.dart';
import 'package:cool_clock/alarm_screen/alarm_info.dart';
import 'package:cool_clock/alarm_screen/alarm_widget.dart';
import 'package:cool_clock/alarm_screen/edit_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  final _alarmHelper = AlarmHelper();
  Future<List<AlarmInfo>>? _alarms;

  @override
  void initState() {
    _alarmHelper.initializeDatabase().then((value) {
      _loadAlarms();
    });
    super.initState();
  }

  void _loadAlarms() {
    _alarms = _alarmHelper.getAlarms();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Alarm',
            style: TextStyle(
                fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: FutureBuilder(
              future: _alarms,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: snapshot.data!
                        .map<Widget>((alarm) => AlarmWidget(alarm, _alarmHelper, _loadAlarms))
                        .followedBy([_addButton()]).toList(),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _addButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue.shade800, borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(
        animationDuration: const Duration(milliseconds: 100),
        splashColor: Colors.blue.shade900,
        onPressed: () {
          editAlarmBottomSheet(context, _alarmHelper, _loadAlarms);
        },
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Add alarm',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _makeAlarm(String desc) async {
    final notificationDateTime =
        DateTime.now().add(const Duration(seconds: 10));
    const androidChannel = AndroidNotificationDetails(
        'alarm_notif', 'alarm_notif',
        channelDescription: 'Channel for alarm notification',
        icon: 'launch_background',
        sound: RawResourceAndroidNotificationSound('alarm_sound'),
        importance: Importance.max,
        priority: Priority.max,
        fullScreenIntent: true,
        largeIcon: DrawableResourceAndroidBitmap('launch_background'));

    const iosChannel = DarwinNotificationDetails(
        sound: 'alarm_sound.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    const channel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      desc,
      tz.TZDateTime.parse(tz.local, notificationDateTime.toString()),
      channel,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
