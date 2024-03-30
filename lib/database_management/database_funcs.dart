import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/main.dart';

void uploadUserToFirestore(String userType, String uuid, String username, String profilePicture, Map<String, dynamic> likedArtists, Map<String, int> tasteTracker, String description, String spotifyLink, String appleMusicLink, String youtubeLink) async{
    final firestore = FirebaseFirestore.instance;
    // CALL SPOTIFY FUNCTION TO RETRIEVE USER TRACKS AND IMAGE
    profilePicture = ""; //REPLACE THIS EMPTY STRING WITH THE ACTUAL URL
    try {
      if(userType == 'Artist'){
        //UPDATE ARTIST CLASS TO HAVE A DATA MEMBER FOR THE TRACKS TO BE STORED
        CURRENT_USER = Artist(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker, spotifyLink: spotifyLink, appleMusicLink: appleMusicLink, youtubeLink: youtubeLink, description: description);
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
        //'snippets' : CURRENT_USER.DATA MEMBER THAT STORES SNIPPETS
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

          Map<String, dynamic> artist_Map = Map.from(data["liked_artists"]);

          Map<String, int> taste_Map = Map.from(data['taste_tracker']);

          CURRENT_USER = BaseListener(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: artist_Map, tasteTracker: taste_Map);
          // print(CURRENT_USER.uuid);
          // print(CURRENT_USER.likedArtists);
          // print(CURRENT_USER.tasteTracker);
          // print(CURRENT_USER.runtimeType);
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

          Map<String, dynamic> artist_Map = Map.from(data["liked_artists"]);

          Map<String, int> taste_Map = Map.from(data['taste_tracker']);

          CURRENT_USER = Artist(uuid: uuid, username: data["username"], profilePicture: data["profile_pic"], likedArtists: artist_Map, tasteTracker: taste_Map, spotifyLink: data["spotify_link"], appleMusicLink: data["apple_music_link"], youtubeLink: data["youtube_link"], description: data["description"]);
          // print(CURRENT_USER.uuid);
          // print(CURRENT_USER.likedArtists);
          // print(CURRENT_USER.tasteTracker);
          // print(CURRENT_USER.runtimeType);
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