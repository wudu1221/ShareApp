import 'package:flutter/material.dart';
import 'models/user_profile.dart';      // import from models
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(StoryApp());
}

class StoryApp extends StatefulWidget {
  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  ThemeMode _themeMode = ThemeMode.light;
  UserProfile? _currentUser;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void loginUser(String username, String email) {
    setState(() {
      _currentUser = UserProfile(name: username, email: email);
    });
  }

  void logoutUser() {
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story App',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple.shade700,
          foregroundColor: Colors.white,
        ),
        cardColor: Colors.grey[850],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: _currentUser == null
          ? LoginScreen(onLogin: loginUser)
          : HomeScreen(
              currentUser: _currentUser!,
              onLogout: logoutUser,
              onThemeToggle: toggleTheme,
              isDarkMode: _themeMode == ThemeMode.dark,
            ),
      debugShowCheckedModeBanner: false,
    );
  }
}
