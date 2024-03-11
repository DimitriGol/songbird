import 'dart:html';
import 'package:songbird/pages/explore_page.dart';
import 'package:songbird/pages/likes_page.dart';
import 'package:songbird/pages/profile_page.dart';

import 'pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() async{


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCnpukA1QmiQUOrblOzQmGJKUnWfhUF4n8",
            appId: "1:942832082224:web:d595c4ea5dbac506cdfcf5",
            messagingSenderId: "942832082224",
            projectId: "songbird-84376"));
  //await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes:{
        '/':(context) => const MyHomePage(title: 'Songbird'),
        '/settings':(context) => SettingsPage(),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor:  Color.fromARGB(255, 230, 230, 72)),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentIndex = 0;

  final pages = [
    LikesPage(),
    ExplorePage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:   Color.fromARGB(255, 230, 230, 72),
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        //backgroundColor: const Color.fromARGB(255, 134, 130, 130),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 40,
        unselectedItemColor: Colors.black,
        selectedItemColor:  Color.fromARGB(255, 230, 230, 72),
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Likes',
          ),
         
          BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
          label: 'Discover',
          ),

           BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
          ),


      ],),

    );
  }
}