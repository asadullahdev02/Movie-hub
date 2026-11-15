import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'movie.dart';

/// App entry point
void main() {
  runApp(const MovieHubApp());
}

/// Root widget configuring the light theme and initial route.
class MovieHubApp extends StatelessWidget {
  const MovieHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.cinematicNavy,
        cardColor: AppColors.darkCharcoal,
        fontFamily: 'sans-serif',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cinematicNavy,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.light(
          primary: AppColors.cinemaRed,
          secondary: AppColors.electricBlue,
          surface: AppColors.darkCharcoal,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
