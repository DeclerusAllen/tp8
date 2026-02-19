import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    
    try {
      final String timeZoneName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
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
        print("Notifikasyon klike : ${details.payload}");
      },
    );
  }

  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // 1. Imedyat
  Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "channel_id_1",
      "Notifikasyon Nomal",
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      0,
      "Bonjou !",
      "Sa se yon notifikasyon k ap parèt rapid.",
      const NotificationDetails(android: androidDetails),
    );
  }

  // 2. Programe 5 segonn
  Future<void> scheduleNotification() async {
    await _notificationsPlugin.zonedSchedule(
      1,
      "Notifikasyon Pwograme",
      "5 segonn yo fini !",
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_2",
          "Notifikasyon Pwograme",
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // 3. Chak minit
  Future<void> repeatNotification() async {
    await _notificationsPlugin.periodicallyShow(
      2,
      "Repetisyon",
      "Notifikasyon sa ap tounen chak minit",
      RepeatInterval.everyMinute,
      const NotificationDetails(
        android: AndroidNotificationDetails("channel_id_3", "Notifikasyon Repete"),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // 4. Notifikasyon imaj
  Future<void> showBigImageNotification() async {
    final style = BigPictureStyleInformation(
      const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      contentTitle: "Notifikasyon ak Foto",
      summaryText: "Men foto a de mwayen",
    );

    await _notificationsPlugin.show(
      3,
      "Foto !",
      "Gade gwo foto sa a",
      NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_4", 
          "Seksyon Foto", 
          styleInformation: style
        )
      ),
    );
  }

  // 5. Bouton aksyon
  Future<void> showNotificationWithActions() async {
    await _notificationsPlugin.show(
      4,
      "Aksyon Nesesè",
      "Èske ou vle aksepte ?",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_id_5",
          "Seksyon Aksyon",
          actions: [
            AndroidNotificationAction("id_accept", "Aksepte"),
            AndroidNotificationAction("id_decline", "Refize"),
          ],
        ),
      ),
    );
  }

  Future<void> cancelAll() async => await _notificationsPlugin.cancelAll();
}