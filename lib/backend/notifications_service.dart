import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// for scheduled notif
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationSercice {

  final _localNotifService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Android
    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings("@mipmap/launcher_icon");

    final DarwinInitializationSettings darwinInitSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitSettings
    );

    await _localNotifService.initialize(settings, onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);

    /*final bool result = await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
    );*/
  }

  void _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    print("id $id");
  }

  void _onDidReceiveNotificationResponse(NotificationResponse details) {
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      "android_channel_1",
      "android_channel_1",
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      //playSound: true
    );

    return NotificationDetails(android: androidDetails);
  }

  Future<void> showInstant({
    required int id,
    required String title,
    required String body
  }) async {
    final notifDetails = await _notificationDetails();
    await _localNotifService.show(id, title, body, notifDetails);
  }

  Future<void> showDelayed({
    required int id,
    required String title,
    required String body,
    required Duration interval
  }) async {
    tz.initializeTimeZones();
    final notifDetails = await _notificationDetails();
    await _localNotifService.zonedSchedule(
      id, 
      title, 
      body, 
      tz.TZDateTime.from(DateTime.now().add(interval), tz.local), 
      notifDetails, 
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

}