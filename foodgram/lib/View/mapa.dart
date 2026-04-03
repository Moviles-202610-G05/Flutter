import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantMapPage extends StatefulWidget {
  @override
  _RestaurantMapPageState createState() => _RestaurantMapPageState();
}

class _RestaurantMapPageState extends State<RestaurantMapPage> {
  // Simulación de datos que vendrían del Presenter
  final List<Map<String, dynamic>> restaurants = [
    {"name": "Burger Palace", "rating": 4.8, "distance": "0.5 miles away", "type": "TOP RATED"},
    {"name": "Lucky Sushi", "rating": 4.5, "distance": "1.2 miles away", "type": "FEATURED"},
  ];
  static const CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(37.7749, -122.4194), // Coordenadas de San Francisco (como tu imagen)
      zoom: 14.0,
    );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationButtonEnabled: false, // El botón circular que ves en tu imagen
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              // Aquí puedes guardar el controlador si necesitas mover el mapa luego
            },
            markers: {
              // Aquí añadirías los pines (marcadores) de los restaurantes
              Marker(
                markerId: MarkerId('burger_palace'),
                position: LatLng(37.7749, -122.4194),
                infoWindow: InfoWindow(title: 'Burger Palace'),
              ),
            },
          ),

          // 2. Buscador Superior
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: _buildSearchBar(),
          ),

          // 3. Filtros de Categoría
          Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: _buildCategoryFilters(),
          ),

          // 4. Carrusel de Tarjetas Inferior
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            height: 120,
            child: _buildRestaurantCarousel(),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO ---

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
          suffixIcon: Icon(Icons.mic_none),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _filterChip("All", Icons.restaurant, true),
          _filterChip("Burgers", Icons.lunch_dining, false),
          _filterChip("Pizza", Icons.local_pizza, false),
          _filterChip("Sushi", Icons.set_meal, false),
        ],
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: FilterChip(
        selected: isSelected,
        label: Text(label),
        onSelected: (bool value) {},
        avatar: Icon(icon, size: 18, color: isSelected ? Colors.white : Colors.black),
        backgroundColor: Colors.white,
        selectedColor: Colors.orangeAccent,
        shape: StadiumBorder(),
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
}