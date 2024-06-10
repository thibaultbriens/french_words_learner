import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// for scheduled notif
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationSercice {

  final _localNotifService = FlutterLocalNotificationsPlugin();

  List<String> titles = [
    "Continuez comme ça",
    "Génial",
    "Encore un petit effort",
    "Temps de s'y mettre",
    "C'est maintenant !"
  ];

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
    required DateTime date
  }) async {
    tz.initializeTimeZones();
    final notifDetails = await _notificationDetails();
    await _localNotifService.zonedSchedule(
      id, 
      title, 
      body, 
      tz.TZDateTime.from(date, tz.local), 
      notifDetails, 
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  /// Add a scheduled notification for a specific word
  /// This function checks that a notification isn't already set up for this precise day
  Future<void> addWordNotification ({
    required DateTime date
  }) async {
    List<PendingNotificationRequest> pendingNotifs = await _localNotifService.pendingNotificationRequests();
    for(int i = 0; i < pendingNotifs.length; i++){
      if(pendingNotifs[i].id == dateId(date)){
        return;
      }
    }
    print("added notif for ${date}");
    showDelayed(id: dateId(date), title: titles[Random().nextInt(titles.length)], body: "Venez swiper vos mots du jour pour continuer votre apprentissage", date: DateTime(date.year, date.month, date.day, 10));
  }
  
  int dateId(DateTime date) {
    return int.parse("${date.day.toString().padLeft(2, "0")}${date.month.toString().padLeft(2, "0")}${date.year}");
  }
}