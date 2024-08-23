import 'package:flutter/material.dart';
import 'package:sysman_prueba/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _themeMode = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeMode,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          home: HomeScreen(title: 'Home', themeMode: _themeMode),
        );
      },
    );
  }
}