//Classes for the users: Listeners and Artists

//Genre enums

import 'package:songbird/database_management/database_funcs.dart';

enum Genres { classical, country, edm, hiphop, house, pop, rap, rnb, rock}

// Listener
class BaseListener {
  final String uuid;
  String username;
  //String displayName;
  String profilePicture;
  Map<String, dynamic> likedArtists;
  Map<String, int> tasteTracker;

  BaseListener({
    required this.uuid,
    required this.username,
    //required this.displayName,
    required this.profilePicture,
    required this.likedArtists,
    required this.tasteTracker,
  });

  void likeArtist(String artistId) // I assume artistId is UUID.
  {
    //Puts the artist's uuid in the Listener's likedArtists map
    //When a listener likes a listener's song, it increases the values in it's tasteTracker map

    likedArtists[artistId] = ""; // stores genre preferences into the likedArtist map using UUID.


     uploadUserToFirestore(); // upload user data to firestore.
     // import cloud firestore
  }
}

class Artist extends BaseListener {
  //List<String> snippets;
  String spotifyLink;
  String appleMusicLink;
  String youtubeLink;
  String description;

  Artist({
    required super.uuid,
    required super.username,
    //required super.displayName,
    required super.profilePicture,
    required super.likedArtists,
    required super.tasteTracker,
    //required this.snippets,
    required this.spotifyLink,
    required this.appleMusicLink, 
    required this.youtubeLink,
    required this.description,
  });
} //Listener