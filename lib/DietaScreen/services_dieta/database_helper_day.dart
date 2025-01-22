import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper_dieta.dart' as dbDietaHelper;

class DatabaseHelperDay {
  static final DatabaseHelperDay instance = DatabaseHelperDay._init();

  static Database? _database;

  DatabaseHelperDay._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('dieta.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS person (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calorieRequirement REAL,
        protein REAL,
        carbs REAL,
        fats REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS days (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        calorieRequirement REAL,
        protein REAL,
        carbs REAL,
        fats REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS meals (
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

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Dodajemy nowe kolumny do tabeli 'days'
      await db.execute("ALTER TABLE days ADD COLUMN calorieRequirement REAL;");
      await db.execute("ALTER TABLE days ADD COLUMN protein REAL;");
      await db.execute("ALTER TABLE days ADD COLUMN carbs REAL;");
      await db.execute("ALTER TABLE days ADD COLUMN fats REAL;");
    }
  }

  Future<int> addDay(Map<String, dynamic> dayData) async {
    final db = await instance.database;

    final personData = await db.query('person');
    if (personData.isNotEmpty) {
      final person = personData.first;
      dayData['calorieRequirement'] = person['calorieRequirement'];
      dayData['protein'] = person['protein'];
      dayData['carbs'] = person['carbs'];
      dayData['fats'] = person['fats'];
    }

    final existingDays = await db.query(
      'days',
      where: 'date = ?',
      whereArgs: [dayData['date']],
    );

    if (existingDays.isNotEmpty) {
      return (existingDays.first['id'] as int?) ?? 0;
    }

    return await db.insert('days', dayData);
  }

  Future<List<Map<String, dynamic>>> getDays() async {
    final db = await instance.database;
    return await db.query('days');
  }

  Future<List<Map<String, dynamic>>> getMealsForDay(String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> days = await db.query(
      'days',
      where: 'date = ?',
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

  Future<int> addMeal(Map<String, dynamic> meal) async {
    final db = await instance.database;
    return await db.insert('meals', meal);
  }

  Future<void> deleteMeal(int id) async {
    final db = await instance.database;
    await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateExistingRecords() async {
    final db = await instance.database;
    final personData = await db.query('person');
    if (personData.isNotEmpty) {
      final person = personData.first;
      await db.rawUpdate('''
        UPDATE days SET
          calorieRequirement = ?,
          protein = ?,
          carbs = ?,
          fats = ?
        WHERE calorieRequirement IS NULL;
      ''', [
        person['calorieRequirement'],
        person['protein'],
        person['carbs'],
        person['fats']
      ]);
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
