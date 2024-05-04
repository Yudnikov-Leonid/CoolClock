import 'package:cool_clock/main.dart';
import 'package:cool_clock/timer_screen/alarm_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final _list = [
    AlarmInfo(
        DateTime.now().add(const Duration(hours: -10)), "Some desc", true),
    AlarmInfo(
        DateTime.now().add(const Duration(hours: -20)), "Some desc 2", false)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
            child: ListView(
              children: _list
                  .map((alarm) => _alarm(alarm))
                  .followedBy([_addButton()]).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _addButton() {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.blue.shade800, borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(
        animationDuration: const Duration(milliseconds: 100),
        splashColor: Colors.blue.shade900,
        onPressed: () {
          _makeAlarm('desc');
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

  Widget _alarm(AlarmInfo alarm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade700]),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.22),
                blurRadius: 8,
                spreadRadius: 4,
                offset: const Offset(4, 4))
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alarm.description,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Switch(
                    value: alarm.isPending,
                    onChanged: (value) {},
                    activeColor: Colors.white)
              ],
            ),
            const Text(
              'Date',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('hh:mm aa').format(alarm.dateTime),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 30,
                )
              ],
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
