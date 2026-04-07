import 'package:flutter/material.dart';
import 'package:foodgram/Model/RestaurantEntity.dart';
import 'package:foodgram/View/feed_screen.dart';
import 'package:foodgram/View/mapa.dart';
import 'package:foodgram/View/restaurant_detalle_screen.dart';
import 'package:foodgram/View/restaurants_screen.dart';
import 'package:foodgram/View/tracker_user_screen.dart';
import 'package:foodgram/View/user_screen.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => PagesState();

  
}

class PagesState extends State<Pages> {
  int _currentIndex = 0; // estado inicial
  int currentIndex2 = 0; 
  String rest = "";
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _getBody(_currentIndex, currentIndex2, rest), // tu contenido cambia según el índice
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
void setCurrentIndex2 (int index, String rest){
  currentIndex2 = index;
  this.rest = rest;
}

}

Widget _getBody(int index, int index2, rest) {
  
    switch (index) {
      case 1:
        switch (index2) {
          case 1:
            return RestaurantDetailScreen(rest: rest);
        default:
          return RestaurantFeed();}
      case 0:
        return FeedScreen();
      case 2:
        return UserScreen();
      case 3: 
        return TrackerScreen();
      case 4: 
      switch (index2) {
          case 1:
            return RestaurantDetailScreen(rest: rest);
        default:
          return RestaurantMapPage();}
      default:
        return Container();
    }
}
