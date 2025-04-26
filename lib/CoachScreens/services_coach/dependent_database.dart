import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:fitness1945/CoachScreens/CoachModel/dependent.model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'dependent.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE dependents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        ageOrDob TEXT,
        status TEXT,
        levelOrGoal TEXT,
        contact TEXT
      )
    ''');
  }

  Future<void> insertDependent(Dependent dependent) async {
    final db = await database;
    await db.insert(
      'dependents',
      dependent.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateDependent(Dependent dependent) async {
    final db = await database;
    await db.update(
      'dependents',
      dependent.toMap(),
      where: 'id = ?',
      whereArgs: [dependent.id],
    );
  }

  Future<List<Dependent>> getDependents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dependents');
    return maps.map((map) => Dependent.fromMap(map)).toList();
  }

  Future<void> deleteDependent(int id) async {
    final db = await database;
    await db.delete(
      'dependents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
