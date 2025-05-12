// main.dart
import 'package:flutter/material.dart';
import 'package:planeshooters/screens/game_over_screen.dart';
import 'package:planeshooters/screens/game_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plane Shooter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMenu(),
      routes: {
        '/game': (context) => GameScreen(),
        '/gameOver': (context) => GameOverScreen(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Start Game'),
          onPressed: () => Navigator.pushNamed(context, '/game'),
        ),
      ),
    );
  }
}