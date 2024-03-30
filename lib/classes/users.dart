//Classes for the users: Listeners and Artists

//Genre enums

import 'package:songbird/database_management/database_funcs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songbird/main.dart';

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

  void likeArtist(String artistId) async // I assume artistId is UUID.
  {
    final firestore = FirebaseFirestore.instance;
    likedArtists[artistId] = "";

    try
    {
      if (runtimeType.toString() == "Artist")
      {
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
        });
      }

      else if (runtimeType.toString() == "BaseListener"){
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
      });
      }

    } catch (e) {
      print('Error: $e');
    }
  }
}

class Artist extends BaseListener {
  Map<String, String> snippets;
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
    required this.snippets,
    required this.spotifyLink,
    required this.appleMusicLink, 
    required this.youtubeLink,
    required this.description,
  });
} //Listener