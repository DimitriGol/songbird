import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/main.dart';
import 'package:songbird/classes/users.dart' as Users;
import 'package:spotify/spotify.dart' as Spotify;
import 'package:url_launcher/url_launcher.dart';


class ProfilePage extends StatefulWidget
{
   const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 200;
  final double profileHeight = 145;
  late bool isArtist;
  late String profilePic;
  
  @override
  void initState(){
    super.initState();
    isArtist = CURRENT_USER is Users.Artist;
    profilePic = isArtist ? CURRENT_USER.profilePicture : 'lib/images/songbird_black_logo.png';
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildCoverAndProfile(),
          buildContent(),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget buildCoverAndProfile() {
    final top = coverHeight - profileHeight /2;
    final bottom = profileHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(
          top: top,
          child: buildProfileImage()
        ),
      ],
    );
  }

  Widget buildCoverImage() => Container(
    color: Colors.grey,
    child: Image.network(
      'https://images.unsplash.com/photo-1485579149621-3123dd979885?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fG11c2ljfGVufDB8fDB8fHww',
      width: double.infinity,
      height: coverHeight,
      fit: BoxFit.cover,
    )
  );

  Widget buildProfileImage() => CircleAvatar(
    radius: profileHeight / 2,
    backgroundColor: Colors.grey.shade200,
    backgroundImage: NetworkImage(profilePic),
  );

  Widget buildContent() => Column(
    children: [
      const SizedBox(height: 8),
      Text(
        CURRENT_USER.username,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 2),
      Text(
        isArtist ? CURRENT_USER.description : "",
        style: TextStyle(color: Colors.grey.shade700)
      ),
      const SizedBox(height: 2),
      Text(
        isArtist ? 'Artist' : 'Listener',
        style: TextStyle(color: Colors.grey.shade700)
      ),
      const SizedBox(height: 20),

      isArtist ? buildSocialMediaSection() : SizedBox()
    ],
  );

  Widget buildSocialMediaSection() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      buildSocialIcon(FontAwesomeIcons.spotify, CURRENT_USER.spotifyLink),
      const SizedBox(height: 12),
      buildSocialIcon(FontAwesomeIcons.apple, CURRENT_USER.appleMusicLink),
      const SizedBox(height: 12),
      buildSocialIcon(FontAwesomeIcons.instagram, ""), //implement insta link
      const SizedBox(height: 12),
      buildSocialIcon(FontAwesomeIcons.youtube, CURRENT_USER.youtubeLink),

    ],
  );

  Widget buildSocialIcon(IconData icon, String link) => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 35,
          backgroundColor: Colors.yellow,
          child: Material(
            shape: CircleBorder(),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                launchUrl(Uri.parse(link));
              }, //does nothing at the moment
              child: Center(child: Icon(icon, size: 30)),
            ),
          ),
        ),
        SizedBox(width: 10),
        TextButton.icon(
          onPressed: (){
            showEditDialog(context, link);
          }, 
          icon: Icon(Icons.edit, color: Colors.grey.shade500),
          label: Text(
            "Edit Link", 
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ), 
      ]
    ),
  );

  void showEditDialog(BuildContext context, String currentLink) {
    final TextEditingController linkController = TextEditingController(text: currentLink);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Link"),
          content: TextField(
            controller: linkController,
            decoration: InputDecoration(
              labelText: "Link",
              hintText: "Enter new link",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                setState(() {
                  // Update the link with the new value
                  //CURRENT_USER.updateLink(linkController.text);
                  print(linkController.text);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


