import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:woocommerce_app/main_view.dart';
import 'package:woocommerce_app/product_screen.dart';
import 'package:woocommerce_app/signup_screen.dart';
import 'package:woocommerce_app/splash_screen.dart';

import 'login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('userToken');

  runApp(MyApp(userToken: userToken));
}

class MyApp extends StatelessWidget {
  final String? userToken;
  const MyApp({super.key, this.userToken});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/main',
      routes: {
        '/': (context) =>
            SplashScreen(), // Use SplashScreen as the initial screen
        '/login': (context) => LoginScreen(),
        '/signUp': (context) => SignupScreen(),
        '/main': (context) => MainAppScreen(),
        '/home': (context) => const ProductScreen(),
      },
    );
  }
}
