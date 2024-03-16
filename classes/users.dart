//Classes for the users: Listeners and Artists

//Genre enums
enum Genres { classical, country, edm, hiphop, house, pop, rap, rnb, rock}

// Listener
class Listener {
  final String uuid;
  String username;
  String displayName;
  String profilePicture;
  Map<String, dynamic> likedArtists;
  Map<Genres, int> tasteTracker;

  Listener({
    required this.uuid,
    required this.username,
    required this.displayName,
    required this.profilePicture,
    required this.likedArtists,
    required this.tasteTracker,
  });

  void likeArtist(String artistId, List<Genres> genres){
    //Puts the artist's uuid in the Listener's likedArtists map
    //When a listener likes a listener's song, it increases the values in it's tasteTracker map
  }
}

class Artist extends Listener {
  List<String> snippets;
  String spotifyLink;
  String appleMusicLink;
  String youtubeLink;
  String description;

  Artist({
    required String uuid,
    required String username,
    required String displayName,
    required String profilePicture,
    required Map<String, dynamic>likedArtists,
    required Map<Genres, int>tasteTracker,
    required this.snippets,
    required this.spotifyLink,
    required this.appleMusicLink, 
    required this.youtubeLink,
    required this.description,
  }) : super(
      uuid: uuid,
      username: username,
      displayName: displayName,
      profilePicture: profilePicture,
      likedArtists: likedArtists,
      tasteTracker: tasteTracker,
    );
} //Listener