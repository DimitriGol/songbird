import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify/spotify.dart' as spotify_api;
import 'package:songbird/main.dart';



Future<String?> getSpotifyLink(String UUID) async {
  try {
    final DocumentSnapshot artistDoc = await FirebaseFirestore.instance.collection('artists').doc(UUID).get();

    if (artistDoc.exists) {
      final spotifyLink = artistDoc['spotify_link'] as String?;
      print('Spotify Link: $spotifyLink');
      return spotifyLink;
    } else {
      print('getSpotifyLink: Artist with UUID $UUID does not exist.');
      return null;
    }
  } catch (e) {print('Error fetching artist: $e');return null;}
}

Future<String?> getDescription(String UUID) async {
  try {
    final DocumentSnapshot artistDoc = await FirebaseFirestore.instance.collection('artists').doc(UUID).get();

    if (artistDoc.exists) {
      final description = artistDoc['description'] as String?;
      print('Description: $description');
      return description;
    } 
    else 
    {
      print('getDescription: Artist with UUID $UUID does not exist.');
      return null;
    }
  } catch (e) {print('Error fetching artist: $e');return null;}
}

class SpotifyHelper {
  late final spotify_api.SpotifyApiCredentials credentials;
  late final spotify_api.SpotifyApi spotify;

  SpotifyHelper() {
    String clientID = dotenv.env['CLIENT_ID']!;
    String clientSecret = dotenv.env['CLIENT_SECRET']!;

    credentials = spotify_api.SpotifyApiCredentials(clientID, clientSecret);
    spotify = spotify_api.SpotifyApi(credentials);
  }

  Future<String?> getArtistName(String UUID) async {
    try {
      final spotifyLink = await getSpotifyLink(UUID);
      final RegExp regex = RegExp(r'artist\/([a-zA-Z0-9]+)');
      final match = regex.firstMatch(spotifyLink ?? '');

      if (match != null) 
      {
        final artistId = match.group(1); // Extract the artist ID
        final artist = await spotify.artists.get(artistId!);
        print('Artist Name: $artist.name');
        return artist.name;
      } 
      else 
      {
        print('getArtistName Function: Artist ID not found in the Spotify link.');
        return null;
      }
    } catch (e) { print('Error fetching artist name: $e');return null;}
  }

  Future<Iterable<spotify_api.Track>?> getTopTracks(String UUID) async
  {
    try 
    {
    final spotifyLink = await getSpotifyLink(UUID);
    final RegExp regex = RegExp(r'artist\/([a-zA-Z0-9]+)');
    final match = regex.firstMatch(spotifyLink ?? ''); 

    if (match != null) 
    {
        final artistId = match.group(1); // Extract the artist ID
        final USA = spotify_api.Market.US;

        final topTracks = await spotify.artists.topTracks(artistId!, USA);

        print('Top Tracks:');
          for (var track in topTracks) 
          {
            print('${track.name}');
          }

        return topTracks;
    } 
    else 
    {
        print('getTopTracks Function: Artist ID not found in the Spotify link.');
        return null;
    }
    } catch (e) {print('Error fetching top tracks: $e');return null;}
  }

  Future<String?> getArtistImage (String UUID) async
  {
    try 
    {
      final spotifyLink = await getSpotifyLink(UUID);
      final RegExp regex = RegExp(r'artist\/([a-zA-Z0-9]+)');
      final match = regex.firstMatch(spotifyLink ?? ''); 

      if (match != null) 
      {
          final artistId = match.group(1); // Extract the artist ID
          final artist = await spotify.artists.get(artistId!); 
          String? imageLink = artist.images!.first.url;
          print('Image Link:$imageLink');
          return imageLink;
      }
    } catch (e) {print('Error fetching Image Link: $e');return null;}
  }
}