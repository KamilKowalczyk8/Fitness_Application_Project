import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelperFood {
  static final DatabaseHelperFood instance = DatabaseHelperFood._init();

  static Database? _database;

  DatabaseHelperFood._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('food.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        calories REAL,
        carbs REAL,
        protein REAL,
        fat REAL
      )
    ''');

    // Dodanie danych do tabeli 'food'
    await db.insert('food', {
      'name': 'Ryż biały',
      'calories': 130,
      'carbs': 28.0,
      'protein': 2.7,
      'fat': 0.3,
    });

    await db.insert('food', {
      'name': 'Piers z kurczaka',
      'calories': 165,
      'carbs': 0.0,
      'protein': 31.0,
      'fat': 3.6,
    });

    await db.insert('food', {
      'name': 'Masło orzechowe',
      'calories': 588,
      'carbs': 20.0,
      'protein': 25.0,
      'fat': 50.0,
    });
  }

  Future<List<Map<String, dynamic>>> getFoods() async {
    final db = await instance.database;
    return await db.query('food');
  }

  Future<List<String>> getFoodNames() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('food', columns: ['name']);
    return List.generate(maps.length, (i) {
      return maps[i]['name'].toString();
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
