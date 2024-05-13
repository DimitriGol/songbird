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
import 'package:songbird/database_management/database_funcs.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart' as spotify_api;
import 'package:songbird/classes/spotifyHelper.dart';

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


  final _appLinks = AppLinks(); // Instantiate AppLink early on. (Documentation for app_links package asked for this)

  _appLinks.uriLinkStream.listen((uri){ // it's listening to uri. Don't know if it's the right URI. I might need to feed it the Chrome URI.
  print('URI received(A): $uri'); // spits out the local URI. Change to chrome URI.
  });
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
        '/':(context) => SplashScreen(toExplorePage: false),
        '/settings':(context) => SettingsPage(),
        '/home' : (context) => MyHomePage(title: 'Songbird'),
        '/signup' :(context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        //'/explore' :(context) => ExplorePage(artistUUID: 'ODA5FAaCjCNJ2Nmbtk5NqLpoRsn1')
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

  final CupertinoTabController _tabController = CupertinoTabController(initialIndex: 1);
  @override
Widget build(BuildContext context){
   return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.yellow,
        leading: SizedBox(
          height: 200,
          child:  Center(child: Image.asset('lib/images/songbird_black_logo_and_text.png'))),

        trailing: CupertinoButton(
          minSize: 20,
          padding: EdgeInsets.all(0),
          child: Icon(Icons.settings, size: 30,),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
      ),
   
  child: CupertinoTabScaffold(
    controller: _tabController,
    tabBar: CupertinoTabBar(
      iconSize: 40,
      backgroundColor: Colors.blueGrey,
      activeColor: Colors.yellow, // Change the color for active icons
      inactiveColor: Colors.black, // Change the color for inactive icons
      currentIndex: 1,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          //label: 'Liked',
          ),
         
          BottomNavigationBarItem(
          icon: Icon(Icons.music_note),
          //label: 'Explore',
          ),

           BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          //label: 'Profile',
          ),

  ]), tabBuilder: (context, index)
  {
    switch(index){
      case 0:
        return CupertinoTabView(builder: (context){
          return CupertinoPageScaffold(child: LikesPage());
        });
      case 1:
          return CupertinoTabView(builder: (context){
            return CupertinoPageScaffold(child: ExplorePage(artistUUID: 'ZtnDhgH0nIUEWcD5E5CGXrHBrsE3', onStartUp: false));
          });
      case 2:
          return CupertinoTabView(builder: (context){
            return CupertinoPageScaffold(child: ProfilePage());
          });

      default: return CupertinoTabView(builder: (context){
        return CupertinoPageScaffold(child: LikesPage());
      });
    }
  }
 
  )
   );
}

}


