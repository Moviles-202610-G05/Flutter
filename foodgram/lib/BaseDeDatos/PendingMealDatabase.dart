import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Almacenar los datos de comidas pendientes en SQLite
class PendingMealDatabase {
  static PendingMealDatabase? _instance;
  static Database? _db;

  PendingMealDatabase._();

  static Future<PendingMealDatabase> getInstance() async {
    _instance ??= PendingMealDatabase._();
    _db ??= await _instance!._openDb();
    return _instance!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'foodgram_pending.db'),
      version: 2,
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
        // Datos sin conexion - datos pendientes guardados como JSON con su timestamp y is_synchronized
        await db.execute('''
          CREATE TABLE pending_profile_updates (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_data_json TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            is_synchronized INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
      // agrega la tabla de perfiles sin borrar las comidas existentes por si acaso
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS pending_profile_updates (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_data_json TEXT NOT NULL,
              timestamp TEXT NOT NULL,
              is_synchronized INTEGER NOT NULL DEFAULT 0
            )
          ''');
        }
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

  // Datos sin conexion — guarda cambios de perfil mientras no hay conexión
  Future<void> insertPendingProfile(String userDataJson, String timestamp) async {
    await _db!.insert('pending_profile_updates', {
      'user_data_json': userDataJson,
      'timestamp': timestamp,
      'is_synchronized': 0,
    });
  }

  // Datos sin conexion — retorna los cambios de perfil pendientes de sincronizar
  Future<List<Map<String, dynamic>>> getPendingProfiles() async {
    return _db!.query(
      'pending_profile_updates',
      where: 'is_synchronized = ?',
      whereArgs: [0],
    );
  }

  // Datos sin conexion — marca como sincronizado despues de actualizar en Firebase
  Future<void> markProfileSynced(int id) async {
    await _db!.update(
      'pending_profile_updates',
      {'is_synchronized': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
