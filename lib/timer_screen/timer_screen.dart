import 'package:cool_clock/alarm_helper.dart';
import 'package:cool_clock/main.dart';
import 'package:cool_clock/timer_screen/alarm_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                        .map((alarm) => _alarm(alarm))
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
          _newAlarmBottomSheet();
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

  void _newAlarmBottomSheet() {
    TimeOfDay selectedTime = TimeOfDay.now();
    List<bool> selectedDays = List.generate(7, (_) => true);
    TextEditingController titleController = TextEditingController();
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                height: 600,
                width: double.infinity,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? timeOfDay = await showTimePicker(
                            context: context, initialTime: selectedTime);
                        if (timeOfDay != null) {
                          setState(() {
                            selectedTime = timeOfDay;
                          });
                        }
                      },
                      child: Text(
                        '${selectedTime.hour}:${selectedTime.minute}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    TextField(
                      controller: titleController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(hintText: 'Title'),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ToggleButtons(
                      isSelected: selectedDays,
                      onPressed: (index) {
                        setState(() {
                          selectedDays[index] = !selectedDays[index];
                        });
                      },
                      color: Colors.black,
                      selectedColor: Colors.grey.shade900,
                      fillColor: Colors.blue.shade100,
                      splashColor: Colors.transparent,
                      renderBorder: false,
                      children: const [
                        'MON',
                        'TUE',
                        "WED",
                        "THU",
                        'FRI',
                        'SAT',
                        'SUN'
                      ]
                          .map((text) => Text(text,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)))
                          .toList(),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextButton(
                        onPressed: () async {
                          List<int> days = [];
                          selectedDays.asMap().forEach((index, element) {
                            if (element) {
                              days.add(index);
                            }
                          });
                          final info = AlarmInfo(
                              title: titleController.text,
                              timeOfDay: selectedTime,
                              days: days,
                              isPending: true);
                          await _alarmHelper.insertAlarm(info);
                          _loadAlarms();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Save'))
                  ],
                ),
              );
            },
          );
        });
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
                  alarm.title,
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
            Text(
              alarm.days
                  .map((int e) {
                    String day = '';
                    switch (e) {
                      case 0:
                        day = 'MON';
                        case 1:
                        day = 'TUE';
                        case 2:
                        day = 'WED';
                        case 3:
                        day = 'THU';
                        case 4:
                        day = 'FRI';
                        case 5:
                        day = 'SAT';
                        case 6:
                        day = 'SUN';
                    }
                    return day;
                  })
                  .toList()
                  .join(', '),
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  alarm.timeOfDay.format(context),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () async {
                    await _alarmHelper.delete(alarm.id!);
                    _loadAlarms();
                  },
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
