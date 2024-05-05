import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/main.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/pages/likes_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistProfilePage extends StatefulWidget
{
  const ArtistProfilePage({super.key, required this.artistUUID});
  final String artistUUID;

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              // if we got our data
              else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final artistData = snapshot.data as Map<String, dynamic>;
                Map<String, String> snippets_Map = Map.from(artistData["snippets"]);
                var snippetList = snippets_Map.entries.toList(); 
                

                return Stack(
                  children: [
                      
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap:() {
                            Navigator.pop(
                                            context);
                                           
                          },
                          child: 
                          Container(
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
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
                                // Artist Name
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    artistData["username"],
                                    style: TextStyle(fontSize: 30, color: Colors.black87, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Artist Profile Picture
                                Image.network(
                                  artistData["profile_pic"],
                                  width: 200,
                                  height: 200,
                                ),
                                SizedBox(height: 3),

                                // Artist Description
                                Text(
                                  artistData["description"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: const Color.fromARGB(205, 0, 0, 0)), 
                                ),
                                SizedBox(height: 10),

                                // Artist Snippets + Spotify Link
                                buildSnippetLink(snippetList[0]),
                                SizedBox(height: 8),
                                buildSnippetLink(snippetList[1]),
                                SizedBox(height: 8),
                                buildSnippetLink(snippetList[2]),
                                SizedBox(height: 8),
                                // ElevatedButton.icon(
                                //   onPressed: () {
                                //     launchUrl(Uri.parse(artistData["spotify_link"]));
                                //   },
                                //   icon: Icon(FontAwesomeIcons.spotify, color: Colors.white),
                                //   label: Text(
                                //     'Check Out My Spotify',
                                //     style: TextStyle(color: Colors.white),
                                //   ),
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.green,
                                //   ),
                                // ),
                                Text(
                                  "Check out my social media!"
                                ),
                                SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildSocialIcon(FontAwesomeIcons.spotify),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.apple),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.instagram),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.youtube),

                                  ],
                                ),
                                SizedBox(height: 40),
                                // Dislike Button 
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Removes artist from likedArtist map
                                    CURRENT_USER.handleDislike(widget.artistUUID);

                                    //Redirects user to likes page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LikesPage()),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.thumb_down,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  label: Text(
                                    'Dislike',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700
                                  ),
                                ),
                                
                              ]
                          ),
                        )
                      )
                    )
                  ]
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

  Widget buildSnippetLink(dynamic snippet){
    return ElevatedButton.icon(
      onPressed: () {
        launchUrl(Uri.parse(snippet.value));
      },
      icon: Icon(FontAwesomeIcons.spotify, color: Colors.white),
      label: Text(
        snippet.key,
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.yellow,
      )
    );
  }

  Widget buildSocialIcon(IconData icon) => CircleAvatar(
      radius: 20,
      backgroundColor: Colors.yellow,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {}, //does nothing at the moment
          child: Center(child: Icon(icon, size: 25)),
        ),
      ),
    );
}