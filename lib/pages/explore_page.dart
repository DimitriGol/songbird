import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/classes/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/classes/spotifyHelper.dart';
import 'dart:async';

class ExplorePage extends StatefulWidget
{
  const ExplorePage({super.key, required this.artistUUID});
  final String artistUUID;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


class _ExplorePageState extends State<ExplorePage> {
  final style = TextStyle(fontSize: 60, fontWeight: FontWeight.bold);
  final description = TextStyle(fontSize: 16, color: Colors.white);




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      FutureBuilder(
        builder: (ctx, snapshot) {
    // Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
      // If we got an error
        if (snapshot.hasError) {
        return Center(
          child: Text(
            '${snapshot.error} occurred',
            style: TextStyle(fontSize: 18),
          ),
        );
         
        // if we got our data
      } else if (snapshot.hasData) {
        // Extracting data from snapshot object
        final artistData = snapshot.data as Map<String, dynamic>;
        return Stack(
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
                        artistData['username'],
                        style: GoogleFonts.honk(
                          textStyle: style,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.network(
                      artistData["profile_pic"],
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 8),
                    Text(
                      artistData['description'],
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
                        launchUrl(Uri.parse(artistData['spotify_link']));
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
      );

    
      }

      

    }
      return Center(
        child: CircularProgressIndicator(),
        );
  },
     future: explorePageMap(widget.artistUUID), 
  )
    );
  }
  
}

