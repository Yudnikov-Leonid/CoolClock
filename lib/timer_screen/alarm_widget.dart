import 'package:cool_clock/alarm_helper.dart';
import 'package:cool_clock/timer_screen/alarm_info.dart';
import 'package:cool_clock/timer_screen/edit_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmWidget extends StatefulWidget {
  final AlarmInfo _alarm;
  final AlarmHelper _alarmHelper;
  final Function() _loadAlarms;

  const AlarmWidget(this._alarm, this._alarmHelper, this._loadAlarms,
      {super.key});

  @override
  State<AlarmWidget> createState() => _AlarmWidgetState();
}

class _AlarmWidgetState extends State<AlarmWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        editAlarmBottomSheet(context, widget._alarmHelper, widget._loadAlarms, alarm: widget._alarm);
      },
      child: Container(
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
                    widget._alarm.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Switch(
                      value: widget._alarm.isPending,
                      onChanged: (value) async {
                        await widget._alarmHelper
                            .update(widget._alarm.changePending());
                        widget._loadAlarms();
                      },
                      activeColor: Colors.white)
                ],
              ),
              Text(
                widget._alarm.days
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
                    widget._alarm.timeOfDay.format(context),
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
                      await widget._alarmHelper.delete(widget._alarm.id!);
                      widget._loadAlarms();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
