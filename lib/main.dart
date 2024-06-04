import 'package:flutter/material.dart';
import 'package:french_words_learner/home_view_chooser.dart';
import 'package:french_words_learner/onboarding_ui/onboarding.dart';
import 'package:french_words_learner/screens/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
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
