import 'dart:math';

import 'package:flutter/material.dart';
import 'package:french_words_learner/backend/notifications_service.dart';
import 'package:french_words_learner/home_view_chooser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationSercice().initialize();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomeView(),
      theme: ThemeData(
        colorScheme: myColorScheme,
        useMaterial3: true
      ),
    )
  );
}

final ColorScheme myColorScheme = ColorScheme(
  primary: Color(0xFF8FDFFF), 
  secondary: Color(0xFFfff28f), // not used
  surface: Color(0xFF8FDFFF),
  background: Color(0xFFF3FCFF), 
  error: Color(0xFFFF8F8F),
  onPrimary: Color(0xff023a63),
  onSecondary: Color(0xFF33301d), // not used
  onSurface: Color(0xff023a63),
  onBackground: Color(0xff023a63),
  onError: Colors.black,
  brightness: Brightness.light,
);

/*class TestNotif extends StatelessWidget {
  const TestNotif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 200,),
          ElevatedButton(onPressed: () async {
            await NotificationSercice().showInstant(id: Random().nextInt(10), title: "Notif Titre", body: "C'est génial");
          }, child: Text("Press for instant notif", style: TextStyle(color: Colors.white),)),
          ElevatedButton(onPressed: () async {
            await NotificationSercice().addWordNotification(date: DateTime.now());
          }, child: Text("Press for delayed notif", style: TextStyle(color: Colors.white),))
        ],
      ),
    );
  }
}*/
