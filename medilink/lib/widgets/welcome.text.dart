import 'package:flutter/material.dart';
import 'package:medilink/services/user.service.dart';
import 'package:medilink/utils/prefs.dart';

class WelcomeTitle extends StatefulWidget {
  const WelcomeTitle({
    super.key,
  });

  @override
  _WelcomeTitleState createState() => _WelcomeTitleState();
}

class _WelcomeTitleState extends State<WelcomeTitle> {
  Map<String, dynamic>? user; // Store user data
  bool isLoading = true; // Track loading state
  String errorMessage = ''; // Store error messages

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the widget is initialized
  }

  // Fetch user data by ID
  Future<void> _fetchUserData() async {
    try {
      String? userId = SharedPreferencesHelper.getString("userId");
      if (userId != null) {
        final userData = await UserService.getUserById(userId);
        setState(() {
          user = userData;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load user data: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: CircularProgressIndicator()); // Show loading indicator
    }

    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage)); // Show error message
    }

    if (user == null) {
      return const Center(child: Text('User not found')); // Handle null user
    }

    // Display welcome message with the user's name
    return Text(
      'Welcome, ${user!['name']}!',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
