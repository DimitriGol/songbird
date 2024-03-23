import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey, //PAGE COLOR
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
              "Login",
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
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
                    color: Colors.yellow, //LOGIN BUTTON COLOR
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Login",
                      style:
                          TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
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
                    "Sign Up",
                    style: TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            SpotifyLoginButton(), // <-- Add Spotify login button here
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      Navigator.pushNamed(context, "/home");
    } else {
      //login error button
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Login Failed",
              textAlign: TextAlign.center,
            ),
            content: Text(
              "The login was unsuccessful. Please check your credentials and try again.",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}

class SpotifyLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _loginToSpotify,
        child: Container(
          width: 250,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.green, // Spotify login button color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Login with Spotify",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  void _loginToSpotify() async {
    try {
      await RemoteServices();
      // Add any navigation or further action upon successful Spotify login
    } catch (e) {
      // Handle errors if any
      print('Error logging in to Spotify: $e');
      // You can show a snackbar or dialog to inform the user about the error.
    }
  }

  static Future<void> RemoteServices() async {
    AccessTokenResponse? accessToken;
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
        redirectUri: 'my.music.app://callback', customUriScheme: 'my.music.app');
    var authResp = await client.requestAuthorization(
        clientId: '25c17281eac544f7b24e184c57f9cd0e',
        customParams: {'show_dialog': 'true'},
        scopes: [
          'user-read-private',
          'user-read-playback-state',
          'user-modify-playback-state',
          'user-read-currently-playing',
          'user-read-email'
        ]);
    var authCode = authResp.code;

    accessToken = await client.requestAccessToken(
        code: authCode.toString(),
        clientId: '25c17281eac544f7b24e184c57f9cd0e',
        clientSecret: '1311979a68c347b2ba8879d6f898add5');

    var Access_Token = accessToken.accessToken;
    var Refresh_Token = accessToken.refreshToken;
  }
}
