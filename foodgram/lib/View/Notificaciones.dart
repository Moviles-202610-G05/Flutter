import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:foodgram/View/pagesInsideStudent.dart';

class NotificationService {
  static bool _notificacionMostradaEnSesion = false;

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

  static Future<void> showSmartNotification() async {
    if (_notificacionMostradaEnSesion) return;

    const String restauranteObjetivo = "Uniandes Pizzeria";

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'restaurant_channel',
      'Smart Recommendations',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    await notifications.show(
      0,
      'Craving some Pizza? 🍕', 
      'Your friends are eating at $restauranteObjetivo right now. Join them! ✨', 
      const NotificationDetails(android: androidDetails),
      payload: restauranteObjetivo,
    );
    _notificacionMostradaEnSesion = true;
  }
}