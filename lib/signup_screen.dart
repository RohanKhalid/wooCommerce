import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'app_config.dart';
import 'my_theme.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final String apiUrl = '${AppConfig.BASE_URL}/wc/v3/customers';
  final String consumerKey = AppConfig.Consumer_Key;
  final String consumerSecret = AppConfig.Consumer_Secret;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signupUser() async {
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter username', toastLength: Toast.LENGTH_LONG);
      return;
    }

    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter email', toastLength: Toast.LENGTH_LONG);
      return;
    }

    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please enter password', toastLength: Toast.LENGTH_LONG);
      return;
    }
    final response = await http.post(
      Uri.parse(
          '$apiUrl?consumer_key=$consumerKey&consumer_secret=$consumerSecret'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('User registered with ID: ${responseData['id']}');
      Fluttertoast.showToast(
          msg: 'Registration Successful', toastLength: Toast.LENGTH_LONG);
      // You can navigate to a success page or perform other actions.
      Navigator.pushNamed(context, '/');
    } else {
      print('Registration failed: ${response.body}');

      Fluttertoast.showToast(
          msg: 'Registration failed: ${response.body}',
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
                'Sign Up!', // Added "Sign In" text above the email text field
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
                  labelText: 'Username',
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
                    Icons.person,
                    color: MyTheme.accent_color,
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                  signupUser();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      MyTheme.primary_color, // Change background color
                  minimumSize: const Size(100, 48), // Increase width
                ),
                child: const Text('Sign up'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  'Already have an account? Sign in',
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
