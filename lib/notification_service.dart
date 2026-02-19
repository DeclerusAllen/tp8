import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // 1. Initialisation des données de fuseaux horaires
    tz_data.initializeTimeZones();
    
    // 2. Récupération du fuseau horaire local (SANS package externe)
    // Cela corrige l'erreur de compilation et le problème des 5 secondes
    try {
      final String timeZoneName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      // Si le nom du fuseau est inconnu, on utilise UTC par défaut pour éviter un crash
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print("Notification cliquée : ${details.payload}");
      },
    );
  }

  // Demander la permission (Indispensable pour Android 13+)
  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // 1. Notification Immédiate
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "channel_id_1",
      "Normal Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      0,
      "Salut !",
      "Ceci est une notification immédiate.",
      const NotificationDetails(android: androidDetails),
    );
  }

  // 2. Notification Programmée (5 secondes)
  Future<void> scheduleNotification() async {
    await _notificationsPlugin.zonedSchedule(
      1,
      "Notification Programmée",
      "5 secondes se sont écoulées !",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_2",
          "Scheduled Notifications",
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      // On utilise inexact pour éviter les restrictions strictes de Samsung
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 3. Notification Répétitive (Chaque minute)
  Future<void> repeatNotification() async {
    await _notificationsPlugin.periodicallyShow(
      2,
      "Répétition",
      "Cette notification revient chaque minute",
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails("channel_id_3", "Repeat Notifications"),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // 4. Notification avec Grande Image
  Future<void> showBigImageNotification() async {
    final style = BigPictureStyleInformation(
      const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      contentTitle: "Notification avec Image",
      summaryText: "Voici un aperçu de l'image",
    );

    await _notificationsPlugin.show(
      3,
      "Image !",
      "Regardez cette grande image",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_4", 
          "Image Channel", 
          styleInformation: style
        )
      ),
    );
  }

  // 5. Notification avec Boutons d'Action
  Future<void> showNotificationWithActions() async {
    await _notificationsPlugin.show(
      4,
      "Action Requise",
      "Voulez-vous accepter ?",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_5",
          "Action Channel",
          actions: [
            AndroidNotificationAction("id_accept", "✅ Accepter"),
            AndroidNotificationAction("id_decline", "❌ Refuser"),
          ],
        ),
      ),
    );
  }

  Future<void> cancelAll() async => await _notificationsPlugin.cancelAll();
}