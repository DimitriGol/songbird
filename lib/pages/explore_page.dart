import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/classes/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ExplorePage extends StatefulWidget
{
   const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


class _ExplorePageState extends State<ExplorePage> {
  final style = TextStyle(fontSize: 60, fontWeight: FontWeight.bold);
  final description = TextStyle(fontSize: 16, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/pixel_space.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${test_artist.username}',
                        style: GoogleFonts.honk(
                          textStyle: style,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      test_artist.profilePicture,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${test_artist.description}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.chakraPetch(
                        textStyle: description,
                      ),
                    ),
             
                    SizedBox(height: 8),
                    Text(
                      '[INSERT SONGS HERE]',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.chakraPetch(
                        textStyle: description,
                        color: Colors.yellow,
                      ),
                    ),

                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(test_artist.spotifyLink));
                      },
                      icon: Icon(FontAwesomeIcons.spotify, color: Colors.white),
                      label: Text(
                        'Check Out My Spotify',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle DISLIKE button press
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                // Container(
                //   width: 80,
                //   height: 80,
                //   child: Image.asset('lib/images/black_cat.gif'),
                  
                // ),
                ElevatedButton(
                  onPressed: () {
                    // Handle LIKE button press
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





//THIS WAS A TEST USER, KEEPING INCASE TESTING IS NEEDED AGAIN
Artist test_artist = Artist(
  uuid:'08172001', 
  username:'DylanOnMars', 
  //displayName: 'DylanOnMars', 
  profilePicture: 'lib/images/midtermPFP.jpg', 
  likedArtists: {},
  tasteTracker: {},
  //snippets: ['snippet1', 'snippet2'],
  spotifyLink:'https://open.spotify.com/artist/7Mtf0UrDmV5JUU5uAziNRA?si=51Yg1h--TDuPOs1jZRxpng',
  appleMusicLink: '',
  youtubeLink:'',
  description:'I\'m trappin out my mama\'s basement frfr\n☜(⌒▽⌒)☞');



