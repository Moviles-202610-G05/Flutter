import 'package:flutter/material.dart';
import 'package:foodgram/Vistas/feed_screen.dart';
import 'package:foodgram/Vistas/user_screen.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => _Pages();
}

class _Pages extends State<Pages> {
  int _currentIndex = 0; // estado inicial

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: _getBody(_currentIndex), // tu contenido cambia según el índice
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index; // aquí actualizas el seleccionado
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


}

Widget _getBody(int index) {
  switch (index) {
    case 0:
      return FeedScreen();
    case 1:
      return UserScreen();
    case 2:
      return UserScreen();
    default:
      return Container();
  }
}
