import 'package:flutter/material.dart';
import 'package:medilink/pages/login.page.dart';
import 'package:medilink/pages/pharmacy.home.page.dart';
import 'package:medilink/pages/welcome.home.page.dart';
import 'package:medilink/utils/prefs.dart';
import 'package:medilink/widgets/medi_widgets.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  await SharedPreferencesHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediLink',
      theme: MediWidgets.theme, // Apply the custom theme
      debugShowCheckedModeBanner: false,
      home: const AuthCheckScreen(),
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  late Future<bool> _checkAuthFuture;

  @override
  void initState() {
    super.initState();
    _checkAuthFuture = _checkIfUserLoggedIn();
  }

  Future<bool> _checkIfUserLoggedIn() async {
    // Simulate a short delay to show splash/loading screen
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check if userId exists in shared preferences
    String? userId = SharedPreferencesHelper.getString('userId');
    return userId != null && userId.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAuthFuture,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        // Error state
        if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error.toString());
        }

        // Data received - check if user is logged in
        final bool isLoggedIn = snapshot.data ?? false;

        // Return the appropriate screen based on login status
        if (isLoggedIn) {
          String? role = SharedPreferencesHelper.getString("role");
          print(role);
          if (role == "pharmacy") {
            return const PharmacyHomePage();
          } else {
            return const WelcomeHomePage();
          }
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo could go here
            Image.asset(
              'assets/app-logo.jpg',
              height: 120,
              width: 120,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'MediLink',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _checkAuthFuture = _checkIfUserLoggedIn();
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// This is just for reference - you'll use your actual HomePage implementation
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediLink Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Log out functionality
              await SharedPreferencesHelper.remove('userId');
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to MediLink!'),
      ),
    );
  }
}
