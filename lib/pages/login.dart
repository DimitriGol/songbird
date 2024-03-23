import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songbird/widgets/form_container_widget.dart';
import 'package:spotify/spotify.dart' as swag;
import 'dart:convert';



import '../firebase_auth/firebase_auth_class.dart';
import 'signup.dart';


class LoginPage extends StatefulWidget {
  final Widget? child;
  const LoginPage({super.key, this.child});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  late YourClass _yourClass;


  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _yourClass = YourClass();
    // Fetch artist information when LoginPage is initialized
    _yourClass.fetchArtist();
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,//PAGE COLOR
        body: 
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'lib/images/songbird_black_logo_and_text.png',
                  width: 280, // Adjust width according to your preference
                  height: 120, // Adjust height according to your preference
                ),
              Text(
                "Login",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
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
                        color: Colors.yellow,//LOGIN BUTTON COLOR
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Dont have an account?"),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                        (route) => false,
                      );
                    },
                    child: Text("Sign Up",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                        )))
              ])
            ],
          ),
        ));
  }


  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;


    User? user = await _auth.signInWithEmailAndPassword(email, password);


    if (user != null) {
      Navigator.pushNamed(context, "/home");
    } else { //login error button
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed", textAlign: TextAlign.center,),
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

class YourClass {
  late final swag.SpotifyApiCredentials credentials;
  late final swag.SpotifyApi spotify;

  YourClass() {
    credentials = swag.SpotifyApiCredentials('25c17281eac544f7b24e184c57f9cd0e', '1311979a68c347b2ba8879d6f898add5');
    spotify = swag.SpotifyApi(credentials);
    print('accessing yourclass');
  }

Future<void> fetchArtist() async {
  try {
    final artist = await spotify.artists.get('0OdUWJ0sBjDrqHygGUXeCF');
    print('FETCHING ARTIST:  ');
    print('Name: ${artist.name}');
    print('Genres: ${artist.genres}');
  } catch (e) {
    print('Error fetching artist: $e');
  }
}}