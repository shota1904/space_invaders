import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:space_invaders/game/game_lib.dart';
import 'package:space_invaders/minigame.dart';

void main() {

  var gameEngine = MoveGameEngine();
  var gameView = MoveGameView('Simple Game Demo', gameEngine);
  var game = Game(gameEngine, gameView);

  runApp(MyApp(game));
}

class MyApp extends StatelessWidget {
  final Game game;

  MyApp(this.game);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameEngine>.value(
        value: game.gameEngine,
        child: MaterialApp(
          title: game.gameView.title,
          theme: ThemeData(
            primaryColor: Colors.blue[900],
            primarySwatch: Colors.yellow,
            scaffoldBackgroundColor: Colors.blue[900],
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: game.gameView,
        ));
  }
}