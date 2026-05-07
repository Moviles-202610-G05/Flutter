import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Almacenar los datos de comidas pendientes en SQLite
class PendingDatabase {
  static PendingDatabase? _instance;
  static Database? _db;

  PendingDatabase._();

  static Future<PendingDatabase> getInstance() async {
    _instance ??= PendingDatabase._();
    _db ??= await _instance!._openDb();
    return _instance!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'foodgram_pending.db'),
      version: 1,
      onCreate: (db, version) async {
        // IA sin conexion - comidas pendiente guardadas con imagen base64, timestamp y is_synchronized
        await db.execute('''
          CREATE TABLE pending_meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            image_base64 TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            is_synchronized INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // IA sin conexion — inserta la fotos subidas offline
  Future<void> insert(String imageBase64, String timestamp) async {
    await _db!.insert('pending_meals', {
      'image_base64': imageBase64,
      'timestamp': timestamp,
      'is_synchronized': 0,
    });
  }

  // IA sin conexion  — retorna las fotos que no han sido procesadas por la IA
  Future<List<Map<String, dynamic>>> getPending() async {
    return _db!.query(
      'pending_meals',
      where: 'is_synchronized = ?',
      whereArgs: [0],
    );
  }

  // IA sin conexion — marca como sincronizada despues de ser procesadas
  Future<void> markSynced(int id) async {
    await _db!.update(
      'pending_meals',
      {'is_synchronized': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
