import 'package:flutter/material.dart';
import 'package:vintage_games/view-games.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color.fromARGB(255, 36, 100, 83),
          scaffoldBackgroundColor: const Color(0xffefefef)),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Skill Builder',
      home: const MyStatefulWidget(),
    );
  }
}
