import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:reminder_app/models/reminder_model.dart';
import 'package:reminder_app/utils/app_constants.dart';

class DatabaseService {
  static DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(AppConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${AppConstants.tableReminders} (
        ${AppConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${AppConstants.colTitle} TEXT NOT NULL,
        ${AppConstants.colContent} TEXT,
        ${AppConstants.colDateTime} TEXT NOT NULL,
        ${AppConstants.colIsAlarmEnabled} INTEGER NOT NULL,
        ${AppConstants.colRepeatType} TEXT NOT NULL,
        ${AppConstants.colCustomDays} TEXT
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.insert(AppConstants.tableReminders, reminder.toMap());
  }

  Future<Reminder?> getReminder(int id) async {
    final db = await instance.database;
    final result = await db.query(
      AppConstants.tableReminders,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Reminder.fromMap(result.first);
    }
    return null;
  }

  Future<List<Reminder>> getAllReminders() async {
    final db = await instance.database;
    final result = await db.query(AppConstants.tableReminders);
    return result.map((json) => Reminder.fromMap(json)).toList();
  }

  Future<int> updateReminder(Reminder reminder) async {
    final db = await instance.database;
    return await db.update(
      AppConstants.tableReminders,
      reminder.toMap(),
      where: '${AppConstants.colId} = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteReminder(int id) async {
    final db = await instance.database;
    return await db.delete(
      AppConstants.tableReminders,
      where: '${AppConstants.colId} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
