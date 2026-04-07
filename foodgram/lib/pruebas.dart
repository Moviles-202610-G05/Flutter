import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMapPage extends StatefulWidget {
  const RestaurantMapPage({super.key});

  @override
  State<RestaurantMapPage> createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  final List<Map<String, dynamic>> restaurants = [
    {
      'id': 'burger_palace',
      'name': 'Burger Palace',
      'rating': 4.8,
      'distance': '0.5 miles away',
      'type': 'TOP RATED',
      'category': 'Burgers',
      'position': const LatLng(37.7749, -122.4194),
    },
    {
      'id': 'lucky_sushi',
      'name': 'Lucky Sushi',
      'rating': 4.5,
      'distance': '1.2 miles away',
      'type': 'FEATURED',
      'category': 'Sushi',
      'position': const LatLng(37.7646, -122.4312),
    },
    {
      'id': 'fire_pizza',
      'name': 'Fire Pizza',
      'rating': 4.7,
      'distance': '0.9 miles away',
      'type': 'TRENDING',
      'category': 'Pizza',
      'position': const LatLng(37.7693, -122.4077),
    },
    {
      'id': 'west_burger',
      'name': 'West Burger',
      'rating': 4.6,
      'distance': '1.6 miles away',
      'type': 'FAST DELIVERY',
      'category': 'Burgers',
      'position': const LatLng(37.7527, -122.4341),
    },
  ];

  final List<String> categories = ['All', 'Burgers', 'Pizza', 'Sushi'];
  final PageController _pageController = PageController(viewportFraction: 0.88);

  GoogleMapController? _mapController;
  int _selectedCategory = 0;
  int _selectedNav = 4;
  int _currentCardIndex = 0;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12.8,
  );


  Set<Marker> get _markers {
    final markerColor =
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    return restaurants
        .map(
          (restaurant) => Marker(
            markerId: MarkerId(restaurant['name'] as String),
            position: restaurant['position'] as LatLng,
            icon: markerColor,
            infoWindow: InfoWindow(title: restaurant['name'] as String),
          ),
        )
        .toSet();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _moveToRestaurant(Map<String, dynamic> restaurant) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(restaurant['position'] as LatLng),
    );
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
      _currentCardIndex = 0;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      final first = restaurants.isNotEmpty ? restaurants.first : null;
      if (first != null) {
        _moveToRestaurant(first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleRestaurants = restaurants;

    return Scaffold(
      backgroundColor: const Color(0xFFE9EEF3),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: false,
            padding: const EdgeInsets.only(bottom: 220),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            top: 48,
            left: 18,
            right: 18,
            child: Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 10),
                _buildCircleAction(
                  icon: Icons.tune,
                  onTap: () {},
                ),
              ],
            ),
          ),
          Positioned(
            top: 106,
            left: 0,
            right: 0,
            child: _buildCategoryFilters(),
          ),
          Positioned(
            left: 18,
            bottom: 238,
            child: Column(
              children: [
                _buildCircleAction(
                  icon: Icons.layers_outlined,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _buildCircleAction(
                  icon: Icons.my_location,
                  onTap: () {
                    final focusedList = restaurants;
                    if (focusedList.isNotEmpty) {
                      _moveToRestaurant(
                        focusedList[_currentCardIndex.clamp(0, focusedList.length - 1)],
                      );
                    }
                  },
                  iconColor: const Color(0xFFFC6A2F),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 208,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFFFC6A2F),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 78,
            left: 0,
            right: 0,
            height: 120,
            child: visibleRestaurants.isEmpty
                ? const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No restaurants in this category.'),
                      ),
                    ),
                  )
                : _buildRestaurantCarousel(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        cursorColor: const Color(0xFFFC6A2F),
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFFFC6A2F)),
          hintText: 'Search for food...',
          hintStyle: TextStyle(
            color: Color(0xFF9AA5B4),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(categories.length, (index) {
          return _filterChip(
            categories[index],
            _iconForCategory(categories[index]),
            _selectedCategory == index,
            () => _selectCategory(index),
          );
        }),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Burgers':
        return Icons.lunch_dining;
      case 'Pizza':
        return Icons.local_pizza;
      case 'Sushi':
        return Icons.set_meal;
      default:
        return Icons.restaurant;
    }
  }

  Widget _filterChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF232934),
            fontWeight: FontWeight.w600,
          ),
        ),
        onSelected: (_) => onTap(),
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? Colors.white : const Color(0xFF232934),
        ),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFFC6A2F),
        shape: const StadiumBorder(),
        side: BorderSide.none,
        elevation: isSelected ? 2 : 0,
        pressElevation: 0,
      ),
    );
  }

Widget _buildRestaurantCarousel() {
    return PageView.builder(
      itemCount: restaurants.length,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        final item = restaurants[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40), // Bordes muy redondeados como en la imagen
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        Text(" ${item['rating']} ", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(item['distance'], style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(item['type'], style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildCircleAction({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF4D5A6B),
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final navItems = [
      {'icon': Icons.feed_outlined, 'label': 'FEED'},
      {'icon': Icons.search, 'label': 'SEARCH'},
      {'icon': Icons.person_outline, 'label': 'PROFILE'},
      {'icon': Icons.insert_chart_outlined_rounded, 'label': 'TRACKER'},
      {'icon': Icons.map_outlined, 'label': 'MAP'},
    ];

    return Container(
      height: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(navItems.length, (index) {
          final isSelected = _selectedNav == index;
          final icon = navItems[index]['icon'] as IconData;
          final label = navItems[index]['label'] as String;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedNav = index;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 21,
                    color: isSelected
                        ? const Color(0xFFFC6A2F)
                        : const Color(0xFF6E7784),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFFFC6A2F)
                          : const Color(0xFF6E7784),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}