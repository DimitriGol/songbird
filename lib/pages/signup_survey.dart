import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songbird/main.dart';
import 'package:songbird/pages/signup_survey.dart';
import 'package:songbird/widgets/form_container_widget.dart';
import '../firebase_auth/firebase_auth_class.dart';
import 'login.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/database_management/database_funcs.dart';

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
  Map<String, dynamic> likedArtistMap = {};
  Map<String, int> tasteTrackerMap = {"CLASSICAL": 0, "COUNTRY": 0, "EDM": 0, "HIPHOP": 0, "HOUSE": 0, "POP": 0, "RAP": 0, "R&B" : 0, "ROCK": 0};

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
        backgroundColor: isSelected
            ? MaterialStateProperty.all(Colors.yellow)
            : null,
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
        // Spotify Link
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FormContainerWidget(
            controller: _spotifyLink,
            hintText: "Spotify Link",
          ),
        ),
        // //Apple Music Link
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: FormContainerWidget(
        //     controller: _appleMusicLink,
        //     hintText: "Apple Music Link",
        //   ),
        // ),
        // // Youtube Link
        // Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: FormContainerWidget(
        //     controller: _youtubeLink,
        //     hintText: "Youtube Link",
        //   ),
        // ),
      ],
    );
  }

  void _submitQuestionnaire() {
    // (uncomment this when the implementation is created to make the user an ARTIST if user selects Artist)
    // // Update CURRENT_USER's data members if they login as an Artist 
    // CURRENT_USER.description = _description;
    // CURRENT_USER.spotifyLink = _spotifyLink;
    // CURRENT_USER.appleMusicLink = _appleMusicLink;
    // CURRENT_USER.youtubeLink = _youtubeLink;

    // update CURRENT_USER's taste tracker and print it out
    // for (int i=0; i<selectedGenres.length; i++){
    //   String genre = selectedGenres[i].toUpperCase();
      
    //   CURRENT_USER.tasteTracker[genre] += 1;
    // }
    // print('Taste Tracker' + CURRENT_USER.tasteTracker);
    
    // print('Description' + _description.text);
    // print('Links:\n' + _spotifyLink.text + '\n' + _appleMusicLink.text + '\n' + _youtubeLink.text);
    
    // Print out selected genres and user type
    print('Selected Genres: $selectedGenres');
    print('User Type: $userType');

    //print user's info
    // print('Username:' + CURRENT_USER.username);
    // print('Description:' + CURRENT_USER.description);
    // print('Spotify Link:' + CURRENT_USER.spotifyLink);
    // print('Apple Music Link' + CURRENT_USER.appleMusicLink);
    // print('Youtube Link' + CURRENT_USER.youtubeLink);

    for (int i=0; i<selectedGenres.length; i++){
      String genre = selectedGenres[i].toUpperCase();
      
      tasteTrackerMap[genre] = 1;
    }

    uploadUserToFirestore(userType, userID, widget.username, "", likedArtistMap, tasteTrackerMap, _description.text, _spotifyLink.text, _appleMusicLink.text, _youtubeLink.text);

    //Navigate to the home page
    Navigator.pushNamed(context, "/home");

  }
}
