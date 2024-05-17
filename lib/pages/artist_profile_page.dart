import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/main.dart';
import 'package:songbird/pages/likes_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.blue.withOpacity(0),), //makes back button appear
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
                //var currentIndex = 0;
                CarouselController controller = CarouselController();


                return Stack(
                  children: [
  
                    Center(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                // Artist Profile Picture
                                CircleAvatar(
                                  backgroundImage: NetworkImage(artistData["profile_pic"]),
                                  radius: 100,
                                ),

                                // Artist Name
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    artistData["username"],
                                    style: TextStyle(fontSize: 40, color: Colors.black87, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 1),

                                // Artist Description
                                Text(
                                  artistData["description"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15, color: const Color.fromARGB(205, 0, 0, 0)), 
                                ),
                                SizedBox(height: 8),
                                
                                //Social Media Icons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildSocialIcon(FontAwesomeIcons.spotify, artistData["spotify_link"]),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.apple, ""),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.instagram, ""),
                                    const SizedBox(width: 12),
                                    buildSocialIcon(FontAwesomeIcons.youtube, ""),

                                  ],
                                ),
                                SizedBox(height: 20),
                                
                                // Snippets
                                Stack(
                                  alignment: AlignmentDirectional.topCenter,
                                  children: [
                                    CarouselSlider(
                                      carouselController: controller,
                                      options: CarouselOptions(
                                        height: 180.0,
                                        enableInfiniteScroll: false,
                                        initialPage: 0,
                                        enlargeCenterPage: true,
                                        enlargeFactor: 0.3,
                                      ),
                                      items: snippetList.map((snippet) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return InkWell(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage('lib/images/carousel_card_background.png'),
                                                    fit: BoxFit.cover,
                                                    opacity: 0.9,
                                                    ),
                                                  // color: Color.fromARGB(255, 255, 223, 83)
                                                ),
                                                child: Center(                                                    
                                                  child: Text(
                                                    snippet.key,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                      color: Color.fromARGB(255, 255, 255, 255),
                                                      fontWeight: FontWeight.bold,
                                                      shadows: [
                                                        Shadow(
                                                          offset: Offset(2.0, 2.0), // Adjust the offset to control the position of the shadow
                                                          blurRadius: 3.0, // Adjust the blur radius to control the blur of the shadow
                                                          color: Color.fromARGB(255, 0, 0, 0), // Adjust the color to control the color of the shadow
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                launchUrl(Uri.parse(snippet.value));
                                              },
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                
                                // Dislike Button 
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Removes artist from likedArtist map
                                    CURRENT_USER.handleDislike(widget.artistUUID);

                                    decrementLikeCounter(widget.artistUUID);

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

  Widget buildSocialIcon(IconData icon, String link) => CircleAvatar(
    radius: 25,
    backgroundColor: Colors.yellow,
    child: Material(
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          launchUrl(Uri.parse(link));
        }, //does nothing at the moment
        child: Center(child: Icon(icon, size: 28)),
      ),
    ),
  );
}