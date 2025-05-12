// game_over_screen.dart
import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final score = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      body: FutureBuilder<int>(
        future: _getHighScore(score),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final highScore = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Game Over', style: TextStyle(fontSize: 40)),
                Text('Score: $score', style: TextStyle(fontSize: 30)),
                Text('High Score: $highScore', style: TextStyle(fontSize: 30)),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Restart'),
                  onPressed: () => Navigator.pushReplacementNamed(context, '/game'),
                ),
                ElevatedButton(
                  child: Text('Exit'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<int> _getHighScore(int newScore) async {
    //final prefs = await SharedPreferences.getInstance();
    //final currentHigh = prefs.getInt('highScore') ?? 0;
    //if (newScore > currentHigh) {
    //  await prefs.setInt('highScore', newScore);
    //  return newScore;
    //}
    int currentHigh = 0;
    return currentHigh;
  }
}