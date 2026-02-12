import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/theme.dart';
import 'pages/onboarding_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduZel',
      theme: AppTheme.getTheme(),
      debugShowCheckedModeBanner: false,
      home: const _StartupWrapper(),
    );
  }
}

class _StartupWrapper extends StatefulWidget {
  const _StartupWrapper();

  @override
  State<_StartupWrapper> createState() => _StartupWrapperState();
}

class _StartupWrapperState extends State<_StartupWrapper> {
  late Future<Widget> _homeWidget;

  @override
  void initState() {
    super.initState();
    _homeWidget = _checkFirstTime();
  }

  Future<Widget> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Set first time to false for next launch
      await prefs.setBool('isFirstTime', false);
      return const OnboardingPage();
    } else {
      return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _homeWidget,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE91E63).withOpacity(0.08),
                    const Color(0xFFF48FB1).withOpacity(0.05),
                    Colors.white,
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const HomePage();
        } else {
          return snapshot.data ?? const HomePage();
        }
      },
    );
  }
}
