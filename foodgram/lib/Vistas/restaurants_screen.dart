import 'package:flutter/material.dart';
import 'package:foodgram/Model/Restaurant.dart';
import 'package:foodgram/Vistas/pagesInsideStudent.dart' show Pages, PagesState;
import 'package:foodgram/Vistas/restaurant_detalle_screen.dart';

class RestaurantFeed extends StatefulWidget {
  const RestaurantFeed({super.key});

  @override
  State<RestaurantFeed> createState() => _RestaurantFeed();
}

class _RestaurantFeed extends State<RestaurantFeed> {
  static const Color primary = Color(0xFFFF6933);
  int selectedCategory = 0;
  final Set<int> favorites = {};

  final categories = const ['Italian', 'Mexican', 'Fast Food'];

  final List<Map<String, dynamic>> featured = const [
    {
      'name': 'Oasis Garden',
      'rating': 4.9,
      'image':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
    },
    {
      'name': 'Steakhouse',
      'rating': 4.7,
      'image':
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=1200',
    },
  ];
  late List<Map<String, dynamic>> restaurants;

  Future<List<Restaurant>>  getRestaurants() async {
    restaurants = [];
    var restaurantes1 = await Restaurant.todosRestaurantes();
    print("-----REVICION111-----");
    print(restaurantes1);
    
    for (Restaurant restaurante in await restaurantes1) {
      restaurants.add(restaurante.toMap());
    }
    print(restaurantes1);
    return restaurantes1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Restaurant>>(
    future: getRestaurants(),
    builder: (context, snapshot) {
      print("-----REVICION55-----");
      print(restaurants);
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return const Center(child: Text("Error al cargar restaurantes"));
      }


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
         slivers: [
          SliverAppBar (
          leadingWidth: 173,

          leading: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: const [
                  Icon(Icons.restaurant_menu, color: Color(0xFFFF6347), size: 28),
                  SizedBox(width: 4),
                  Text(
                    'FoodGram',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6347),
                    ),
                  ),
                ],
              ),
            ),
            expandedHeight: 148, // altura máxima cuando está expandido
        actions:[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.tune, color: primary, size: 18),
                    )),],
        floating: true,
        backgroundColor: Colors.white,
        flexibleSpace: FlexibleSpaceBar(
          background: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const SizedBox(height: 10),
                Container(
                  
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(28, 255, 105, 51),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search restaurants, cuisines...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: primary, size: 20),
                      contentPadding: EdgeInsets.only(top: 11),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(categories.length, (index) {
                    final selected = selectedCategory == index;
                    return Padding(
                      padding: EdgeInsets.only(right: index == 2 ? 0 : 8),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedCategory = index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected ? primary : Colors.white,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
 
          SliverToBoxAdapter(
          child: Column(
            children: [
              
              const SizedBox(height: 8),
              buildRecommendedSection(),
              const SizedBox(height: 8),
              ...List.generate(
                restaurants.length,
                (index) => GestureDetector(
  onTap: () {

    final pagesState = context.findAncestorStateOfType<PagesState>();
    pagesState?.setState(() {
  pagesState.currentIndex2 = 1; // Cambia al índice de tu vista especial
} );

  },
  child: RestaurantCard(
                  data: restaurants[index],
                  primary: primary,
                  isFavorite: favorites.contains(index),
                  onFavoriteTap: () {
                    setState(() {
                      if (favorites.contains(index)) {
                        favorites.remove(index);
                      } else {
                        favorites.add(index);
                      }
                    });
                  },
                ),
              ),
              )
            ],
          ),
      )]),
      ),
    );
  });
  }

  

  Widget buildRecommendedSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
    

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: const [
                Text(
                  'Recommended for You',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                Spacer(),
                Text(
                  'See All',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 156,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (_, index) => FeaturedCard(
                image: featured[index]['image'],
                name: featured[index]['name'],
                rating: featured[index]['rating'],
                primary: primary,
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: featured.length,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedCard extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final Color primary;

  const FeaturedCard({
    required this.image,
    required this.name,
    required this.rating,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Stack(
        children: [
          SizedBox(
            width: 200,
            height: 156,
            child: Image.network(image, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: RatingPill(rating: rating, primary: primary),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color primary;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  const RestaurantCard({
    required this.data,
    required this.primary,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            child: Stack(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Image.network(data['image'], fit: BoxFit.cover),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: RatingPill(
                    rating: data['rating'] as double,
                    primary: primary,
                    reviews: data['numberReviews'] as String,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if ((data['badge'] as String).isNotEmpty)
                  Positioned(
                    left: 10,
                    bottom: 10,
                    child: Row(
                      children: [
                        Badge(text: data['badge'], primary: primary),
                        const SizedBox(width: 6),
                        if ((data['badge2'] as String).isNotEmpty)
                          Badge(text: data['badge2'], primary: Colors.black54),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      data['price'],
                      style: const TextStyle(
                        color: Color(0xFFFF6933),
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  data['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A8A8A),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: primary.withOpacity(.9)),
                    const SizedBox(width: 4),
                    Text(
                      data['time'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.location_on_outlined,
                        size: 14, color: primary.withOpacity(.9)),
                    const SizedBox(width: 4),
                    Text(
                      data['distance'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'View Menu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
      
    );
    
  }

}

class RatingPill extends StatelessWidget {
  final double rating;
  final String? reviews;
  final Color primary;

  const RatingPill({
    required this.rating,
    required this.primary,
    this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEFEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_border, color:  Color(0xFFFF6933), size: 14),
          const SizedBox(width: 4),
          Text(
            reviews == null ? '$rating' : '$rating (${reviews!})',
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String text;
  final Color primary;

  const Badge({required this.text, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 9,
        ),
      ),
    );
  }
}