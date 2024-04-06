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
        //UPDATE ARTIST CLASS TO HAVE A DATA MEMBER FOR THE TRACKS TO BE STORED
        CURRENT_USER = Artist(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker, spotifyLink: spotifyLink, appleMusicLink: appleMusicLink, youtubeLink: youtubeLink, description: description, snippets: SpotifyHelp.trackMaps);
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

          //Map<String, dynamic> artist_Map = Map.from(data["liked_artists"]);

          Map<String, int> taste_Map = Map.from(data['taste_tracker']);

          CURRENT_USER = BaseListener(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: data["liked_artists"], tasteTracker: taste_Map);
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

          //Map<String, dynamic> artist_Map = Map.from(data["liked_artists"]);
          Map<String, String> snippets_Map = Map.from(data["snippets"]);
          Map<String, int> taste_Map = Map.from(data['taste_tracker']);

          CURRENT_USER = Artist(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: data["liked_artists"], tasteTracker: taste_Map, spotifyLink: data["spotify_link"], appleMusicLink: data["apple_music_link"], youtubeLink: data["youtube_link"], description: data["description"], snippets: snippets_Map);
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

List<String> getArtistIDs()
{
  final firestore = FirebaseFirestore.instance;
  List<String> artistList = [];
  firestore.collection("artists").get().then((value) => {
    for(var docSnapshot in value.docs){
      artistList.add(docSnapshot.id)
    }
  },);
  return artistList;
}

Future<Map<String, String>> likesPageMap(Map<String, dynamic> likedArtists) async 
{
  Map<String, String> result = {};

  final firestore = FirebaseFirestore.instance;
  try{
    for (var artistID in likedArtists.entries){
      DocumentReference userDocRef = firestore.collection("artists").doc(artistID.key);
      await userDocRef.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;       
          // print(data["username"]);
          result[data["username"]] = data["profile_pic"];
        }
      );
    }
    }catch (e) {
      print('Error: $e');
    }

  return result;
}