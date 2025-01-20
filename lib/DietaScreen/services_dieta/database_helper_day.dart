import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperDay {
  static final DatabaseHelperDay instance = DatabaseHelperDay._init();

  static Database? _database;

  DatabaseHelperDay._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('days.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE days (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      calorieRequirement REAL,
      protein REAL,
      carbs REAL,
      fats REAL
    )
    ''');

    await db.execute('''
    CREATE TABLE meals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      dayId INTEGER,
      mealTime TEXT,
      mealWeight TEXT,
      mealType TEXT,
      calories REAL,
      carbs REAL,
      protein REAL,
      fat REAL,
      FOREIGN KEY (dayId) REFERENCES days (id) ON DELETE CASCADE
    )
    ''');
  }

  Future<int> addMeal(Map<String, dynamic> meal) async {
    final db = await instance.database;
    return await db.insert('meals', meal);
  }

  Future<List<Map<String, dynamic>>> getMealsForDay(String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> days = await db.query(
      'days',
      where: 'date LIKE ?',
      whereArgs: [date],
    );

    if (days.isNotEmpty) {
      final dayId = days.first['id'];
      return await db.query(
        'meals',
        where: 'dayId = ?',
        whereArgs: [dayId],
      );
    }
    return [];
  }

  Future<void> updateExistingRecords() async {
    final db = await instance.database;
    await db.rawUpdate('''
    UPDATE days SET calorieRequirement = 2000.0, protein = 150.0, carbs = 250.0, fats = 70.0 WHERE calorieRequirement IS NULL;
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
