import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget
{
   const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}


class _ProfilePageState extends State<ProfilePage> {
  final double coverHeight = 200;
  final double profileHeight = 145;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          buildCoverAndProfile(),
          buildContent(),
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
      backgroundColor: Colors.grey,
      backgroundImage: NetworkImage(
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
      )
    );

    Widget buildContent() => Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Johnny Apppleseed',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Description goes here',
          style: TextStyle(color: Colors.grey.shade700)
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons.spotify),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.apple),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.instagram),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.youtube),

          ],
        ),
      ],
    );

    Widget buildSocialIcon(IconData icon) => CircleAvatar(
      radius: 20,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: InkWell(
          onTap: () {}, //does nothing at the moment
          child: Center(child: Icon(icon, size: 30)),
        ),
      ),
    );
}

