import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
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

  await notifications.initialize(settings);

  // 👇 Agrega esto para pedir permisos en Android 13+
  final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
      notifications.resolvePlatformSpecificImplementation
          <AndroidFlutterLocalNotificationsPlugin>();

  await androidPlugin?.requestNotificationsPermission();
  await androidPlugin?.requestExactAlarmsPermission();
}

  static String _getRecommendationByHour() {
    final int hour = DateTime.now().hour;

    if (hour >= 0 && hour < 24) {
      return "Two of your friends are having lunch at La Pizzería🍕";
    } else {
      return "Hola";
    }
  }

  static Future<void> showSmartNotification() async {
    final String? message = _getRecommendationByHour();

    if (message == "") return; // Solo notifica en la mañana

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'restaurant_channel',
      'Recomendaciones de Restaurantes',
      channelDescription: 'Notificaciones con recomendaciones según la hora',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await notifications.show(
      0,
      '¿Where are your Frends?',
      message,
      details,
    );
  }



  // Programa la notificación automáticamente cada mañana a las 8am
  static Future<void> scheduleMorningNotification() async {
    
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(Duration(minutes: 1));

    print(now);
    print(scheduledDate);



    // Si ya pasaron las 8am hoy, programa para mañana
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
        print(scheduledDate);
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails( 
      'restaurant_channel',
      'Recomendaciones de Restaurantes',
      channelDescription: 'Notificaciones con recomendaciones según la hora',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await notifications.zonedSchedule(
      1,
      '🍽️ ¿Ya pensaste qué comer hoy?',
      '🍕 Buenos días! La Pizzería y Sushi House tienen las mejores opciones para tu almuerzo.',
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}