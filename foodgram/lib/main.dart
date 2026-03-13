import 'package:flutter/material.dart';
import 'package:foodgram/Vistas/Login_screen.dart' show LoginScreen;
import 'package:foodgram/Vistas/user_screen.dart' show UserScreen;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const LoginScreen(),
    );
  }
}