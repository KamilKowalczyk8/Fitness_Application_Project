import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness.db');
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
    CREATE TABLE trening (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      date TEXT
    )
  ''');

    await db.execute('''
     CREATE TABLE excersise ( 
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    trening_id INTEGER, 
    name TEXT, 
    sets INTEGER, 
    reps INTEGER, 
    FOREIGN KEY (trening_id) REFERENCES trening (id) 
  )
    ''');
    print("Baza danych stworzona: tabele 'trening', 'excersise'");
  }
}
