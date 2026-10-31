# 🎬 Movie Hub - Modern Movie Watchlist Mobile App

A cinema-inspired, modern, and beginner-friendly Movie Watchlist Mobile App built using **Flutter and Dart**.

---

## 🌟 Overview & Cinema Theme

Movie Hub delivers a dark, immersive movie theatre experience right on your phone. It allows users to track their film watchlists, mark titles as watched, add new cinema favorites with genres, and organize their movie-watching journey.

### 🎨 Color Palette (Light Theme / Soft Off-White)
| Element | Hex Code | Description |
| :--- | :--- | :--- |
| **Main Background** | `#F5F7FA` | Soft Off-White |
| **Card Background** | `#FFFFFF` | Clean White Card & Modals |
| **Primary Button** | `#E63946` | Cinema Red |
| **Secondary Button / Accents** | `#4361EE` | Electric Blue |
| **Text Color** | `#1E293B` | Dark Slate (High Readability) |
| **Secondary Text** | `#64748B` | Slate Grey (Subtitles & Hints) |
| **Accent / Watched Badge** | `#D97706` | Amber Gold |

---

## ✨ Features

1. **Demo Login System**:
   - Clean email and password input fields with prefixes and visibility toggles.
   - Client-side validation: ensures non-empty fields, email format (`@` and `.`), and minimum password length (6+ characters).
   - Clear error banner alerts.
   - Smooth navigation to the Home Screen upon validation.
   - Note: Demo mode—no external Firebase or database required.

2. **Movie Hub Dashboard (Home Screen)**:
   - **Personalized Cinema Greeting**: Displays the user's username/email with cinema badge.
   - **Quick Stats Tracker**: Live count of **Total**, **Watched**, and **Want to Watch** movies.
   - **Pre-Loaded Sample Movies**: Includes classics (*Inception*, *Interstellar*, *The Dark Knight*, *Dune: Part Two*, *Spirited Away*) so the app never opens to an empty screen.
   - **Add Movie Modal**: Quick input for Movie Title and Genre with one-tap quick genre selector chips (*Action, Sci-Fi, Drama, Comedy, Thriller, Animation*).
   - **Status Toggle**: One-tap toggle between **Watched** (Golden Yellow badge) and **Want to Watch** (Electric Blue badge).
   - **Delete Movie**: Quick delete button with feedback SnackBar.
   - **Logout**: Secure confirmation dialog that routes back to the Login Screen using `Navigator.pushReplacement`.

---

## 📁 Project Structure

This project follows an organized, beginner-friendly modular architecture:

```text
Movie Hub/
├── lib/
│   ├── main.dart          # App entry point, theme setup & routing (~30 lines)
│   ├── login_screen.dart  # Login screen UI & basic input validation
│   ├── home_screen.dart   # Home screen, watchlist dashboard, modals & movie cards
│   └── movie.dart         # Movie data model & AppColors cinema theme palette
├── pubspec.yaml           # Flutter project dependencies and metadata
├── .gitignore             # Standard Flutter ignore configuration
└── README.md              # Documentation and interview guide
```

---

## 🚀 How to Run the App

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.0.0 or higher)
- Android Studio / VS Code or an Android/iOS emulator or Chrome browser.

### Commands

1. **Navigate to the project directory**:
   ```bash
   cd "Movie Hub"
   ```

2. **Get Flutter packages**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

*(Tip: You can select an emulator, physical device, or Chrome by passing `-d chrome` or `-d android`)*.

---

## 🧠 Core App Logic (~35 Lines)

The business logic of the app is kept clean, lightweight, and isolated inside `_MovieHomeScreenState` in `lib/home_screen.dart`:

```dart
// 1. Initial movies list
final List<Movie> _movies = [
  Movie(id: '1', title: 'Inception', genre: 'Sci-Fi / Action', isWatched: true),
  Movie(id: '2', title: 'Interstellar', genre: 'Sci-Fi / Adventure', isWatched: true),
  Movie(id: '3', title: 'The Dark Knight', genre: 'Action / Crime', isWatched: true),
  Movie(id: '4', title: 'Dune: Part Two', genre: 'Sci-Fi / Epic', isWatched: false),
  Movie(id: '5', title: 'Spirited Away', genre: 'Animation / Fantasy', isWatched: false),
];

// 2. Add Movie
void _addMovie(String title, String genre) {
  if (title.trim().isEmpty) return;
  setState(() {
    _movies.insert(0, Movie(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      genre: genre.trim().isEmpty ? 'General' : genre.trim(),
      isWatched: false,
    ));
  });
}

// 3. Toggle Watched / Not Watched Status
void _toggleWatchedStatus(String id) {
  setState(() {
    final movie = _movies.firstWhere((m) => m.id == id);
    movie.isWatched = !movie.isWatched;
  });
}

// 4. Delete Movie
void _deleteMovie(String id) {
  setState(() {
    _movies.removeWhere((m) => m.id == id);
  });
}

// 5. Logout
void _logout() {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
}
```

---

## 🎤 Interview Guide: Explain This Project Confidently

When discussing this project in a developer interview, highlight these key concepts:

### 1. Why `StatefulWidget` and `setState()`?
- **Answer**: 
  > *"I used `StatefulWidget` because the app needs to maintain dynamic data that changes over time—such as adding a movie, toggling watched status, and deleting items. When a user interacts with the app, calling `setState()` notifies the Flutter framework that the internal state has changed, prompting it to re-execute the `build()` method and update the UI efficiently."*

### 2. Why `ListView.builder` instead of a plain `Column`?
- **Answer**: 
  > *"A standard `Column` or `SingleChildScrollView` renders all children in memory at once. In contrast, `ListView.builder` creates items lazily (on-demand) only as they scroll into view. This provides `O(1)` memory efficiency and smooth 60/120fps scrolling even if the watchlist grows to hundreds of movies."*

### 3. Why `TextEditingController` and why call `dispose()`?
- **Answer**: 
  > *"I used `TextEditingController` to read and manipulate the text input of the movie title, genre, email, and password. In Flutter, controllers attach listeners to the operating system's text input channel. We must override `dispose()` and call `.dispose()` on our controllers to release system resources and prevent memory leaks when the widget is unmounted."*

### 4. What is the difference between `Navigator.push` and `Navigator.pushReplacement`?
- **Answer**: 
  > *"For the login and logout flows, I used `Navigator.pushReplacement`. Unlike `Navigator.push` which pushes a new route onto the stack, `pushReplacement` replaces the current route. This prevents the user from accidentally pressing the Android system 'Back' button to return to the login screen after already logging in, and vice versa when logging out."*

### 5. What design considerations were implemented?
- **Answer**: 
  > *"I adopted a cinema-inspired dark palette (`#101426` navy and `#202438` charcoal) with high-contrast accent colors like Cinema Red (`#E63946`) and Golden Yellow (`#FFC857`). This not only creates an authentic theatre vibe but also improves readability and reduces eye strain in mobile environments."*

