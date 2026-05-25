import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodgram/BaseDeDatos/SavedDatabase.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/SavedRepository.dart';
import 'package:foodgram/Presenter/SavedPresenter.dart';
import 'package:foodgram/View/restaurant_detalle_screen.dart';

class SavedUserScreen extends StatefulWidget {
  const SavedUserScreen({super.key});

  @override
  State<SavedUserScreen> createState() => _SavedUserScreenState();
}

class _SavedUserScreenState extends State<SavedUserScreen>
    with SingleTickerProviderStateMixin
    implements SavedView {
  late TabController _tabController;
  SavedPresenter? _presenter;

  List<Restaurant> _restaurants = [];
  List<Menu> _meals = [];
  bool _isLoading = true;
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _userEmail = FirebaseAuth.instance.currentUser?.email?.trim() ?? '';
    SavedDatabase.getInstance().then((db) {
      if (!mounted) return;
      _presenter = SavedPresenter(this, SavedRepository(), db);
      _presenter!.cargarGuardados(_userEmail);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── SavedView ─────────────────────────────────────────────────────────────────

  @override
  void mostrarRestaurantesSaved(List<Restaurant> restaurantes) {
    if (!mounted) return;
    setState(() {
      _restaurants = restaurantes;
      _isLoading = false;
    });
  }

  @override
  void mostrarPlatosSaved(List<Menu> platos) {
    if (!mounted) return;
    setState(() {
      _meals = platos;
      _isLoading = false;
    });
  }

  @override
  void mostrarConteo(int total) {}

  @override
  void mostrarError(String mensaje) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void actualizarEstadoRestaurante(String restaurantName, bool isSaved) {}

  @override
  void actualizarEstadoPlato(String dishName, bool isSaved) {}

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFFFF6347),
              size: 18,
            ),
          ),
        ),
        title: const Text(
          'Saved',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFFFF6347),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFFFF6347),
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              tabs: const [
                Tab(text: 'Restaurants'),
                Tab(text: 'Meals'),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6347)))
          : NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRestaurantsList(),
                  _buildMealsList(),
                ],
              ),
            ),
    );
  }

  // ── Listas ────────────────────────────────────────────────────────────────────

  Widget _buildRestaurantsList() {
    if (_restaurants.isEmpty) {
      return const Center(
        child: Text(
          'No saved restaurants yet.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _restaurants.length,
      itemBuilder: (context, index) {
        final r = _restaurants[index];
        return _RestaurantCard(
          data: r,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(rest: r.name),
              ),
            );
            _presenter?.recargarGuardados(_userEmail);
          },
          onUnsave: () async {
            await _presenter?.removeSavedRestaurant(_userEmail, r.name);
            await _presenter?.cargarGuardados(_userEmail);
          },
        );
      },
    );
  }

  Widget _buildMealsList() {
    if (_meals.isEmpty) {
      return const Center(
        child: Text(
          'No saved meals yet.',
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final dish = _meals[index];
        return _MealCard(
          data: dish,
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RestaurantDetailScreen(rest: dish.restaurant),
              ),
            );
            _presenter?.recargarGuardados(_userEmail);
          },
          onUnsave: () async {
            await _presenter?.removeSavedDish(
                _userEmail, dish.restaurant, dish.name);
            await _presenter?.cargarGuardados(_userEmail);
          },
        );
      },
    );
  }
}

// ── Tarjeta Restaurante ───────────────────────────────────────────────────────

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.data,
    required this.onTap,
    required this.onUnsave,
  });

  final Restaurant data;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: data.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFB8C4C2),
                  child: const Icon(Icons.restaurant_menu,
                      color: Colors.white54, size: 32),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFB8C4C2),
                  child: const Icon(Icons.restaurant_menu,
                      color: Colors.white54, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onUnsave,
                        child: const Icon(Icons.bookmark_rounded,
                            color: Color(0xFFFF6347), size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFFFB300), size: 15),
                      const SizedBox(width: 3),
                      Text(
                        data.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 6),
                      const Text('•',
                          style:
                              TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(width: 6),
                      Text(
                        data.cuisine,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 13, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(
                        '${data.distance}  •  ${data.price}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tarjeta Plato ─────────────────────────────────────────────────────────────

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.data,
    required this.onTap,
    required this.onUnsave,
  });

  final Menu data;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CachedNetworkImage(
                imageUrl: data.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFA8B8A0),
                  child: const Icon(Icons.lunch_dining_rounded,
                      color: Colors.white54, size: 32),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 90,
                  height: 90,
                  color: const Color(0xFFA8B8A0),
                  child: const Icon(Icons.lunch_dining_rounded,
                      color: Colors.white54, size: 32),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          data.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: onUnsave,
                        child: const Icon(Icons.bookmark_rounded,
                            color: Color(0xFFFF6347), size: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.restaurant,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${data.price}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF6347),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
