import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodgram/Model/UserRepository.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:foodgram/View/pagesInsideStudent.dart';

class NotificationService {
  static DateTime? _ultimaNotificacion;
  static const Duration _cooldown = Duration(seconds: 5);

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
        if (payload == 'tracker') {
          pagesKey.currentState?.navegarAlTracker();
        } else if (payload != null && payload.isNotEmpty) {
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

    const androidDetails = AndroidNotificationDetails(
      'restaurant_channel',
      'Smart Recommendations',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    if (friendName != null && restaurantName != null) {
      await notifications.show(
        0,
        'Your friend is eating right now! 🍕',
        '$friendName is at $restaurantName. Join them!',
        const NotificationDetails(android: androidDetails),
        payload: restaurantName,
      );
      _ultimaNotificacion = ahora;
      return;
    }

    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    final activos = await UserRepository().getActiveFriends(email);
    if (activos.isEmpty) return;

    for (var i = 0; i < activos.length; i++) {
      final amigo = activos[i]['name']!;
      final restaurante = activos[i]['restaurant']!;
      await notifications.show(
        i,
        'Your friend is eating right now! 🍕',
        '$amigo is at $restaurante. Join them!',
        const NotificationDetails(android: androidDetails),
        payload: restaurante,
      );
    }
    _ultimaNotificacion = ahora;
  }

  static Future<void> showMealReadyNotification(String dishName) async {
    const androidDetails = AndroidNotificationDetails(
      'meal_analysis_channel',
      'Meal Analysis',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await notifications.show(
      999,
      'Your meal analysis is ready! 🍽️',
      '$dishName has been analyzed and logged.',
      const NotificationDetails(android: androidDetails),
      payload: 'tracker',
    );
  }
}
