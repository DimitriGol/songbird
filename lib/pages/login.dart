import 'dart:convert';
import 'dart:html' as html; // Import dart:html for web-specific functionality
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:songbird/widgets/form_container_widget.dart';

import '../firebase_auth/firebase_auth_class.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/songbird_black_logo_and_text.png',
              width: 280,
              height: 120,
            ),
            Text(
              'Login',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormContainerWidget(
                controller: _emailController,
                hintText: 'Email',
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormContainerWidget(
                controller: _passwordController,
                hintText: 'Password',
                isPasswordField: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: _signIn,
                child: Container(
                  width: 250,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginWithSpotify,
              child: Text('Login with Spotify'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\'t have an account?'),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Sign in user with Firebase Authentication
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      // Navigate to home page
      Navigator.pushNamed(context, "/home");
    } else {
      // Display login error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Login Failed',
              textAlign: TextAlign.center,
            ),
            content: Text(
              'The login was unsuccessful. Please check your credentials and try again.',
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _loginWithSpotify() {
    final clientId = '25c17281eac544f7b24e184c57f9cd0e';
    final redirectUri = 'https://www.google.com'; // Replace with your redirect URI
    final List<String> scopes = ['user-read-private', 'user-read-email'];

    final authorizationUrl =
        'https://accounts.spotify.com/authorize?client_id=$clientId&redirect_uri=$redirectUri&scope=${scopes.join('%20')}&response_type=code';

    // Open Spotify authorization page in a new tab/window
    html.window.open(authorizationUrl, 'Spotify Login');

    // Print message indicating successful call to Spotify's Web API
    print('Successfully initiated Spotify login process');
  }
}
