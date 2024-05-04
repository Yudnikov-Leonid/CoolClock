class AlarmInfo {
  int id;
  String title;
  DateTime dateTime;
  bool isPending;

  AlarmInfo(this.id, this.title, this.dateTime, this.isPending);

  //todo const
  factory AlarmInfo.fromMap(Map<String, dynamic> json) =>
      AlarmInfo(json['id'], json['title'], DateTime.parse(json['dateTime']), json['isPending']);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dateTime': dateTime.toIso8601String(),
    'isPending': isPending
  };
}
