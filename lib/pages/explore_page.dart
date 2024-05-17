import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/classes/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:songbird/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/classes/spotifyHelper.dart';
import 'dart:async';
import 'dart:math';
import 'package:songbird/pages/likes_page.dart';
import 'package:songbird/pages/profile_page.dart';
import 'package:songbird/pages/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';


class ExplorePage extends StatefulWidget
{
  const ExplorePage({super.key, required this.artistUUID, required this.onStartUp});
  final String artistUUID;
  final bool onStartUp;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


class _ExplorePageState extends State<ExplorePage> {
  final style = TextStyle(fontSize: 60, fontWeight: FontWeight.bold);
  final description = TextStyle(fontSize: 16, color: Colors.white);
  int currentIndex = 1;

  final pages = [
    LikesPage(),
    ExplorePage(artistUUID: 'ZtnDhgH0nIUEWcD5E5CGXrHBrsE3', onStartUp: false), //first artist
    ProfilePage()
  ];

  // @override
  // void initState(){
  //   super.initState();
  //   idList = getArtistIDs();
  //   Future.delayed( //NEED THIS DELAY TO ENSURE CURRENT_USER IS INITIALIZED BEFORE PAGE IS BUILT
  //     Duration(seconds: 3),
  //     () {

  //     },
  //   );
  // }

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
              final artistData = snapshot.data![0] as Map<String, dynamic>;
              final idList = snapshot.data![1] as List<String>;

              Map<String, String> snippets_Map = Map.from(artistData["snippets"]);
              var snippetList = snippets_Map.entries.toList();

              final random = Random();
              CarouselController controller = CarouselController();
              if(CURRENT_USER.likedArtists[widget.artistUUID] == true){
                    //print(idList);
                    if(idList.isEmpty){
                        return(
                          Center(
                            child:
                            Text(
                              "No more artists left to see! D:"
                              )
                            )
                          );
                      }else{
                        Future.delayed( //NEED THIS DELAY TO ENSURE WIDGET IS BUILT BEFORE NAVIGATING
                          Duration(milliseconds: 500),
                          () {
                            
                        String next = idList[(random.nextInt(idList.length)) % 17];
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ExplorePage(artistUUID: next, onStartUp: true)),
                          );
                        //Navigator.of(context).push(PageRouteBuilder(opaque: false, pageBuilder: (BuildContext context, _, __) => ExplorePage(artistUUID: next, onStartUp:  true)));
                          },
                        );
                      }
              }else{
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/sunset.png'),
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
                                child: Stack(
                                  children: [
                                    Text(
                                    artistData['username'],
                                    style: GoogleFonts.graduate(
                                      textStyle: TextStyle(
                                        fontSize: 60, fontWeight: FontWeight.bold,),
                                  
                                      shadows:<Shadow>[
                                          Shadow(
                                            blurRadius: 50.0,
                                            color: Color.fromARGB(255, 0, 195, 255),
                                          ),
                                        ], 

                                      color: Color.fromARGB(255, 255, 255, 255)
                                      
                                      
                                    ),
                                  ),
                                ]),
                              ),
                              SizedBox(height: 8),
                              CircleAvatar(
                                radius: 100,
                                backgroundColor: Colors.grey,
                                //display artist profile picture
                                backgroundImage: NetworkImage(
                                  artistData["profile_pic"]
                                )
                              ),
                              SizedBox(height: 8),
                              Card(
                                shape:StadiumBorder(),
                              child: ListTile(
                                shape:StadiumBorder(),
                                tileColor: Color.fromARGB(255, 124, 77, 235),
                                title: Text("About Me", style: GoogleFonts.chakraPetch(textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.white)),),
                                subtitle: Text(artistData["description"],
                                //textAlign: TextAlign.center,
                                style: GoogleFonts.chakraPetch(textStyle: description, fontStyle: FontStyle.italic),),
                                )
                                
                                ),
                      
                              SizedBox(height: 8),
                            
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
                              if(idList.isNotEmpty){
                                String next = idList[(random.nextInt(idList.length)) % 17];
                                CURRENT_USER.handleDislike(widget.artistUUID);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExplorePage(artistUUID: next, onStartUp: true)),
                                );
                              }else{
                                CURRENT_USER.handleDislike(widget.artistUUID);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text('No more artists to see! D:'),
                                    );
                                  }
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.all(10),
                            ),
                            child: Icon(
                              Icons.thumb_down,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),

                          ElevatedButton(
                            onPressed: () {
                              // Handle LIKE button press
                              if(idList.isNotEmpty){
                                incrementLikeCounter(widget.artistUUID);
                                String next = idList[(random.nextInt(idList.length)) % 17];
                                CURRENT_USER.handleLike(widget.artistUUID);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ExplorePage(artistUUID: next, onStartUp: true)),
                                );
                              }else{
                                incrementLikeCounter(widget.artistUUID);
                                CURRENT_USER.handleLike(widget.artistUUID);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text('No more artists to see! D:'),
                                      );
                                    }
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              backgroundColor: Colors.blue,
                              padding: EdgeInsets.all(10),
                            ),
                            child: Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ], // Children
                );
              }
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }, // Builder
        future: Future.wait([explorePageMap(widget.artistUUID), getArtistIDs()]), 
      )
    );
  }
}

