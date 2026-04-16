import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:foodgram/View/pagesInsideStudent.dart';

class NotificationService {
  static DateTime? _ultimaNotificacion;
  static const Duration _cooldown = Duration(seconds: 5);
  static const List<String> _amigos = ["María", "Juan", "Camila", "Andrés", "Sofía"];
  static const List<String> _restaurantes = ["Uniandes Pizzeria", "CityU Burger Palace"];

  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('America/Bogota'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(),
    );

    await notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final String? payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          pagesKey.currentState?.navegarARestauranteDirecto(payload);
        }
      },
    );

    final androidPlugin = notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
  }

  static Future<void> showSmartNotification({String? friendName, String? restaurantName}) async {
    final ahora = DateTime.now();
    if (_ultimaNotificacion != null && ahora.difference(_ultimaNotificacion!) < _cooldown) {
      return;
    }

    const String restauranteObjetivo = "Uniandes Pizzeria";
    final random = Random();
    final amigo = friendName ?? _amigos[random.nextInt(_amigos.length)];
    final restaurante = restaurantName ?? _restaurantes[random.nextInt(_restaurantes.length)];

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'restaurant_channel',
      'Smart Recommendations',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await notifications.show(
      0,
      'Craving some food? 🍕',
      '$amigo is eating at $restaurante right now. Join them! ✨',
      const NotificationDetails(android: androidDetails),
      payload: restaurante,
    );
    _ultimaNotificacion = ahora;
  }
}