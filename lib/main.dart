import 'package:flutter/material.dart';
import 'app_preferences.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences().init();

  final hasSavedData = AppPreferences().getData('isFormSaved') ?? false;

  runApp(MyApp(isFormSaved: hasSavedData));
}

class MyApp extends StatelessWidget {
  final bool isFormSaved;

  MyApp({required this.isFormSaved});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isFormSaved ? HomeScreen() : OnboardingScreen(),
    );
  }
}
