import 'package:cool_clock/timer_screen/alarm_info.dart';
import 'package:sqflite/sqflite.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'dateTime';
final String columnDays = 'days';
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
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final dir = await getDatabasesPath();
    final path = '${dir}alarm.db';

    final database =
        await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute('''
      create table $tableAlarm (  
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnDateTime text not null,
        $columnDays text not null,
        $columnPending integer
        )
''');
    });
    return database;
  }

  Future<void> insertAlarm(AlarmInfo alarm) async {
    final db = await database;
    db.insert(tableAlarm, alarm.toJson());
  }

  Future<List<AlarmInfo>> getAlarms() async {
    final db = await database;
    final result = await db.query(tableAlarm);
    return result.map((json) => AlarmInfo.fromMap(json)).toList();
  }

  Future<void> delete(int id) async {
    final db = await database;
    db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  }
}
