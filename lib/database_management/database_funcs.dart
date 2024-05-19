import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songbird/classes/spotifyHelper.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/main.dart';
import 'dart:collection';

void uploadUserToFirestore(String userType, String uuid, String username, String profilePicture, LinkedHashMap<String, bool> likedArtists, Map<String, int> tasteTracker, String description, String spotifyLink, String appleMusicLink, String youtubeLink) async{
    final firestore = FirebaseFirestore.instance;

    final SpotifyHelp = SpotifyHelper();
    await SpotifyHelp.getArtistImage(spotifyLink);
    await SpotifyHelp.getTopTracks(spotifyLink);
    profilePicture = SpotifyHelp.imageUrl;
    try {
      if(userType == 'Artist'){
        CURRENT_USER = Artist(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker, spotifyLink: spotifyLink, appleMusicLink: appleMusicLink, youtubeLink: youtubeLink, description: description, snippets: SpotifyHelp.trackMaps, likesCounter: 0);
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': CURRENT_USER.likedArtists,
        'profile_pic': CURRENT_USER.profilePicture,
        'taste_tracker': CURRENT_USER.tasteTracker,
        'username' : CURRENT_USER.username,
        'apple_music_link' : CURRENT_USER.appleMusicLink,
        'spotify_link' : CURRENT_USER.spotifyLink,
        'description' : CURRENT_USER.description,
        'youtube_link' : CURRENT_USER.youtubeLink,
        'snippets' : CURRENT_USER.snippets,
        'likes_counter' : 0
        });
      }else if(userType == 'Listener'){
        CURRENT_USER = BaseListener(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker);
        DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
        await userDocRef.set({
        'liked_artists': CURRENT_USER.likedArtists,
        'profile_pic': CURRENT_USER.profilePicture,
        'taste_tracker': CURRENT_USER.tasteTracker,
        'username' : CURRENT_USER.username,
        });
      }
    } catch (e) {
      print('Error: $e');
    }
}

void getUserDataFromFirestore(String uuid) async{
  final firestore = FirebaseFirestore.instance;
  bool secondCheck = false;

  try{
    DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
    await userDocRef.get().then(
      (DocumentSnapshot doc) {
        if(doc.exists == false){
          secondCheck = true;
        }else{
          final data = doc.data() as Map<String, dynamic>;

          LinkedHashMap<String, bool> artist_Map = LinkedHashMap.from(data["liked_artists"]);

          Map<String, int> taste_Map = Map.from(data['taste_tracker']);

          CURRENT_USER = BaseListener(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: artist_Map, tasteTracker: taste_Map);
        }
      },
    );
  } catch (e) {
    print('Error: $e');
  }

  if(secondCheck){
    try{
      DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
      await userDocRef.get().then(
      (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;

          LinkedHashMap<String, bool> artist_Map = LinkedHashMap.from(data["liked_artists"]);
          Map<String, String> snippets_Map = Map.from(data["snippets"]);
          Map<String, int> taste_Map = Map.from(data['taste_tracker']);
          CURRENT_USER = Artist(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: artist_Map, tasteTracker: taste_Map, spotifyLink: data["spotify_link"], appleMusicLink: data["apple_music_link"], youtubeLink: data["youtube_link"], description: data["description"], snippets: snippets_Map, likesCounter: data["likes_counter"]);
        }
    );
    }catch (e) {
      print('Error: $e');
    }
  }
}

Future<Map<String, dynamic>> explorePageMap(String uuid) async
{
  var data;
  final firestore = FirebaseFirestore.instance;
  try{
      DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
      await userDocRef.get().then(
      (DocumentSnapshot doc) {
          data = doc.data() as Map<String, dynamic>;
        }
    );
    }catch (e) {
      print('Error: $e');
    }

    return data;
}

Future<List<String>> getArtistIDs () async
{
  final firestore = FirebaseFirestore.instance;
  List<String> artistList = [];
  await firestore.collection("artists").get().then((value) => {
    for(var docSnapshot in value.docs){
      if(CURRENT_USER.likedArtists.containsKey(docSnapshot.id) == false || CURRENT_USER.likedArtists[docSnapshot.id] == false){
        artistList.add(docSnapshot.id)
      }
    }
  },
  );
  return artistList;
}

Future<Map<String, Map<String, String>>> likesPageMap(LinkedHashMap<String, bool> likedArtists) async 
{
 Map<String, Map<String, String>> result = {};

  final firestore = FirebaseFirestore.instance;
  try{
    for (var artistID in likedArtists.entries){
      if(artistID.value == true){
        DocumentReference userDocRef = firestore.collection("artists").doc(artistID.key);
        await userDocRef.get().then(
          (DocumentSnapshot doc) {
            final data = doc.data() as Map<String, dynamic>;
            // print(artistID.key);
            // print(data["username"]);                     
            // print(data["profile_pic"]);  

            result[artistID.key] = {
              "username": data["username"],
              "profile_pic": data["profile_pic"],
            };
          }
        );
      }
    }
    }catch (e) {
      print('Error: $e');
    }

  return result;
}

void incrementLikeCounter(String artistUUID) async {
  final firestore = FirebaseFirestore.instance;
  var artist = firestore.collection("artists").doc(artistUUID);
  artist.update({
    "likes_counter" : FieldValue.increment(1)
  });
}

void decrementLikeCounter(String artistUUID) async {
  final firestore = FirebaseFirestore.instance;
  var artist = firestore.collection("artists").doc(artistUUID);
  await artist.get().then((DocumentSnapshot doc) {
    final data = doc.data() as Map;
    if(!data.containsKey("likes_counter")){
      artist.update({
      "likes_counter" : FieldValue.increment(0)
      });
    }else if(data["likes_counter"] > 0){
      artist.update({
      "likes_counter" : FieldValue.increment(-1)
      });
    }
  });
}

void profilePageUpdateLinks(String spotifyLink, String appleMusicLink, String youtubeLink, String description, String username) async {

  final firestore = FirebaseFirestore.instance;
  DocumentReference userDocRef = firestore.collection("artists").doc(CURRENT_USER.uuid);
  userDocRef.update({
    "username" : username,
    "description" : description,
    "spotify_link" : spotifyLink,
    "apple_music_link": appleMusicLink,
    "youtube_link" : youtubeLink
    });
}