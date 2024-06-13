import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:localstore/localstore.dart';
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

    // Get user reminder hour
    List<int> reminderTime = await getHourMinute();

    print("added notif for ${date}");
    showDelayed(id: dateId(date), title: titles[Random().nextInt(titles.length)], body: "Venez swiper vos mots du jour pour continuer votre apprentissage", date: DateTime(date.year, date.month, date.day, reminderTime[0], reminderTime[1]));
  }
  
  int dateId(DateTime date) {
    return int.parse("${date.day.toString().padLeft(2, "0")}${date.month.toString().padLeft(2, "0")}${date.year}");
  }

  Future<void> updateTime(int hour, int minute) async{
    // Save in LocalStore
    final db = Localstore.instance;

    db.collection("static").doc("notifications").set({
        "reminder-hour": hour,
        "reminder-minute": minute
      }, 
      SetOptions(merge: true));

    // Update Schedules notifications
    List<PendingNotificationRequest> pendingNotifs = await _localNotifService.pendingNotificationRequests();

    List<int> ids = []; // This is cool because the id is the dateId : 01012000 for January 1st of 2000

    // Store ids
    for(int i = 0; i < pendingNotifs.length; i++){
      ids.add(pendingNotifs[i].id);
    }

    // Delete All Notficiations
    await _localNotifService.cancelAll();

    // Schedule notifications
    for(int id in ids){
      String idStr = id.toString();
      DateTime date = DateTime(int.parse("${idStr[4]}${idStr[5]}${idStr[6]}${idStr[7]}"), int.parse("${idStr[2]}${idStr[3]}"), int.parse("${idStr[0]}${idStr[1]}"), hour, minute);
      showDelayed(id: id, title: titles[Random().nextInt(titles.length)], body: "Venez swiper vos mots du jour pour continuer votre apprentissage", date: date);
    }
  }

  // Get custom reminder hour
  Future<List<int>> getHourMinute() async {
    List<int> result = [10, 0];

    Map<String, dynamic>? data = await Localstore.instance.collection("static").doc("notifications").get();

    if(data == null) return result;

    if(data.keys.contains("reminder-hour")){
      result[0] = data["reminder-hour"];
    }

    if(data.keys.contains("reminder-minute")){
      result[1] = data["reminder-minute"];
    }

    return result;
  }
}