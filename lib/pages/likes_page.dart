import 'package:flutter/material.dart';

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



      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You are on the likes page!',
            ),
          ],
        ),
      ),
    );
  }
}