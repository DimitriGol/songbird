import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/database_management/database_funcs.dart';
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
    return MaterialApp(
      home: Scaffold(
        body:ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildCoverAndProfile(),
            isArtist ? buildArtistStats() : buildListenerStats(),
            SizedBox(height: 20),
            isArtist ? buildSocialMediaSection() : SizedBox(),
          ],
        ),
      )
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

  Widget buildListenerStats() => Column(
    children: [

      const SizedBox(height: 8),
      //Username
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            CURRENT_USER.username,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 25),
            color: Colors.grey.shade700,
            onPressed: () {
              showEditDialog(context, CURRENT_USER.username, 'username');
            },
          ),
        ],
      ),
      const SizedBox(height: 2),
  
      //Listener Text
      Text(
        'Listener',
        style: TextStyle(color: Colors.grey.shade700)
      ),
    ],
  );

  Widget buildArtistStats() => Column(
    children: [
      Text(
        'Artist',
        style: TextStyle(color: Colors.grey.shade800)
      ),
      const SizedBox(height: 8),
      //Username
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            CURRENT_USER.username,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 25),
            color: Colors.grey.shade700,
            onPressed: () {
              showEditDialog(context, CURRENT_USER.username, 'username');
            },
          ),
        ],
      ),
      
      //Artist Text
      
      const SizedBox(height: 2),

      //Description
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            CURRENT_USER.description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 15)
          ),
          IconButton(
            icon: Icon(Icons.edit, size: 15),
            color: Colors.grey.shade700,
            onPressed: () {
              showEditDialog(context, CURRENT_USER.description, 'description');
            },
          ),
        ],
      ),
      const SizedBox(height: 2),
      
      //Likes Counter
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            CURRENT_USER.likesCounter.toString() + (" Likes"),
            style: TextStyle(color: Colors.grey.shade700)
          ),
          Icon(
            Icons.favorite_border,
            color: Colors.red.shade500,
            size: 20,
          )
        ],
      ),
      const SizedBox(height: 2),
      
      
      const SizedBox(height: 20),
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
      SizedBox(height: 30),
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
            showEditDialog(context, link, 'link');
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

  void showEditDialog(BuildContext context, String currentText, String field) {
    final TextEditingController controller = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit ${field == 'username' ? 'Username' : field == 'description' ? 'Description' : 'Link'}"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: field == 'username' ? 'Username' : field == 'description' ? 'Description' : 'Link',
              hintText: "Enter new ${field == 'username' ? 'username' : field == 'description' ? 'description' : 'link'}",
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
                  switch (field) {
                    case 'username':
                      profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.username = controller.text;
                      break;
                    case 'description':
                      profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.description = controller.text;
                      break;
                    case 'spotifyLink':
                      profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.spotifyLink = controller.text;
                      break;
                    case 'appleMusicLink':
                      profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.appleMusicLink = controller.text;
                      break;
                    case 'instagramLink':
                      //profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.instagramLink = controller.text;
                      break;
                    case 'youtubeLink':
                      profilePageUpdateLinks(field, controller.text);
                      CURRENT_USER.youtubeLink = controller.text;
                      break;
                  }
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


