
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/Model/RestaurantRepository.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:foodgram/Presenter/RestaurantPresenter.dart';
import 'package:foodgram/View/pagesInsideStudent.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMapPage extends StatefulWidget {
  @override
  _RestaurantMapPageState createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage>
    implements RestaurantView {
  final String _mapStyle = '''
        [
        {
          "featureType": "poi",
          "elementType": "labels",
          "stylers": [
            { "visibility": "off" }
          ]
        }
        ]
    ''';

  final List<String> categories = ['All', 'Burgers', 'Pizza', 'Sushi'];
  final PageController _pageController = PageController(viewportFraction: 0.88);
  Set<Circle> _circles = {};

  bool _locationPermissionGranted = true;
  bool _isLoading = false;
  int _selectedCategory = 0;

  List<Restaurant> restaurants = [];
  Set<Polyline> _polylines = {};
  final Map<String, BitmapDescriptor> _categoryIcons = {};

  late RestaurantPresenter _presenter;
  GoogleMapController? _mapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.6097, -74.0817),
    zoom: 13.4,
  );

  Future<void> _dibujarRadioEnMiUbicacion() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _mostrarRadioEnMiUbicacion(pos.latitude, pos.longitude);
 }

  @override
  void initState() {
    super.initState();
    _presenter = RestaurantPresenter(RestaurantRepository(), UserRepository(), this);
    _presenter.fetchNearbyRestaurants();
    _prepararIconos();
    _dibujarRadioEnMiUbicacion();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  void showLoading() => setState(() => _isLoading = true);

  @override
  void hideLoading() => setState(() => _isLoading = false);

  @override
  void updateCameraPosition(double lat, double lng) {
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.5));
  }

  @override
  void mostrarRestaurantes(List<Restaurant> restaurants) {
    setState(() {
      this.restaurants = restaurants;
    });
  }

  List<Restaurant> get _filteredRestaurants {
    final selected = categories[_selectedCategory];
    if (selected == 'All') return restaurants;

    return restaurants.where((restaurant) {
      final cuisine = restaurant.cuisine.toLowerCase();
      if (selected == 'Burgers') {
        return cuisine.contains('burger') || cuisine.contains('hamburgues');
      }
      if (selected == 'Pizza') {
        return cuisine.contains('pizza') || cuisine.contains('ital');
      }
      if (selected == 'Sushi') {
        return cuisine.contains('sushi') || cuisine.contains('jap');
      }
      return true;
    }).toList();
  }

  Set<Marker> get _markers {
    return restaurants
        .map(
          (restaurant) => Marker(
            markerId: MarkerId(restaurant.name),
            position: LatLng(restaurant.lat, restaurant.long),
            icon: _iconForCategoryMarker(restaurant.cuisine),
            infoWindow: InfoWindow(title: restaurant.name),
            onTap: () {
              final pagesState = context.findAncestorStateOfType<PagesState>();
              pagesState?.setState(() {
                pagesState.setCurrentIndex2(1, restaurant.name);
              });
            },
          ),
        )
        .toSet();
  }

  void _selectCategory(int index) {
    setState(() {
      _selectedCategory = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
        );
      }
      final first = _filteredRestaurants.isNotEmpty ? _filteredRestaurants.first : null;
      if (first != null) {
        _moveToRestaurant(first);
      }
    });
  }

  void _moveToRestaurant(Restaurant restaurant) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(restaurant.lat, restaurant.long)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: _locationPermissionGranted,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            padding: const EdgeInsets.only(bottom: 250),
            markers: _markers,
            circles: _circles,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _mapController?.setMapStyle(_mapStyle);
            },
          ),
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 16,
                    right: 16,
                    child: Row(
                      children: [
                        Expanded(child: _buildSearchBar()),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 74,
                    left: 0,
                    right: 0,
                    child: _buildCategoryFilters(),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 180,
                    child: _buildMapQuickActions(),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    height: 140,
                    child: _buildRestaurantCarousel(),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Color(0x22000000),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.orange),
          hintText: "Search for food...",
          border: InputBorder.none,

        ),
      ),
    );
  }

  Widget _buildMapQuickActions() {
    return Column(
      children: [
        _quickActionButton(Icons.layers_outlined, () {}),
        const SizedBox(height: 12),
        _quickActionButton(Icons.my_location, () {
          final items = _filteredRestaurants;
          if (items.isNotEmpty) {
            _moveToRestaurant(items.first);
          }
        }),
      ],
    );
  }

  Widget _quickActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x21000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24, color: const Color(0xFF27313F)),
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

  void _mostrarRadioEnMiUbicacion(double lat, double lng) {
  setState(() {
    _circles = {
      Circle(
        circleId: CircleId('mi_radio'),
        center: LatLng(lat, lng),
        radius: 1000, // radio en metros
        fillColor: ui.Color.fromARGB(31, 255, 153, 0),
        strokeColor: Colors.orange,
        strokeWidth: 2,
      ),
    };
  });
}

  BitmapDescriptor _iconForCategoryMarker(String category) {
    switch (category) {
      case 'Burgers':
        return _categoryIcons['Burgers'] ?? BitmapDescriptor.defaultMarker;
      case 'Hamburguesas':
        return _categoryIcons['Burgers'] ?? BitmapDescriptor.defaultMarker;
      case 'Italian':
        return _categoryIcons['Italiana'] ?? BitmapDescriptor.defaultMarker;
      case 'Pizza':
        return _categoryIcons['Italiana'] ?? BitmapDescriptor.defaultMarker;
      case 'Sushi':
        return _categoryIcons['Sushi'] ?? BitmapDescriptor.defaultMarker;
      case 'Japonesa':
        return _categoryIcons['Sushi'] ?? BitmapDescriptor.defaultMarker;
      default:
        return _categoryIcons['All'] ?? BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> _prepararIconos() async {
    final burger = await getMarkerIcon(Icons.lunch_dining, const Color(0xFFFF6933));
    final pizza = await getMarkerIcon(Icons.local_pizza, const Color(0xFFFF6933));
    final cafe = await getMarkerIcon(Icons.coffee, const Color(0xFFFF6933));
    final sushi = await getMarkerIcon(Icons.set_meal, const Color(0xFFFF6933));
    final all = await getMarkerIcon(Icons.restaurant, const Color(0xFFFF6933));

    if (!mounted) return;
    setState(() {
      _categoryIcons['Parrilla'] = burger;
      _categoryIcons['Burgers'] = burger;
      _categoryIcons['Italiana'] = pizza;
      _categoryIcons['Sushi'] = sushi;
      _categoryIcons['Café'] = cafe;
      _categoryIcons['All'] = all;
    });
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
        onSelected: (_) => onTap(),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFFC6A2F),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        avatar: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.white : const Color(0xFF232934),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF232934),
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantCarousel() {
    final items = _filteredRestaurants;

    if (items.isEmpty) {
      return Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.88,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Text(
            'No restaurants available in this category.',
            style: TextStyle(fontSize: 16, color: Color(0xFF4A5565)),
          ),
        ),
      );
    }

    return PageView.builder(
      itemCount: items.length,
      controller: _pageController,
      onPageChanged: (index) {
        _moveToRestaurant(items[index]);
      },
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
        onTap: () {
          print(item.name);
                  final pagesState = context.findAncestorStateOfType<PagesState>();
                  pagesState?.setState(() {
                  print(item.name);
                  pagesState.setCurrentIndex2(1, item.name);
        }, );},
    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFFF6A33), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${item.rating} ',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  Text(
                    item.distance,
                    style: const TextStyle(color: Color(0xFF687281), fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0EA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.badge.isNotEmpty ? item.badge.toUpperCase() : item.cuisine.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFFF6A33),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  @override
  void mostrarError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void mostrarExito(String message) {}


  Future<BitmapDescriptor> getMarkerIcon(IconData iconData, Color color) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final iconStr = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0,
        color: color,
        fontSize: 100,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0, 0));

    final picture = pictureRecorder.endRecording();
    final img = await picture.toImage(100, 100);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;

    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }

    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }
}
