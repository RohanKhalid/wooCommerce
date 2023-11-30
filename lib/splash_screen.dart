import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:woocommerce_app/my_theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration:
          const Duration(seconds: 5), // Total duration for fade-in animation
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // Adjust the curve as needed
    );

    _animationController.forward();

    // Listen for animation completion
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Animation completed, navigate to the next screen
        navigateToNextScreen();
      }
    });
  }

  Future<void> navigateToNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');

    Future.delayed(const Duration(seconds: 1), () {
      if (userToken != null && userToken.isNotEmpty) {
        Navigator.pushNamed(context, '/main');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.background_color,
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              'assets/logo.png',
              width: 250, // Constrain the logo width as needed
              height: 250, // Constrain the logo height as needed
            ),
          ),
        ),
      ),
    );
  }
}
