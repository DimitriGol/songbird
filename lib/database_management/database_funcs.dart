import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:songbird/main.dart';

void uploadUserToFirestore() async{
    final firestore = FirebaseFirestore.instance;

    try {
    DocumentReference userDocRef = firestore.collection("listeners").doc(CURRENT_USER.uuid);
      await userDocRef.set({
        'liked_artists': CURRENT_USER.likedArtists,
        'profile_pic': null,
        'taste_tracker': CURRENT_USER.tasteTracker,
        'username' : CURRENT_USER.username,
      });
    } catch (e) {
      print('Error: $e');
    }
}