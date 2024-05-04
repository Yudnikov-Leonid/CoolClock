import 'package:cool_clock/timer_screen/alarm_info.dart';
import 'package:sqflite/sqflite.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'dateTime';
final String columnPending = 'isPending';

class AlarmHelper {
  static Database? _database = null;
  static AlarmHelper? _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    _alarmHelper ??= AlarmHelper._createInstance();
    return _alarmHelper!;
  }

  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dir = await getDatabasesPath();
    final path = '${dir}alarm.db';

    final database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
      create table $tableAlarm (  
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnDateTime text not null,
        $columnPending integer)
''');
    });
    return database;
  }

  void insertAlarm(AlarmInfo alarm) async {
    final db = await this.database;
    db.insert(tableAlarm, alarm.toJson());
  }
}
