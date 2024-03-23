//import 'dart:html';
import 'package:songbird/pages/explore_page.dart';
import 'package:songbird/pages/likes_page.dart';
import 'package:songbird/pages/profile_page.dart';
import 'package:songbird/pages/login.dart';
import 'package:songbird/pages/signup.dart';
import 'package:songbird/pages/splash_screen.dart';
import 'pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

dynamic CURRENT_USER; //global variable to be assigned a user class later on in program flow

void main() async{
  await dotenv.load(fileName: "assets/.env");

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY']!, //the ! tells the dart compiler that this will never be a null value, can't assign it otherwise
            appId: dotenv.env['FIREBASE_APP_ID']!,
            messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID']!,
            projectId: dotenv.env['FIREBASE_PROJECT_ID']!));
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
        '/':(context) => SplashScreen(),
        '/settings':(context) => SettingsPage(),
        '/home' : (context) => MyHomePage(title: 'Songbird'),
        '/signup' :(context) => SignUpPage(),
        '/login': (context) => LoginPage(),
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
        automaticallyImplyLeading: false,
        backgroundColor:   Colors.yellow,
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
        selectedItemColor:   Colors.yellow,
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