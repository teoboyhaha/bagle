import 'package:flutter/material.dart';
import 'package:bagle/bagle/views/bagle_screen.dart';

/*
Class "App" builds a widget that returns "MaterialApp". 
"MaterialApp" is a class from Flutter's Material package.
*/

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bagle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      // Display's the game screen.
      home: const BagleScreen(),
    );
  }
}
