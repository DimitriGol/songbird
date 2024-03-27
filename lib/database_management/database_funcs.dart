import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songbird/classes/users.dart';
import 'package:songbird/main.dart';

void uploadUserToFirestore(String userType, String uuid, String username, String profilePicture, Map<String, dynamic> likedArtists, Map<String, int> tasteTracker, String description, String spotifyLink, String appleMusicLink, String youtubeLink) async{
    final firestore = FirebaseFirestore.instance;

    try {
      if(userType == 'Artist'){
        CURRENT_USER = Artist(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker, spotifyLink: spotifyLink, appleMusicLink: appleMusicLink, youtubeLink: youtubeLink, description: description);
        DocumentReference userDocRef = firestore.collection("artists").doc(uuid);
        await userDocRef.set({
        'liked_artists': CURRENT_USER.likedArtists,
        'profile_pic': null,
        'taste_tracker': CURRENT_USER.tasteTracker,
        'username' : CURRENT_USER.username,
        'apple_music_link' : CURRENT_USER.appleMusicLink,
        'spotify_link' : CURRENT_USER.spotifyLink,
        'description' : CURRENT_USER.description,
        'youtube_link' : CURRENT_USER.youtubeLink,
        });
      }else if(userType == 'Listener'){
        CURRENT_USER = BaseListener(uuid: uuid, username: username, profilePicture: profilePicture, likedArtists: likedArtists, tasteTracker: tasteTracker);
        DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
        await userDocRef.set({
        'liked_artists': CURRENT_USER.likedArtists,
        'profile_pic': null,
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
  try{
    DocumentReference userDocRef = firestore.collection("listeners").doc(uuid);
    await userDocRef.get().then(
      (DocumentSnapshot doc) {
        print(doc.exists);
        final data = doc.data() as Map<String, dynamic>;
        print(data);
      },
    );
  } catch (e) {
    print('Error: $e');
  }
}