import 'package:flutter/material.dart';
import 'package:foodgram/Model/MenuEntity.dart';
import 'package:foodgram/Model/MenuRepository.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/ReviewsEntity.dart';
import 'package:foodgram/Model/ReviwsRepository.dart';
import 'package:foodgram/Presenter/RestaurantPresenter.dart';
import 'package:foodgram/Presenter/RestauranteDetalle.dart';
import 'package:foodgram/View/pagesInsideStudent.dart';
import 'package:foodgram/View/write_review_screen.dart';



class RestaurantDetailScreen extends StatefulWidget {
  final String rest;


  const RestaurantDetailScreen({
    Key? key,
    required this.rest,
  }) : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
  with SingleTickerProviderStateMixin implements RestaurantDetaleView {
  static const Color primary = Color(0xFFFF6933);
  late TabController _tabController;
  late RestaurantDetalePresenter presenter;
  List<Reviews> reviews = [];
  List<Menu> dishes = [];
  Restaurant restaurants = Restaurant(name: "", image: "", rating: 0, price: "", cuisine: "", time: "", distance: "", long: 0, lat: 0, badge: "", badge2: "", numberReviews: 0, description: "", direction: "", spots: 0, spotsA: 0);
  
  bool lodedReviews = false;
  
  bool lodedMenu = false;
  
  bool lodedRestaurants = false;

  @override
  void mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  void mostrarExito(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }


 initState()  {
    super.initState();
    presenter =  RestaurantDetalePresenter(RestaurantRepository(), MenuRepository(), ReviwsRepository(), this);
    presenter.mostrarDetalle(widget.rest);
    _tabController = TabController(length: 3, vsync: this);
  }






  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (lodedReviews && lodedMenu && lodedRestaurants ){
      return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRestaurantInfo(),
                  const Divider(height: 1, thickness: 1),
                  _buildTabBar(),
                  Flexible ( 
                    child: _buildTabContent(),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
    }
    else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, color: primary, size: 20),
        ),
      onPressed: () {

        final pagesState = context.findAncestorStateOfType<PagesState>();
          pagesState?.setState(() {
        pagesState.currentIndex2 = 0; // Cambia al índice de tu vista especial
      } );}
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              restaurants.image,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 12,
              left: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurants.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          blurRadius: 12,
                          color: Colors.black54,
                          offset: Offset(0, 2),
                        ),
                      ],
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

  Widget _buildRestaurantInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3F0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Fine Dining',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${restaurants.price}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '• ${restaurants.cuisine}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const Icon(Icons.star, color: primary, size: 16),
              const SizedBox(width: 4),
              Text(
                '${restaurants.rating}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${restaurants.time} • ${restaurants.distance}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAvailabilitySection(),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'LIVE AVAILABILITY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF4CAF50),
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Text(
              'Updated 1m ago',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${restaurants.spotsA}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF4CAF50),
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text(
                        'Available Now',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: ${restaurants.spots} spots',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: restaurants.spotsA / restaurants.spots,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: primary,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: primary,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        onTap: (index) {
          setState(() {});
        },
        tabs: const [
          Tab(text: 'Menu'),
          Tab(text: 'Location'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return Container(
      
      child: Column(  
        children: [Expanded ( child: TabBarView(
        controller: _tabController,
        children: [
          _buildSignatureDishes(),
          _buildLocationTab(),
          _buildReviewsTab(),
        ],
      ), )])
    );
  }

  Widget _buildSignatureDishes() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ...dishes.map((dish) => _DishCard(dish: dish, primary: primary)),
        ],
      ),]

    );
  }

  Widget _buildLocationTab() {
    final String apiKey = "AIzaSyDxzMLWUCmAQqm2dpmpDzkC3L8r09rEri4"; // Reemplaza con tu clave de Google Maps
    final String url =
      "https://maps.googleapis.com/maps/api/staticmap?"
      "center=${restaurants.lat},${restaurants.long}&zoom=14&size=600x400"
      "&key=$apiKey";
    print (url);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location & Directions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                                     Image.network(
                    url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),


                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: primary,
                      size: 48,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "${restaurants.direction}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '0101',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Get Directions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReviewScreen(
                      restaurantName: 'The Golden Truffle Bistro',
                      restaurantLocation: 'Downtown, 5th Avenue',
                      restaurantImage: 'image_url',
                    ),
                  ),
                  );},
                child: const Text(
                  'Write a review',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...reviews.map((review) => _ReviewCard(review: review)),
        ],
      ),
    );
  }

  
  @override
  void mostrarMenu(List<Menu> menu) {
    dishes = menu;
    setState(() {
      lodedMenu = true;
    });

  }
  
  @override
  void mostrarReviews(List<Reviews> reviews ) {
    this.reviews = reviews;
    
    setState(() {
      lodedReviews = true;
    });
    
  }
  
  @override
  void mostrarRestaurantes(Restaurant restaurants) {
    this.restaurants = restaurants; 
    setState(() {
      lodedRestaurants = true;
    });
   
  }
  }


class _DishCard extends StatelessWidget {
  final Menu dish;
  final Color primary;

  const _DishCard({required this.dish, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 80,
                maxHeight: 80,
              ),
              child: Image.network(
                dish.image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        dish.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '\$${dish.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFFF6347),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dish.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _IconButton(Icons.bookmark_border, () {}),
                    const SizedBox(width: 12),
                    _IconButton(Icons.share_outlined, () {}),
                    const SizedBox(width: 12),
                    _IconButton(Icons.favorite_border, () {}),
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

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _IconButton(this.icon, this.onTap, {this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 20,
        color: color ?? Colors.grey[600],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Reviews review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: review.avatarColor,
                child: Text(
                  review.avatar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      review.date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating
                        ? Icons.star
                        : Icons.star_border,
                    size: 14,
                    color: const Color(0xFFFF6933),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF6933);

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? primary : const Color(0xFFA15D45),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? primary : const Color(0xFFA15D45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}