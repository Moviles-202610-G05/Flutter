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
  version: 8,
  onUpgrade: (db, oldVersion, newVersion) async {
    await db.execute('DROP TABLE IF EXISTS restaurants');
    await db.execute('DROP TABLE IF EXISTS posts');

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

    await db.execute('''
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        userName TEXT,
        image TEXT,
        color TEXT,
        description TEXT,
        likes REAL,
        comments REAL,
        tags TEXT,
        towComents TEXT,
        restaurantName TEXT,
        email TEXT

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

    await db.execute(''' 
      CREATE TABLE posts (
        id TEXT PRIMARY KEY,
        userName TEXT,
        image TEXT,
        color TEXT,
        description TEXT,
        likes REAL,
        comments REAL,
        tags TEXT,
        towComents TEXT,
        restaurantName TEXT,
        email TEXT
      )
    ''');
  },
);

return _db!;
}


  // Lee todos los restaurantes guardados
  static Future<List<Map<String, dynamic>>> obtenerRestaurantes() async {
    final db = await getDatabase();
    final result = await db.query('restaurants');
    print("Datos en SQLite: $result"); 
    return result;
  }

  // Lee todos los restaurantes guardados
  static Future<List<Map<String, dynamic>>> obtenerPosts() async {
    final db = await getDatabase();
    final result = await db.query('posts');
    print("Datos en SQLite: $result"); 
    return result;
  }
}