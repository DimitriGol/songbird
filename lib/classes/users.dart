//Classes for the users: Listeners and Artists

//Genre enums

import 'dart:collection';

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
  /*This LinkedHashMap member variable will hold Artist Unique IDs as the keys of the map
    and then a bool to keep track of whether the CURRENT_USER liked or disliked the artist.
  */
  LinkedHashMap<String, bool> likedArtists;
  //Map<String, dynamic> likedArtists;
  Map<String, int> tasteTracker;

  BaseListener({
    required this.uuid,
    required this.username,
    //required this.displayName,
    required this.profilePicture,
    required this.likedArtists,
    required this.tasteTracker,
  });

  void handleLike(String artistId) async // I assume artistId is UUID.
  {
    final firestore = FirebaseFirestore.instance;
    likedArtists[artistId] = true;

    try
    {
      if (this is Artist)
      {
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
        },
        SetOptions(merge: true)
        );
      }

      else{
        DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
      }, 
      
      SetOptions(merge: true));
      }

    } catch (e) {
      print('Error: $e');
    }
  }

  void handleDislike(String artistId) async // I assume artistId is UUID.
  {
    final firestore = FirebaseFirestore.instance;
    likedArtists[artistId] = false;

    try
    {
      if (this is Artist)
      {
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
        },
        SetOptions(merge: true)
        );
      }

      else{
        DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
        await userDocRef.set({
        'liked_artists': likedArtists,
      }, 
      
      SetOptions(merge: true));
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
  int likesCounter;

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
    required this.likesCounter,
  });
} //Listener