import 'dart:html';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:songbird/database_management/database_funcs.dart';
import 'package:songbird/main.dart';
import 'package:songbird/classes/users.dart' as Users;
import 'package:spotify/spotify.dart' as Spotify;
import 'package:url_launcher/url_launcher.dart';
import 'package:songbird/widgets/form_container_widget.dart';

class ProfilePage extends StatefulWidget
{
   const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 200;
  final double profileHeight = 175;
  late bool isArtist;
  late String profilePic;
  //static final GlobalKey<FormState> myFormKey = GlobalKey<FormState>();
  TextEditingController _spotifyLinkController = TextEditingController();
  TextEditingController _youtubeLinkController = TextEditingController();
  TextEditingController _appleLinkController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isArtist = CURRENT_USER is Users.Artist;
    profilePic = isArtist ? CURRENT_USER.profilePicture : 'lib/images/songbird_black_logo.png';
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildCoverAndProfile(),
          isArtist ? buildArtistStats() : buildListenerStats(),
          SizedBox(height: 20),
          isArtist ? buildSocialMediaSection() : SizedBox(),
          //ElevatedButton(onPressed: onPressed, child: child)
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
      'lib/images/sunset.png',
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
      Text(
        CURRENT_USER.username,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      
      //Artist Text
      
      const SizedBox(height: 2),

      //Description
      Text(
        CURRENT_USER.description,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 15)
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
      SizedBox(height: 10),
      ElevatedButton.icon(
        onPressed: () {
          launchUrl(Uri.parse(CURRENT_USER.spotifyLink));
        },
        icon: Icon(FontAwesomeIcons.spotify, color: Colors.black),
        label: Text(
          'View Spotify',
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
        ),
      ),      
      
      const SizedBox(height: 20),
    ],
  );

  Widget buildSocialMediaSection() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Update Your Info Below!',
        style: TextStyle(
          color: Colors.black,

        ),
      ),
      const SizedBox(height: 12),

      //Update Username
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.yellow,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                child: Center(child: Icon(Icons.person, size: 35)),//does nothing at the moment
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormContainerWidget(
            controller: _usernameController,
              hintText: "Update Your Username!",
              isPasswordField: false,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      // Update Description
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.yellow,
            child: Material(
              shape: CircleBorder(),
              clipBehavior: Clip.hardEdge,
              color: Colors.transparent,
              child: InkWell(
                child: Center(child: Icon(Icons.edit_note_sharp, size: 35)),//does nothing at the moment
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FormContainerWidget(
            controller: _descriptionController,
              hintText: "Update Your Description!",
              isPasswordField: false,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // Update Apple Music Link
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSocialIcon(FontAwesomeIcons.apple, CURRENT_USER.appleMusicLink),
          Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormContainerWidget(
                      controller: _appleLinkController,
                      hintText: (CURRENT_USER.appleMusicLink.length > 0) ? CURRENT_USER.appleMusicLink : "Add an Apple Music Link!",
                      isPasswordField: false,
                    ),
                  ),
        ],
      ),
      const SizedBox(height: 12),

      // Update Youtube Link
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSocialIcon(FontAwesomeIcons.youtube, CURRENT_USER.youtubeLink),
          Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormContainerWidget(
                      controller: _youtubeLinkController,
                      hintText: (CURRENT_USER.youtubeLink.length > 0) ? CURRENT_USER.youtubeLink : "Add a Youtube Link!",
                      isPasswordField: false,
                    ),
                  ),
        ],
      ),
      SizedBox(height: 10),

      // Update Button
      FilledButton.tonal(
        onPressed: () {
          if(_spotifyLinkController.text == ""){
            _spotifyLinkController.text = CURRENT_USER.spotifyLink;
          }
          if(_youtubeLinkController.text == ""){
            _youtubeLinkController.text = CURRENT_USER.youtubeLink;
          }
          if(_appleLinkController.text == ""){
            _appleLinkController.text = CURRENT_USER.appleMusicLink;
          }
          if(_descriptionController.text == ""){
            _descriptionController.text = CURRENT_USER.description;
          }
          if(_usernameController.text == ""){
            _usernameController.text = CURRENT_USER.username;
          }
          CURRENT_USER.spotifyLink = _spotifyLinkController.text;
          CURRENT_USER.youtubeLink = _youtubeLinkController.text;
          CURRENT_USER.appleMusicLink = _appleLinkController.text;
          CURRENT_USER.description = _descriptionController.text;
          CURRENT_USER.username = _usernameController.text;
          profilePageUpdateLinks(_spotifyLinkController.text, _appleLinkController.text, _youtubeLinkController.text, _descriptionController.text, _usernameController.text);
          setState(() {});
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          shadowColor: MaterialStateProperty.all<Color>(Colors.black),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0)),
          textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
        ),
        child: const Text('Update!', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      SizedBox(height: 30),
    ],
  );

  Widget buildSocialIcon(IconData icon, String link) => Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
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
      ]
    ),
  );
 }


