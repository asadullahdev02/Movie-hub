import 'package:flutter_test/flutter_test.dart';
import 'package:movie_hub/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('Movie initializes with correct properties and default values', () {
      final movie = Movie(
        id: '101',
        title: 'Interstellar',
        genre: 'Sci-Fi / Space',
        releaseYear: 2014,
      );

      expect(movie.id, '101');
      expect(movie.title, 'Interstellar');
      expect(movie.genre, 'Sci-Fi / Space');
      expect(movie.isWatched, false);
      expect(movie.releaseYear, 2014);
      expect(movie.rating, 0);
    });

    test('Movie status and rating updates correctly', () {
      final movie = Movie(
        id: '102',
        title: 'Inception',
        genre: 'Sci-Fi / Action',
        releaseYear: 2010,
      );

      // Mark as watched and assign 5 stars
      movie.isWatched = true;
      movie.rating = 5;

      expect(movie.isWatched, true);
      expect(movie.rating, 5);
    });
  });
}
