import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz_data.initializeTimeZones();
    
    //mwen te gen yon problem nan Timezone nan, ki te anpeche sa k programe yo mache
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
        print("Notification cliquée : ${details.payload}");
      },
    );
  }

  // pemisyon
  Future<void> requestPermissions() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  // imedyat
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

  // programe 5 segonn
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
      // mwen itilize `inexactAllowWhileIdle` pou evite pwoblèm ak Android 12+ ki limite alarm egzakt, sa tap banm problem pou notifikasyon ki pwograme pou 5 segonn lan
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // chak 5 minit
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

  // notifikasyon imaj
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

  // bouton aksyon
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