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
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
      onOpen: (db) async {
        var result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'");
        if (result.isEmpty) {
          await _createDB(db, 2); // Utwórz tabelę, jeśli nie istnieje
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS trening (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      description TEXT,
      date TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS exercise ( 
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      training_id INTEGER, 
      name TEXT, 
      sets INTEGER, 
      reps INTEGER, 
      weight REAL DEFAULT 0, 
      weight_unit TEXT DEFAULT 'kg', 
      FOREIGN KEY (training_id) REFERENCES trening (id)
    )
  ''');
    print("Baza danych stworzona: tabele 'trening', 'exercise'");
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      var result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='exercise'");
      if (result.isNotEmpty) {
        await db.execute('ALTER TABLE exercise ADD COLUMN weight REAL DEFAULT 0;');
        await db.execute('ALTER TABLE exercise ADD COLUMN weight_unit TEXT DEFAULT \'kg\';');
        print("Baza danych zaktualizowana: dodane kolumny 'weight' i 'weight_unit' do tabeli 'exercise'");
      } else {
        print("Tabela 'exercise' nie istnieje");
      }
    }
  }
}
