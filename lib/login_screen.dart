import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'movie.dart';

/// Login Screen with demo authentication and input validation.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Text controllers to capture user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for validation feedback and password toggle
  String? _errorMessage;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Basic input validation for demo login system
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 1. Check if email is empty
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Please enter your email address.');
      return;
    }

    // 2. Simple email format validation
    if (!email.contains('@') || !email.contains('.')) {
      setState(() => _errorMessage = 'Please enter a valid email address.');
      return;
    }

    // 3. Check if password is empty
    if (password.isEmpty) {
      setState(() => _errorMessage = 'Please enter your password.');
      return;
    }

    // 4. Password minimum length check
    if (password.length < 6) {
      setState(() => _errorMessage = 'Password must be at least 6 characters.');
      return;
    }

    // Clear error message on valid input
    setState(() => _errorMessage = null);

    // Navigate to Movie Hub Home Screen, replacing the login route
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MovieHomeScreen(userEmail: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cinematicNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cinema Icon Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.darkCharcoal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.movie_filter_rounded,
                    size: 64,
                    color: AppColors.goldenYellow,
                  ),
                ),
                const SizedBox(height: 20),

                // App Title
                const Text(
                  'Movie Hub',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                const Text(
                  'Your Cinema Watchlist & Personal Tracker',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.softGrey,
                  ),
                ),
                const SizedBox(height: 32),

                // Login Card Container
                Container(
                  padding: const EdgeInsets.all(22.0),
                  decoration: BoxDecoration(
                    color: AppColors.darkCharcoal,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Email Input Field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: AppColors.textWhite),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.softGrey),
                          labelText: 'Email Address',
                          labelStyle: const TextStyle(color: AppColors.softGrey),
                          hintText: 'e.g. filmfan@cinema.com',
                          hintStyle: TextStyle(color: AppColors.softGrey.withOpacity(0.6)),
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
                      const SizedBox(height: 16),

                      // Password Input Field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: AppColors.textWhite),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.softGrey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.softGrey,
                            ),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: AppColors.softGrey),
                          hintText: 'Minimum 6 characters',
                          hintStyle: TextStyle(color: AppColors.softGrey.withOpacity(0.6)),
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
                      const SizedBox(height: 12),

                      // Error Message Banner (Shown on validation failure)
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.cinemaRed.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cinemaRed.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: AppColors.cinemaRed, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: AppColors.cinemaRed, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Login Button (Cinema Red)
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.cinemaRed,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_movies_rounded, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Enter Movie Hub',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Demo Notice
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline, size: 16, color: AppColors.goldenYellow),
                      SizedBox(width: 8),
                      Text(
                        'Demo Mode: Enter any valid email & 6+ character password',
                        style: TextStyle(fontSize: 12, color: AppColors.softGrey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
