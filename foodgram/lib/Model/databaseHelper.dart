import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;
    
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'restaurants.db');

    _db = await openDatabase(
      path,
      version: 5,
      onUpgrade: (db, oldVersion, newVersion) async {
       await db.execute('DROP TABLE IF EXISTS restaurants');
       await db.execute('''
          CREATE TABLE restaurants (
                id TEXT PRIMARY KEY,
                name TEXT,
                image TEXT,
                rating REAL,
                price TEXT,
                cuisine TEXT,
                time TEXT,
                distance TEXT,
                long REAL,
                lat REAL,
                badge TEXT,
                badge2 TEXT,
                numberReviews INTEGER,
                description TEXT,
                direction TEXT,
                spots INTEGER,
                spotsA INTEGER,
                tags TEXT
          )
        ''');
        
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE restaurants (
                id TEXT PRIMARY KEY,
                name TEXT,
                image TEXT,
                rating REAL,
                price TEXT,
                cuisine TEXT,
                time TEXT,
                distance TEXT,
                long REAL,
                lat REAL,
                badge TEXT,
                badge2 TEXT,
                numberReviews INTEGER,
                description TEXT,
                direction TEXT,
                spots INTEGER,
                spotsA INTEGER,
                tags TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  // Guarda o actualiza todos los restaurantes
  static Future<void> guardarRestaurantes(List<Map<String, dynamic>> restaurants) async {
    final db = await getDatabase();
    final batch = db.batch();
    
    for (final r in restaurants) {
      batch.insert(
        'restaurants',
        r,
        conflictAlgorithm: ConflictAlgorithm.replace, // actualiza si ya existe
      );
    }
    await batch.commit(noResult: true);
  }

  // Lee todos los restaurantes guardados
  static Future<List<Map<String, dynamic>>> obtenerRestaurantes() async {
    final db = await getDatabase();
    final result = await db.query('restaurants');
    print("Datos en SQLite: $result"); 
    return result;
  }
}