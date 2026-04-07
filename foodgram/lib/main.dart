import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodgram/View/Notificaciones.dart';
import 'package:foodgram/View/login_screen.dart';
import 'package:foodgram/View/mapa.dart';
import 'package:foodgram/View/restaurants_screen.dart';
import 'package:foodgram/View/tracker_user_screen.dart' show TrackerScreen;
import 'package:foodgram/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
 
  runApp(const MyApp());
  await NotificationService.showSmartNotification();
  print("hola");
  
  
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
      home: LoginScreen(),
    );
  }

}