import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/classes/users.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spotify/spotify.dart' as spotify_api;

class ExplorePage extends StatefulWidget
{
  final Artist artist;
  const ExplorePage({Key? key, required this.artist}): super(key:key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}


class _ExplorePageState extends State<ExplorePage> {

  YourClass yourClass = YourClass();
  final style = TextStyle(fontSize: 60, fontWeight: FontWeight.bold);
  final description = TextStyle(fontSize: 16, color: Colors.white);

  void initState()
  {
    super.initState();
    getSpotifyLink('BGJPSQwABJM8XDw4VasS5O9cxGo1');
    yourClass.fetchArtist('BGJPSQwABJM8XDw4VasS5O9cxGo1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/pixel_space.gif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${test_artist.username}',
                        style: GoogleFonts.honk(
                          textStyle: style,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Image.asset(
                      test_artist.profilePicture,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${test_artist.description}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.chakraPetch(
                        textStyle: description,
                      ),
                    ),
             
                    SizedBox(height: 8),
                    Text(
                      '[INSERT SONGS HERE]',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.chakraPetch(
                        textStyle: description,
                        color: Colors.yellow,
                      ),
                    ),

                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        launchUrl(Uri.parse(test_artist.spotifyLink));
                      },
                      icon: Icon(FontAwesomeIcons.spotify, color: Colors.white),
                      label: Text(
                        'Check Out My Spotify',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle DISLIKE button press
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.thumb_down,
                    color: Colors.white,
                    size: 60,
                  ),
                ),

                // Container(
                //   width: 80,
                //   height: 80,
                //   child: Image.asset('lib/images/black_cat.gif'),
                  
                // ),
                ElevatedButton(
                  onPressed: () {
                    // Handle LIKE button press
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





//THIS WAS A TEST USER, KEEPING INCASE TESTING IS NEEDED AGAIN
Artist test_artist = Artist(
  uuid:'08172001', 
  username:'DylanOnMars', 
  //displayName: 'DylanOnMars', 
  profilePicture: 'lib/images/midtermPFP.jpg', 
  likedArtists: {},
  tasteTracker: {},
  //snippets: ['snippet1', 'snippet2'],
  spotifyLink:'https://open.spotify.com/artist/7Mtf0UrDmV5JUU5uAziNRA?si=51Yg1h--TDuPOs1jZRxpng',
  appleMusicLink: '',
  youtubeLink:'',
  description:'I\'m trappin out my mama\'s basement frfr\n☜(⌒▽⌒)☞');

  Future<String?> getSpotifyLink(String UUID) async
  {
    try
    {
      final DocumentSnapshot artistDoc = await FirebaseFirestore.instance.collection('artists').doc(UUID).get();

      if (artistDoc.exists)
      {
        final spotifyLink = artistDoc['spotify_link'] as String?;
        print('Spotify Link: $spotifyLink');
        return spotifyLink;
      }

      else
      {
        print('Artist with UUID $UUID does not exist.');
        return null;
      }
    }catch (e){print('Error fetching artist: $e');return null;}
  }

Future main() async {
  await dotenv.load(fileName: "assets/.env");
}

class YourClass {
  late final spotify_api.SpotifyApiCredentials credentials;
  late final spotify_api.SpotifyApi spotify;

  YourClass() {

    String clientID = dotenv.env['CLIENT_ID']!;
    String clientSecret = dotenv.env['CLIENT_SECRET']!;

    credentials = spotify_api.SpotifyApiCredentials(clientID, clientSecret);
    spotify = spotify_api.SpotifyApi(credentials);
  }


  Future<void> fetchArtist(String UUID) async 
  {
    try {
    // Call getSpotifyLink to retrieve the Spotify link
      final spotifyLink = await getSpotifyLink(UUID);

    // Use regex to extract artist ID from the Spotify link
      final RegExp regex = RegExp(r'artist\/([a-zA-Z0-9]+)');
      final match = regex.firstMatch(spotifyLink ?? '');

      if (match != null) {
        final artistId = match.group(1); // Extract the artist ID
        final spotify = spotify_api.SpotifyApi(credentials);

        final artist = await spotify.artists.get(artistId!); // Fetch artist using the extracted artist ID

        print('FETCHING ARTIST (DEBUG):');
        print('Name: ${artist.name}');
        print('Images: ${artist.images!.first.url}');

      // Specify the market for top tracks (in this example, 'US' for United States)
        final USA = spotify_api.Market.US;

      // Fetch top tracks of the artist
        final topTracks = await spotify.artists.topTracks(artistId, USA);
       print('Top Tracks:');
       for (var track in topTracks) {
         print('${track.name}');
        }
      } else {
        print('Artist ID not found in the Spotify link.');
      }
    } catch (e) {print('Error fetching artist: $e');}
  }

  Future<String?> getArtistName (String UUID) async
  {
    try
    {
      final spotifyLink = await getSpotifyLink(UUID);
      final RegExp regex = RegExp(r'artist\/([a-zA-Z0-9]+)');
      final match = regex.firstMatch(spotifyLink ?? '');

      if (match != null)
      {
        final artistId = match.group(1); // Extract the artist ID
        final spotify = spotify_api.SpotifyApi(credentials);
        final artist = await spotify.artists.get(artistId!);

        return artist.name;
      }

    }
    catch (e)
    {

    }
  }
}