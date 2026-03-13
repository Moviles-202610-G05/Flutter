import 'package:flutter/material.dart';

class SavedUserScreen extends StatefulWidget {
  const SavedUserScreen({super.key});

  @override
  State<SavedUserScreen> createState() => _SavedUserScreenState();
}

class _SavedUserScreenState extends State<SavedUserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Datos restaurantes ────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'The Green Garden',
      'rating': 4.8,
      'reviews': '120+',
      'category': 'Healthy',
      'distance': '1.2 mi',
      'price': r'$$',
      'color': Color(0xFFB8C4C2),
    },
    {
      'name': 'Urban Crave',
      'rating': 4.5,
      'reviews': '85',
      'category': 'Burgers',
      'distance': '0.8 mi',
      'price': r'$$$',
      'color': Color(0xFFA8B8A0),
    },
    {
      'name': 'Sushi Master',
      'rating': 4.9,
      'reviews': '342',
      'category': 'Japanese',
      'distance': '2.5 mi',
      'price': r'$$$$',
      'color': Color(0xFFD4B896),
    },
    {
      'name': 'Pasta House',
      'rating': 4.2,
      'reviews': '56',
      'category': 'Italian',
      'distance': '3.0 mi',
      'price': r'$$',
      'color': Color(0xFF8A9E8C),
    },
  ];

  // ── Datos platos ──────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _meals = [
    {
      'name': 'Truffle Mac & Cheese',
      'restaurant': 'The Golden Whisk',
      'rating': 4.9,
      'price': r'$$',
      'color': Color(0xFFA8B8A0),
    },
    {
      'name': 'Spicy Tuna Roll',
      'restaurant': 'Sushi Master',
      'rating': 4.8,
      'price': r'$$$',
      'color': Color(0xFFD4B896),
    },
    {
      'name': 'Carbonara Deluxe',
      'restaurant': 'Pasta House',
      'rating': 4.7,
      'price': r'$$',
      'color': Color(0xFF7A9490),
    },
    {
      'name': 'Double Smash Burger',
      'restaurant': 'Urban Crave',
      'rating': 4.6,
      'price': r'$$',
      'color': Color(0xFFD0D4DC),
      'icon': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F0EB),
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
      body: NotificationListener<OverscrollIndicatorNotification>(
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

  // ── Lista restaurantes ────────────────────────────────────────────────────
  Widget _buildRestaurantsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _restaurants.length,
      itemBuilder: (context, index) {
        final r = _restaurants[index];
        return _RestaurantCard(data: r);
      },
    );
  }

  // ── Lista platos ──────────────────────────────────────────────────────────
  Widget _buildMealsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final m = _meals[index];
        return _MealCard(data: m);
      },
    );
  }
}

// ── Tarjeta Restaurante ───────────────────────────────────────────────────────
class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 90,
              height: 90,
              color: data['color'] as Color,
              child: data['icon'] == true
                  ? const Icon(Icons.restaurant_menu,
                      color: Colors.white54, size: 32)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const Icon(Icons.bookmark_rounded,
                        color: Color(0xFFFF6347), size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB300), size: 15),
                    const SizedBox(width: 3),
                    Text(
                      '${data['rating']} (${data['reviews']})',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    const Text('•',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      data['category'],
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
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
                      '${data['distance']}  •  ${data['price']}',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta Plato ─────────────────────────────────────────────────────────────
class _MealCard extends StatelessWidget {
  const _MealCard({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 90,
              height: 90,
              color: data['color'] as Color,
              child: data['icon'] == true
                  ? const Icon(Icons.lunch_dining_rounded,
                      color: Colors.grey, size: 32)
                  : null,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(Icons.bookmark_rounded,
                        color: Color(0xFFFF6347), size: 20),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data['restaurant'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFFFB300), size: 15),
                    const SizedBox(width: 3),
                    Text(
                      '${data['rating']}',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Text('•',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(width: 8),
                    Text(
                      data['price'],
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}