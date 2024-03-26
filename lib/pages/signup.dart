import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songbird/main.dart';
import 'package:songbird/pages/signup_survey.dart';
import 'package:songbird/widgets/form_container_widget.dart';
import '../firebase_auth/firebase_auth_class.dart';
import 'login.dart';
import 'signup_survey.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/database_management/database_funcs.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});


  @override
  State<SignUpPage> createState() => _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();


  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,//PAGE COLOR
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  'lib/images/songbird_black_logo_and_text.png',
                  width: 280, // Adjust width according to your preference
                  height: 120, // Adjust height according to your preference
                ),
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormContainerWidget(
                  controller: _usernameController,
                  hintText: "Username",
                  isPasswordField: false,
                ),
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
                  hintText: "Password (Minumum 6 characters)",
                  isPasswordField: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: GestureDetector(
                  onTap: _signUp,
                  child: Container(
                      width: 250,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.yellow, //SIGN UP BUTTON COLOR
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                          child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Already have an account?"),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    },
                    child: Text("Log In",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          //decoration: TextDecoration.underline,decorationColor: Colors.white, decorationThickness: 2 //THIS UNDERLINES LOG IN
                        )))
              ])
            ],
          ),
        ));
  }


  void _signUp() async {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;


    User? user = await _auth.signUpWithEmailAndPassword(email, password);
    String userID = (FirebaseAuth.instance.currentUser?.uid)!;
    Map<String, dynamic> likedArtist = {"randomUUID": null};
    Map<String, int> tasteTrack = {"HIPHOP": 1};


    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupSurveyPage()),
      );
      CURRENT_USER = BaseListener(uuid: userID, username: username, displayName: "", profilePicture: "", likedArtists: likedArtist, tasteTracker:  tasteTrack);
      uploadUserToFirestore();
    } else {
      print("Some error happened, user is null");
    }
  }
}
