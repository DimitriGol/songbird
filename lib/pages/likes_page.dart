import 'package:flutter/material.dart';
import '../classes/users.dart';

class LikesPage extends StatefulWidget
{
   const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}


class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Set the padding for the entire ListView
        child: Center(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.account_circle_sharp, size: 40,),
                title: Text('Artist name here'),
                trailing: Icon(Icons.favorite_sharp, color: Colors.red.shade700,),
              ),
              ListTile(
                leading: Icon(Icons.account_circle_sharp, size: 40,),
                title: Text('Artist name here'),
                trailing: Icon(Icons.favorite_sharp, color: Colors.red.shade700,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}