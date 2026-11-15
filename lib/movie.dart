import 'package:flutter/material.dart';

/// Cinema Theme Color Palette (Light Theme / Soft Off-White Edition)
/// Centralized colors used across the Movie Hub application.
class AppColors {
  static const Color cinematicNavy = Color(0xFFF5F7FA); // Soft off-white body background
  static const Color darkCharcoal  = Color(0xFFFFFFFF); // Clean white card & modal background
  static const Color cinemaRed     = Color(0xFFE63946); // Primary action button & delete
  static const Color electricBlue  = Color(0xFF4361EE); // Secondary button & chips
  static const Color textWhite     = Color(0xFF1E293B); // Primary text (slate-800)
  static const Color softGrey      = Color(0xFF64748B); // Subtitles, hints & icons (slate-500)
  static const Color goldenYellow  = Color(0xFFD97706); // Cinema emblems & Watched badge (amber-600)
}

/// Simple data model representing a movie in the user's watchlist.
class Movie {
  final String id;
  String title;
  String genre;
  bool isWatched;
  int? releaseYear;
  int rating; // 1 to 5 stars (0 = unrated)

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    this.isWatched = false,
    this.releaseYear,
    this.rating = 0,
  });
}
