import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:songbird/main.dart';
import 'package:songbird/pages/signup_survey.dart';
import 'package:songbird/widgets/form_container_widget.dart';
import '../firebase_auth/firebase_auth_class.dart';
import 'login.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'dart:collection';
import 'package:songbird/pages/splash_screen.dart';

class SignupSurveyPage extends StatefulWidget {
  const SignupSurveyPage({super.key, required this.username});
  final String username;

  @override
  _SignupSurveyPageState createState() => _SignupSurveyPageState();
}

class _SignupSurveyPageState extends State<SignupSurveyPage> {
  List<String> selectedGenres = [];
  String userType = '';
  String userID = (FirebaseAuth.instance.currentUser?.uid)!;
  var likedArtistMap = LinkedHashMap<String, bool>();
  Map<String, int> tasteTrackerMap = {"CLASSICAL": 0, "COUNTRY": 0, "EDM": 0, "HIPHOP": 0, "HOUSE": 0, "POP": 0, "RAP": 0, "R&B": 0, "ROCK": 0};

  // Extra data members for Artist class 
  TextEditingController _description = TextEditingController();
  TextEditingController _spotifyLink = TextEditingController();
  TextEditingController _appleMusicLink = TextEditingController();
  TextEditingController _youtubeLink = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Signup Survey'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select your three favorite genres:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildGenreButton('Classical'),
                _buildGenreButton('Country'),
                _buildGenreButton('EDM'),
                _buildGenreButton('Hip Hop'),
                _buildGenreButton('House'),
                _buildGenreButton('Pop'),
                _buildGenreButton('Rap'),
                _buildGenreButton('R&B'),
                _buildGenreButton('Rock'),
              ],
            ),
            SizedBox(height: 30),
            Text(
              'Are you an artist or a listener?',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUserTypeButton('Artist'),
                SizedBox(width: 20),
                _buildUserTypeButton('Listener'),
              ],
            ),
            if (userType == 'Artist') ...[
              SizedBox(height: 20),
              _buildArtistForms(),
            ],
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitQuestionnaire,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreButton(String genre) {
    bool isSelected = selectedGenres.contains(genre);
    bool canSelect = selectedGenres.length < 3 || isSelected;

    return ElevatedButton(
      onPressed: canSelect
          ? () {
              setState(() {
                if (isSelected) {
                  selectedGenres.remove(genre);
                } else {
                  selectedGenres.add(genre);
                }
              });
            }
          : null,
      style: ButtonStyle(
        backgroundColor: isSelected ? MaterialStateProperty.all(Colors.yellow) : null,
      ),
      child: Text(genre),
    );
  }

  Widget _buildUserTypeButton(String type) {
    bool isSelected = userType == type;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          userType = type;
        });
      },
      style: ButtonStyle(
        backgroundColor: isSelected ? MaterialStateProperty.all(Colors.yellow) : null,
      ),
      child: Text(type),
    );
  }

  Widget _buildArtistForms() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormContainerWidget(
            controller: _description,
            hintText: "Tell Us About Yourself", //implement character limit later
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormContainerWidget(
            controller: _spotifyLink,
            hintText: "Spotify Link",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormContainerWidget(
            controller: _appleMusicLink,
            hintText: "Apple Music Link",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormContainerWidget(
            controller: _youtubeLink,
            hintText: "YouTube Link",
          ),
        ),
      ],
    );
  }

  void _submitQuestionnaire() {

    if (userType == 'Artist' && (_description.text.isEmpty || _spotifyLink.text.isEmpty)) {
      _showErrorDialog('Description and Spotify link are mandatory for artists.');
      return;
    }

    for (int i = 0; i < selectedGenres.length; i++) {
      String genre = selectedGenres[i].toUpperCase();
      tasteTrackerMap[genre] = 1;
    }

    uploadUserToFirestore(userType, userID, widget.username, "", likedArtistMap, tasteTrackerMap, _description.text, _spotifyLink.text, _appleMusicLink.text, _youtubeLink.text);

    // Navigate to the home page
    Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen(toExplorePage: true)),
          );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
