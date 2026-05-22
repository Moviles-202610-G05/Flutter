import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:foodgram/BaseDeDatos/SavedDatabase.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/SavedRepository.dart';

abstract class SavedView {
  void mostrarRestaurantesSaved(List<Restaurant> restaurantes);
  void mostrarPlatosSaved(List<Menu> platos);
  void mostrarConteo(int total);
  void mostrarError(String mensaje);
  void actualizarEstadoRestaurante(String restaurantName, bool isSaved);
  void actualizarEstadoPlato(String dishName, bool isSaved);
}

class SavedPresenter {
  final SavedView view;
  final SavedRepository _repository;
  final SavedDatabase _db;
  final RestaurantRepository _restaurantRepo;
  final MenuRepository _menuRepo;

  // Estrategia 2 — caché en memoria
  List<Restaurant>? _cachedRestaurants;
  List<Menu>? _cachedDishes;

  SavedPresenter(this.view, this._repository, this._db)
      : _restaurantRepo = RestaurantRepository(),
        _menuRepo = MenuRepository();

  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void _invalidateCache() {
    _cachedRestaurants = null;
    _cachedDishes = null;
  }

  // ── Cargar lista completa ─────────────────────────────────────────────────────

  Future<void> cargarGuardados(String userEmail) async {
    if (userEmail.isEmpty) {
      view.mostrarRestaurantesSaved([]);
      view.mostrarPlatosSaved([]);
      return;
    }

    // Caché hit
    if (_cachedRestaurants != null && _cachedDishes != null) {
      view.mostrarRestaurantesSaved(_cachedRestaurants!);
      view.mostrarPlatosSaved(_cachedDishes!);
      return;
    }

    try {
      if (await _hasInternet()) {
        // Obtener referencias ligeras de Firestore (una sola query)
        final refs = await _repository.getSavedRefs(userEmail);

        final restaurantRefs = refs
            .where((r) => r['type'] == 'restaurant')
            .map((r) => r['restaurantName'] as String)
            .toList();

        final dishRefs = refs.where((r) => r['type'] == 'dish').toList();

        // Fetch Restaurant objects usando el repositorio existente (LRU cache included)
        final restaurants = <Restaurant>[];
        for (final name in restaurantRefs) {
          try {
            final r = await _restaurantRepo.restaurante(name);
            restaurants.add(r);
          } catch (_) {}
        }

        // Fetch Menu objects agrupando por restaurante
        final dishes = <Menu>[];
        final dishRestaurantNames =
            dishRefs.map((r) => r['restaurantName'] as String).toSet();
        for (final restName in dishRestaurantNames) {
          try {
            final allDishes =
                await _menuRepo.todosMenuRestaurante(restName);
            final wantedNames = dishRefs
                .where((r) => r['restaurantName'] == restName)
                .map((r) => r['dishName'] as String)
                .toSet();
            dishes.addAll(allDishes.where((d) => wantedNames.contains(d.name)));
          } catch (_) {}
        }

        // Actualizar SQLite eliminando los sinced y reinsertando frescos
        await _db.clearSyncedRestaurants(userEmail);
        await _db.clearSyncedDishes(userEmail);
        for (final r in restaurants) {
          await _db.insertRestaurant(userEmail, r);
        }
        for (final d in dishes) {
          await _db.insertDish(userEmail, d);
        }

        _cachedRestaurants = restaurants;
        _cachedDishes = dishes;
      } else {
        // Sin internet — leer desde SQLite
        _cachedRestaurants = await _db.getRestaurants(userEmail);
        _cachedDishes = await _db.getDishes(userEmail);
      }

      view.mostrarRestaurantesSaved(_cachedRestaurants!);
      view.mostrarPlatosSaved(_cachedDishes!);
    } catch (e) {
      view.mostrarError('Error al cargar guardados: $e');
    }
  }

  // ── Toggle restaurante ────────────────────────────────────────────────────────

  Future<void> toggleSaveRestaurant(
      String userEmail, Restaurant restaurant) async {
    if (userEmail.isEmpty) return;
    try {
      final isSaved =
          await _db.isRestaurantSaved(userEmail, restaurant.name);

      if (isSaved) {
        await _db.deleteRestaurant(userEmail, restaurant.name);
        if (await _hasInternet()) {
          await _repository.unsaveRestaurant(userEmail, restaurant.name);
        }
        view.actualizarEstadoRestaurante(restaurant.name, false);
      } else {
        final online = await _hasInternet();
        await _db.insertRestaurant(userEmail, restaurant,
            pendingSync: online ? 0 : 1);
        if (online) {
          await _repository.saveRestaurant(userEmail, restaurant.name);
        }
        view.actualizarEstadoRestaurante(restaurant.name, true);
      }

      _invalidateCache();
    } catch (e) {
      view.mostrarError('Error al guardar restaurante: $e');
    }
  }

  // ── Toggle plato ──────────────────────────────────────────────────────────────

  Future<void> toggleSaveDish(String userEmail, Menu dish) async {
    if (userEmail.isEmpty) return;
    try {
      final isSaved =
          await _db.isDishSaved(userEmail, dish.restaurant, dish.name);

      if (isSaved) {
        await _db.deleteDish(userEmail, dish.restaurant, dish.name);
        if (await _hasInternet()) {
          await _repository.unsaveDish(
              userEmail, dish.restaurant, dish.name);
        }
        view.actualizarEstadoPlato(dish.name, false);
      } else {
        final online = await _hasInternet();
        await _db.insertDish(userEmail, dish, pendingSync: online ? 0 : 1);
        if (online) {
          await _repository.saveDish(
              userEmail, dish.restaurant, dish.name);
        }
        view.actualizarEstadoPlato(dish.name, true);
      }

      _invalidateCache();
    } catch (e) {
      view.mostrarError('Error al guardar plato: $e');
    }
  }

  // ── Eliminar desde la pantalla Saved (unsave directo por nombre) ───────────────

  Future<void> removeSavedRestaurant(
      String userEmail, String restaurantName) async {
    if (userEmail.isEmpty) return;
    try {
      await _db.deleteRestaurant(userEmail, restaurantName);
      if (await _hasInternet()) {
        await _repository.unsaveRestaurant(userEmail, restaurantName);
      }
      _invalidateCache();
      view.actualizarEstadoRestaurante(restaurantName, false);
    } catch (e) {
      view.mostrarError('Error al eliminar restaurante guardado: $e');
    }
  }

  Future<void> removeSavedDish(
      String userEmail, String restaurantName, String dishName) async {
    if (userEmail.isEmpty) return;
    try {
      await _db.deleteDish(userEmail, restaurantName, dishName);
      if (await _hasInternet()) {
        await _repository.unsaveDish(userEmail, restaurantName, dishName);
      }
      _invalidateCache();
      view.actualizarEstadoPlato(dishName, false);
    } catch (e) {
      view.mostrarError('Error al eliminar plato guardado: $e');
    }
  }

  // ── Conteo para pantalla de perfil ────────────────────────────────────────────

  Future<void> cargarConteo(String userEmail) async {
    if (userEmail.isEmpty) {
      view.mostrarConteo(0);
      return;
    }
    try {
      final count = await _db.countAll(userEmail);
      view.mostrarConteo(count);
    } catch (_) {
      view.mostrarConteo(0);
    }
  }

  // ── Estado inicial para pantalla de detalle ───────────────────────────────────

  Future<void> cargarEstadoInicial(
    String userEmail,
    String restaurantName,
    List<String> dishNames,
  ) async {
    if (userEmail.isEmpty) return;
    try {
      final rSaved =
          await _db.isRestaurantSaved(userEmail, restaurantName);
      view.actualizarEstadoRestaurante(restaurantName, rSaved);

      for (final name in dishNames) {
        final dSaved =
            await _db.isDishSaved(userEmail, restaurantName, name);
        view.actualizarEstadoPlato(name, dSaved);
      }
    } catch (_) {}
  }
}
