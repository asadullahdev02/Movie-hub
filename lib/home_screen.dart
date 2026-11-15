import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'movie.dart';

/// Movie Hub Home Screen for managing the movie watchlist.
class MovieHomeScreen extends StatefulWidget {
  final String userEmail;

  const MovieHomeScreen({super.key, required this.userEmail});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  // ==========================================================================
  // CORE APP LOGIC & STATE
  // ==========================================================================

  // 1. Initial watchlist preloaded with cinema classics
  final List<Movie> _movies = [
    Movie(id: '1', title: 'Inception', genre: 'Sci-Fi / Action', isWatched: true, releaseYear: 2010, rating: 5),
    Movie(id: '2', title: 'Interstellar', genre: 'Sci-Fi / Adventure', isWatched: true, releaseYear: 2014, rating: 5),
    Movie(id: '3', title: 'The Dark Knight', genre: 'Action / Crime', isWatched: true, releaseYear: 2008, rating: 5),
    Movie(id: '4', title: 'Dune: Part Two', genre: 'Sci-Fi / Epic', isWatched: false, releaseYear: 2024, rating: 0),
    Movie(id: '5', title: 'Spirited Away', genre: 'Animation / Fantasy', isWatched: false, releaseYear: 2001, rating: 0),
  ];

  // Search & Filter State
  String _searchQuery = '';
  String _filterMode = 'All'; // 'All', 'Watched', 'Want to Watch'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filtered list getter based on search query and active tab
  List<Movie> get _filteredMovies {
    return _movies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          movie.genre.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;
      if (_filterMode == 'Watched') return movie.isWatched;
      if (_filterMode == 'Want to Watch') return !movie.isWatched;
      return true;
    }).toList();
  }

  // 2. Add Movie function
  void _addMovie(String title, String genre, int? year, int rating) {
    if (title.trim().isEmpty) return;
    setState(() {
      _movies.insert(
        0,
        Movie(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title.trim(),
          genre: genre.trim().isEmpty ? 'General' : genre.trim(),
          releaseYear: year,
          rating: rating,
          isWatched: rating > 0,
        ),
      );
    });
  }

  // 3. Toggle Watched / Not Watched status
  void _toggleWatchedStatus(String id) {
    setState(() {
      final movie = _movies.firstWhere((m) => m.id == id);
      movie.isWatched = !movie.isWatched;
      if (movie.isWatched && movie.rating == 0) {
        movie.rating = 4; // Default pleasant rating on watched
      }
    });
  }

  // 4. Update rating
  void _setMovieRating(String id, int rating) {
    setState(() {
      final movie = _movies.firstWhere((m) => m.id == id);
      movie.rating = rating;
      if (rating > 0) movie.isWatched = true;
    });
  }

  // 5. Delete Movie from watchlist
  void _deleteMovie(String id) {
    setState(() {
      _movies.removeWhere((m) => m.id == id);
    });
  }

  // 6. Logout and return to Login Screen
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // ==========================================================================
  // UI DIALOG: ADD MOVIE MODAL BOTTOM SHEET
  // ==========================================================================
  void _showAddMovieDialog() {
    final titleController = TextEditingController();
    final genreController = TextEditingController();
    final yearController = TextEditingController(text: DateTime.now().year.toString());
    String selectedQuickGenre = 'Action';
    int selectedRating = 0;

    final quickGenres = ['Action', 'Sci-Fi', 'Drama', 'Comedy', 'Thriller', 'Animation'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkCharcoal,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Modal Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cinemaRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.video_library_rounded, color: AppColors.cinemaRed),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Add Movie to Watchlist',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Movie Title Input
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.textWhite),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.movie_outlined, color: AppColors.goldenYellow),
                      labelText: 'Movie Title *',
                      labelStyle: const TextStyle(color: AppColors.softGrey),
                      hintText: 'e.g. Oppenheimer',
                      hintStyle: TextStyle(color: AppColors.softGrey.withValues(alpha: 0.6)),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.electricBlue, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Genre and Year Row
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: genreController,
                          style: const TextStyle(color: AppColors.textWhite),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category_outlined, color: AppColors.electricBlue),
                            labelText: 'Genre',
                            labelStyle: const TextStyle(color: AppColors.softGrey),
                            hintText: 'e.g. Sci-Fi',
                            hintStyle: TextStyle(color: AppColors.softGrey.withValues(alpha: 0.6)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: yearController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: AppColors.textWhite),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.softGrey, size: 18),
                            labelText: 'Year',
                            labelStyle: const TextStyle(color: AppColors.softGrey),
                            filled: true,
                            fillColor: const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick Genre Selector Chips
                  Wrap(
                    spacing: 8,
                    children: quickGenres.map((genre) {
                      final isSelected = selectedQuickGenre == genre;
                      return ChoiceChip(
                        label: Text(genre),
                        selected: isSelected,
                        selectedColor: AppColors.electricBlue,
                        backgroundColor: const Color(0xFFF1F5F9),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.softGrey,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedQuickGenre = genre;
                              genreController.text = genre;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Optional Initial Rating Stars
                  Row(
                    children: [
                      const Text('Rating: ', style: TextStyle(color: AppColors.softGrey, fontSize: 13)),
                      ...List.generate(5, (index) {
                        final starValue = index + 1;
                        final isFilled = starValue <= selectedRating;
                        return InkWell(
                          onTap: () {
                            setModalState(() {
                              selectedRating = (selectedRating == starValue) ? 0 : starValue;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Icon(
                              isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                              color: isFilled ? AppColors.goldenYellow : const Color(0xFFCBD5E1),
                              size: 24,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Action Buttons (Cancel / Add)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            foregroundColor: AppColors.softGrey,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final title = titleController.text.trim();
                            final genre = genreController.text.trim().isEmpty
                                ? selectedQuickGenre
                                : genreController.text.trim();
                            final year = int.tryParse(yearController.text.trim());

                            if (title.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a movie title.'),
                                  backgroundColor: AppColors.cinemaRed,
                                ),
                              );
                              return;
                            }

                            _addMovie(title, genre, year, selectedRating);
                            Navigator.pop(ctx);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added "$title" to your watchlist!'),
                                backgroundColor: const Color(0xFF1E293B),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.cinemaRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Add Movie',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================================
  // MAIN BUILD METHOD
  // ==========================================================================
  @override
  Widget build(BuildContext context) {
    final totalCount = _movies.length;
    final watchedCount = _movies.where((m) => m.isWatched).length;
    final unwatchedCount = totalCount - watchedCount;

    final userDisplayName = widget.userEmail.split('@').first;
    final displayedMovies = _filteredMovies;

    return Scaffold(
      backgroundColor: AppColors.cinematicNavy,
      appBar: AppBar(
        backgroundColor: AppColors.cinematicNavy,
        elevation: 0,
        centerTitle: false,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.theaters_rounded, color: AppColors.goldenYellow, size: 28),
        ),
        title: const Text(
          'Movie Hub',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          // Logout Button with confirmation dialog
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, color: AppColors.softGrey),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Row(
                    children: [
                      Icon(Icons.logout_rounded, color: AppColors.cinemaRed),
                      SizedBox(width: 10),
                      Text('Logout', style: TextStyle(color: AppColors.textWhite)),
                    ],
                  ),
                  content: const Text(
                    'Are you sure you want to log out of Movie Hub?',
                    style: TextStyle(color: AppColors.softGrey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.softGrey)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.cinemaRed,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _logout();
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Floating Action Button to quickly add movies
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMovieDialog,
        backgroundColor: AppColors.cinemaRed,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Movie',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ------------------------------------------------------------------
          // WELCOME & METRICS HEADER CARD
          // ------------------------------------------------------------------
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkCharcoal,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.stars_rounded, color: AppColors.goldenYellow, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back,',
                            style: TextStyle(fontSize: 13, color: AppColors.softGrey),
                          ),
                          Text(
                            userDisplayName.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Statistics Counter Badges
                Row(
                  children: [
                    _buildStatPill('Total', '$totalCount', AppColors.electricBlue),
                    const SizedBox(width: 8),
                    _buildStatPill('Watched', '$watchedCount', AppColors.goldenYellow),
                    const SizedBox(width: 8),
                    _buildStatPill('Want to Watch', '$unwatchedCount', AppColors.softGrey),
                  ],
                ),
              ],
            ),
          ),

          // ------------------------------------------------------------------
          // LIVE SEARCH BAR
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              style: const TextStyle(color: AppColors.textWhite, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search movies by title or genre...',
                hintStyle: TextStyle(color: AppColors.softGrey.withValues(alpha: 0.7), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.softGrey, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, color: AppColors.softGrey, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.darkCharcoal,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // FILTER TABS (ALL / WATCHED / WANT TO WATCH)
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip('All', totalCount),
                const SizedBox(width: 8),
                _buildFilterChip('Watched', watchedCount),
                const SizedBox(width: 8),
                _buildFilterChip('Want to Watch', unwatchedCount),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // ------------------------------------------------------------------
          // MOVIE CARDS LIST (ListView.builder)
          // ------------------------------------------------------------------
          Expanded(
            child: displayedMovies.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_movies_outlined,
                          size: 64,
                          color: AppColors.softGrey.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No movies match "$_searchQuery"'
                              : 'No movies in this filter!',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.softGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap "Add Movie" to add new cinema titles.',
                          style: TextStyle(fontSize: 13, color: AppColors.softGrey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
                    itemCount: displayedMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayedMovies[index];
                      return _buildMovieCard(movie);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // HELPER WIDGET: FILTER CHIP
  // ==========================================================================
  Widget _buildFilterChip(String label, int count) {
    final isSelected = _filterMode == label;
    return GestureDetector(
      onTap: () => setState(() => _filterMode = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.electricBlue : AppColors.darkCharcoal,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.electricBlue : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.softGrey,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // HELPER WIDGET: STAT PILL
  // ==========================================================================
  Widget _buildStatPill(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.softGrey),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // HELPER WIDGET: MOVIE CARD ITEM
  // ==========================================================================
  Widget _buildMovieCard(Movie movie) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.darkCharcoal,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Cinema Icon Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: movie.isWatched
                    ? const Color(0xFFFEF3C7)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                movie.isWatched ? Icons.check_circle_rounded : Icons.movie_outlined,
                color: movie.isWatched ? AppColors.goldenYellow : AppColors.electricBlue,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),

            // Movie Name, Genre, Year & Ratings
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textWhite,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (movie.releaseYear != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${movie.releaseYear})',
                          style: TextStyle(fontSize: 12, color: AppColors.softGrey.withValues(alpha: 0.8)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Genre
                  Row(
                    children: [
                      const Icon(Icons.label_outline, size: 13, color: AppColors.softGrey),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          movie.genre,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.softGrey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Status Chip & Star Rating Row
                  Row(
                    children: [
                      // Watched Status Badge Button
                      GestureDetector(
                        onTap: () => _toggleWatchedStatus(movie.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: movie.isWatched
                                ? const Color(0xFFFEF3C7)
                                : const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: movie.isWatched
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF93C5FD),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                movie.isWatched ? Icons.done_all_rounded : Icons.schedule_rounded,
                                size: 12,
                                color: movie.isWatched ? AppColors.goldenYellow : AppColors.electricBlue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.isWatched ? 'Watched' : 'Want to Watch',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: movie.isWatched ? AppColors.goldenYellow : AppColors.electricBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Interactive Rating Stars (Shown when watched)
                      if (movie.isWatched) ...[
                        Row(
                          children: List.generate(5, (starIdx) {
                            final ratingValue = starIdx + 1;
                            final isFilled = ratingValue <= movie.rating;
                            return InkWell(
                              onTap: () => _setMovieRating(movie.id, ratingValue),
                              child: Icon(
                                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 16,
                                color: isFilled ? AppColors.goldenYellow : const Color(0xFFCBD5E1),
                              ),
                            );
                          }),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Action: Delete Movie Option
            IconButton(
              tooltip: 'Delete Movie',
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.cinemaRed),
              onPressed: () {
                final movieTitle = movie.title;
                _deleteMovie(movie.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Removed "$movieTitle"'),
                    backgroundColor: const Color(0xFF1E293B),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
