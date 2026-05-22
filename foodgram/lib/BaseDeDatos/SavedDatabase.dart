import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SavedDatabase {
  static SavedDatabase? _instance;
  static Database? _db;

  SavedDatabase._();

  static Future<SavedDatabase> getInstance() async {
    _instance ??= SavedDatabase._();
    _db ??= await _instance!._openDb();
    return _instance!;
  }

  Future<Database> _openDb() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'foodgram_saved.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE saved_restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_email TEXT NOT NULL,
            restaurant_name TEXT NOT NULL,
            image_url TEXT NOT NULL,
            rating REAL NOT NULL,
            price TEXT NOT NULL,
            cuisine TEXT NOT NULL,
            time_est TEXT NOT NULL,
            distance TEXT NOT NULL,
            pending_sync INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await db.execute('''
          CREATE TABLE saved_meals (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_email TEXT NOT NULL,
            restaurant_name TEXT NOT NULL,
            dish_name TEXT NOT NULL,
            dish_image TEXT NOT NULL,
            dish_price TEXT NOT NULL,
            dish_description TEXT NOT NULL,
            pending_sync INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
  }

  // ── Restaurantes ─────────────────────────────────────────────────────────────

  Future<void> insertRestaurant(String userEmail, Restaurant r,
      {int pendingSync = 0}) async {
    await _db!.insert(
      'saved_restaurants',
      {
        'user_email': userEmail,
        'restaurant_name': r.name,
        'image_url': r.image,
        'rating': r.rating,
        'price': r.price,
        'cuisine': r.cuisine,
        'time_est': r.time,
        'distance': r.distance,
        'pending_sync': pendingSync,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteRestaurant(String userEmail, String restaurantName) async {
    await _db!.delete(
      'saved_restaurants',
      where: 'user_email = ? AND restaurant_name = ?',
      whereArgs: [userEmail, restaurantName],
    );
  }

  Future<List<Restaurant>> getRestaurants(String userEmail) async {
    final rows = await _db!.query(
      'saved_restaurants',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
    return rows.map((row) => Restaurant(
          id: '',
          name: row['restaurant_name'] as String,
          image: row['image_url'] as String,
          rating: (row['rating'] as num).toDouble(),
          price: row['price'] as String,
          cuisine: row['cuisine'] as String,
          time: row['time_est'] as String,
          distance: row['distance'] as String,
          long: 0, lat: 0,
          badge: '', badge2: '',
          numberReviews: 0,
          description: '',
          direction: '',
          spots: 0, spotsA: 0,
          tags: [],
        )).toList();
  }

  Future<bool> isRestaurantSaved(
      String userEmail, String restaurantName) async {
    final result = await _db!.query(
      'saved_restaurants',
      where: 'user_email = ? AND restaurant_name = ?',
      whereArgs: [userEmail, restaurantName],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> clearSyncedRestaurants(String userEmail) async {
    await _db!.delete(
      'saved_restaurants',
      where: 'user_email = ? AND pending_sync = ?',
      whereArgs: [userEmail, 0],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingRestaurants() async {
    return _db!.query(
      'saved_restaurants',
      where: 'pending_sync = ?',
      whereArgs: [1],
    );
  }

  Future<void> markRestaurantSynced(int id) async {
    await _db!.update(
      'saved_restaurants',
      {'pending_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Platos ───────────────────────────────────────────────────────────────────

  Future<void> insertDish(String userEmail, Menu dish,
      {int pendingSync = 0}) async {
    await _db!.insert(
      'saved_meals',
      {
        'user_email': userEmail,
        'restaurant_name': dish.restaurant,
        'dish_name': dish.name,
        'dish_image': dish.image,
        'dish_price': dish.price,
        'dish_description': dish.description,
        'pending_sync': pendingSync,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDish(
      String userEmail, String restaurantName, String dishName) async {
    await _db!.delete(
      'saved_meals',
      where: 'user_email = ? AND restaurant_name = ? AND dish_name = ?',
      whereArgs: [userEmail, restaurantName, dishName],
    );
  }

  Future<List<Menu>> getDishes(String userEmail) async {
    final rows = await _db!.query(
      'saved_meals',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
    return rows
        .map((row) => Menu.fromMap({
              'name': row['dish_name'],
              'price': row['dish_price'],
              'description': row['dish_description'],
              'image': row['dish_image'],
              'restaurant': row['restaurant_name'],
              'category': '',
            }))
        .toList();
  }

  Future<bool> isDishSaved(
      String userEmail, String restaurantName, String dishName) async {
    final result = await _db!.query(
      'saved_meals',
      where: 'user_email = ? AND restaurant_name = ? AND dish_name = ?',
      whereArgs: [userEmail, restaurantName, dishName],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> clearSyncedDishes(String userEmail) async {
    await _db!.delete(
      'saved_meals',
      where: 'user_email = ? AND pending_sync = ?',
      whereArgs: [userEmail, 0],
    );
  }

  Future<List<Map<String, dynamic>>> getPendingDishes() async {
    return _db!.query(
      'saved_meals',
      where: 'pending_sync = ?',
      whereArgs: [1],
    );
  }

  Future<void> markDishSynced(int id) async {
    await _db!.update(
      'saved_meals',
      {'pending_sync': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ── Conteo total ─────────────────────────────────────────────────────────────

  Future<int> countAll(String userEmail) async {
    final rCount = Sqflite.firstIntValue(await _db!.rawQuery(
          'SELECT COUNT(*) FROM saved_restaurants WHERE user_email = ?',
          [userEmail],
        )) ??
        0;
    final mCount = Sqflite.firstIntValue(await _db!.rawQuery(
          'SELECT COUNT(*) FROM saved_meals WHERE user_email = ?',
          [userEmail],
        )) ??
        0;
    return rCount + mCount;
  }
}
