import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperDieta {
  static final DatabaseHelperDieta instance = DatabaseHelperDieta._init();

  static Database? _database;

  DatabaseHelperDieta._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 2, onCreate: _createDB, onUpgrade: _upgradeDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE person (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      gender TEXT,
      activity_level INTEGER,
      height REAL,
      weight REAL,
      calorieRequirement REAL,
      protein REAL,
      carbs REAL,
      fats REAL
    )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
      ALTER TABLE person ADD COLUMN calorieRequirement REAL;
      ''');
      await db.execute('''
      ALTER TABLE person ADD COLUMN protein REAL;
      ''');
      await db.execute('''
      ALTER TABLE person ADD COLUMN carbs REAL;
      ''');
      await db.execute('''
      ALTER TABLE person ADD COLUMN fats REAL;
      ''');
    }
  }

  Future<int> insertPerson(Map<String, dynamic> person) async {
    final db = await instance.database;
    return await db.insert('person', person);
  }

  Future<int> updatePerson(Map<String, dynamic> person) async {
    final db = await instance.database;
    int id = person['id'];
    return await db.update('person', person, where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
