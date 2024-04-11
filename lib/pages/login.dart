import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/widgets/form_container_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify/spotify.dart' as spotify_api;
import 'package:songbird/classes/spotifyHelper.dart';
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

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //_yourClass = YourClass();
    // Fetch artist information when LoginPage is initialized
    //_yourClass.fetchArtist();
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
        backgroundColor: Colors.blueGrey,//PAGE COLOR
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
                            "Log In",
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
                InkWell(
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
    User? user;
    try{
      user = await _auth.signInWithEmailAndPassword(email, password);
    } catch(e) {
      print(e);
      if (e is FirebaseAuthException){
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
      } else {
        print('An unexpected error has occurred: $e');
      }
      return;
    }
    
    if (user != null) {
      String userID = (FirebaseAuth.instance.currentUser?.uid)!;
      getUserDataFromFirestore(userID);
      Navigator.pushNamed(context, "/home");
    } 
  }
}