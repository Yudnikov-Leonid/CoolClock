import 'package:flutter/material.dart';

class AlarmInfo {
  int? id;
  String title;
  TimeOfDay timeOfDay;
  List<int> days;
  bool isPending;

  AlarmInfo(
      {this.id,
      required this.title,
      required this.timeOfDay,
      required this.days,
      required this.isPending});

  //todo const
  factory AlarmInfo.fromMap(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dateTime']);
    return AlarmInfo(
        id: json['id'],
        title: json['title'],
        timeOfDay: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        days: json['days'].split('|').map<int>((e) => int.parse(e)).toList(),
        isPending: json['isPending'] == 1);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': DateTime(2000, 1, 1, timeOfDay.hour, timeOfDay.minute).toIso8601String(),
        'days': days.join('|'),
        'isPending': isPending ? 1 : 0
      };
}
