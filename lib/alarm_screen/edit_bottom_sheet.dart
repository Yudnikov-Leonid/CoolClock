import 'package:cool_clock/alarm_screen/alarm_helper.dart';
import 'package:cool_clock/alarm_screen/alarm_info.dart';
import 'package:flutter/material.dart';

void editAlarmBottomSheet(
    BuildContext context, AlarmHelper alarmHelper, Function() loadAlarms,
    {AlarmInfo? alarm}) {
  TimeOfDay selectedTime = alarm?.timeOfDay ?? TimeOfDay.now();
  List<bool> selectedDays;
  if (alarm != null) {
    selectedDays = List.generate(7, (_) => false);
    alarm.days.forEach((element) {
      selectedDays[element] = true;
    });
  } else {
    selectedDays = List.generate(7, (_) => true);
  }
  TextEditingController titleController =
      TextEditingController(text: alarm?.title);

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blue.shade300],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
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
                      '${selectedTime.hour < 10 ? '0${selectedTime.hour}' : selectedTime.hour}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                    ),
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
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    selectedColor: Colors.blue.shade900,
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
                            id: alarm?.id,
                            title: titleController.text,
                            timeOfDay: selectedTime,
                            days: days,
                            isPending: alarm?.isPending ?? true);
                        if (alarm == null) {
                          await alarmHelper.insertAlarm(info);
                        } else {
                          await alarmHelper.update(info);
                        }
                        loadAlarms();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            );
          },
        );
      });
}
