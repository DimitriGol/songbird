import 'package:flutter/material.dart';
import 'package:songbird/pages/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Animation duration
    );

    // Forward animation
    _controller.forward().then((_) {
      // Wait for additional 2 seconds after animation completes
      Future.delayed(Duration(seconds: 2), () {
        // Trigger navigation to login page
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // Set Scaffold background color to yellow
      body: Stack(
        children: [
          // Yellow background
          Positioned.fill(
            child: FadeTransition(
              opacity: _controller,
              child: Container(
                color: Colors.yellow,
              ),
            ),
          ),
          // Logo
          Center(
            child: FadeTransition(
              opacity: _controller,
              child: Image.asset(
                'lib/images/songbird_black_logo_and_text.png', // Image path
                width: 250, // Adjust width according to your preference
                height: 250, // Adjust height according to your preference
              ),
            ),
          ),
        ],
      ),
    );
  }
}
