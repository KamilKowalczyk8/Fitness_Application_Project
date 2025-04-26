import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:fitness1945/CoachScreens/CoachModel/trainingdependent.model.dart';

class TrainingDatabaseDependent {
  TrainingDatabaseDependent._privateConstructor();
  static final TrainingDatabaseDependent instance = TrainingDatabaseDependent._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'trainingdependent.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE trainings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dependentId INTEGER,
        name TEXT,
        duration INTEGER
      )
    ''');
  }

  Future<void> insertTraining(TrainingDependent training) async {
    final db = await database;
    await db.insert(
      'trainings',
      training.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TrainingDependent>> getTrainingsForDependent(int dependentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'trainings',
      where: 'dependentId = ?',
      whereArgs: [dependentId],
    );
    return maps.map((map) => TrainingDependent.fromMap(map)).toList();
  }
}
