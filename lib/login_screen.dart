import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:woocommerce_app/app_config.dart';
import 'package:woocommerce_app/my_theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/jwt-auth/v1/token';

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter username', toastLength: Toast.LENGTH_LONG);
      return;
    }

    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter password', toastLength: Toast.LENGTH_LONG);
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'username': usernameController.text,
        'password': passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['token'];
      Fluttertoast.showToast(
          msg: 'Login Successful', toastLength: Toast.LENGTH_LONG);
      // You can save the token and perform authenticated actions.
      // Store the token in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', token);

      Navigator.pushNamed(context, '/products');
    } else {
      print('Login failed: ${response.body}');
      Fluttertoast.showToast(
          msg: 'Login failed: ${response.body}',
          toastLength: Toast.LENGTH_LONG);
      return;
    }
  }

  bool _isPasswordVisible = false;

  void togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MyTheme.background_color,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign In!', // Added "Sign In" text above the email text field
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.primary_color),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  labelStyle: TextStyle(
                    color: MyTheme.accent_color, // Change label text color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyTheme.accent_color, // Change border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyTheme.accent_color, // Use primary color
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.email,
                    color: MyTheme.accent_color,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: MyTheme.accent_color, // Change label text color
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyTheme.accent_color, // Change border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MyTheme.accent_color, // Use primary color
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: MyTheme.accent_color,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
                    child: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: MyTheme.accent_color,
                    ),
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  loginUser();
                  // Navigator.pushNamed(context, '/products');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      MyTheme.primary_color, // Change background color
                  minimumSize: const Size(100, 48), // Increase width
                ),
                child: const Text(
                  'Login',
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                child: Text(
                  'Not registered? Sign up',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primary_color),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
