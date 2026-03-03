import 'package:flutter/material.dart';
import 'package:foodgram/Vistas/feed_screen.dart';
import 'package:foodgram/Vistas/restaurant_detalle_screen.dart';
import 'package:foodgram/Vistas/restaurants_screen.dart';
import 'package:foodgram/Vistas/user_screen.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => PagesState();

  
}

class PagesState extends State<Pages> {
  int _currentIndex = 0; // estado inicial
  int currentIndex2 = 0; 
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _getBody(_currentIndex, currentIndex2), // tu contenido cambia según el índice
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          currentIndex2 = 0; // aquí actualizas el seleccionado
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFFF6933),
      unselectedItemColor: Color(0xFFA15D45),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dynamic_feed),
          label: 'FEED',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'SEARCH',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'PROFILE',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: 'TRACKER',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: 'MAP',
        ),
      ],
    ),
  );
}
void setCurrentIndex2 (int index){
  currentIndex2 = index;
}

}

Widget _getBody(int index, int index2) {
  
    switch (index) {
      case 1:
        switch (index2) {
          case 1:
            return RestaurantDetailScreen(restaurantName: 'La Trattoria Milano',
              restaurantImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
              rating: 4.8,
              reviews: '2.4k+',
              price: '\$\$\$',
              cuisine: 'French Cuisine',
              time: '25-35 min',
              distance: '1.2 km', lat: 100, long: 100,);
        default:
          return RestaurantFeed();}
      case 0:
      switch (index2) {
          case 1:
            return RestaurantDetailScreen(restaurantName: 'La Trattoria Milano',
              restaurantImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=1200',
              rating: 4.8,
              reviews: '2.4k+',
              price: '\$\$\$',
              cuisine: 'French Cuisine',
              time: '25-35 min',
              distance: '1.2 km', lat: 100, long: 100,);
        default:
          return FeedScreen();}
    case 2:
          return UserScreen();
      default:
        return Container();
    }
}
