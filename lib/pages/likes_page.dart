import 'package:flutter/material.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/main.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/pages/artist_profile_page.dart';
import 'package:flutter/cupertino.dart';


class LikesPage extends StatefulWidget
{
   const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}


class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    // Accessing likedArtists from CURRENT_USER
    // Map<String, dynamic> likedArtists = CURRENT_USER.likedArtists;
    // print(CURRENT_USER.likedArtists);

    
    return Scaffold(
      body: 
        FutureBuilder(
          builder: (ctx, snapshot){
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
              }
              // if we got our data
              else if (snapshot.hasData) {
                // Extracting data from snapshot object
                final artistData = snapshot.data as Map<String, Map<String,String>>;
                
                // No liked artists, have message saying the list is empty
                if (artistData.isEmpty){
                  return(
                    Center(
                      child: 
                        Text(
                          "You haven't liked any artists yet!"
                        )
                      )
                  );
                }
                // Output list of artists
                else{
                  // print(artistData);
                  return Padding(
                    padding: const EdgeInsets.all(10.0), // Set the padding for the entire ListView
                    child: Center(
                      child: ListView(
                        children: artistData.entries.map((entry) {
                          String artistUUID = entry.key;
                          String artistName = entry.value["username"]!;
                          String artistProfilePicture = entry.value["profile_pic"]!;

                          // getUserDataFromFirestore(artistUUID);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => ArtistProfilePage(artistUUID: artistUUID)),
                              );
                            },
                            child: ListTile(
                              minVerticalPadding: 15,
                              leading: CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.grey,
                                //display artist profile picture
                                backgroundImage: NetworkImage(
                                  artistProfilePicture
                                )
                              ),
                              //display artist name
                              title: Text(
                                artistName, 
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 17
                                )
                              ),
                            ),
                          );
                        }).toList()
                      ),
                    ),
                  );
                }
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          future: likesPageMap(CURRENT_USER.likedArtists), 
        )  
    );
  }
}