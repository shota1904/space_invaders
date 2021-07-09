import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:space_invaders/game/game_lib.dart';
import 'package:space_invaders/game/size_provider.dart';
import 'package:provider/provider.dart';

class MoveGameEngine extends GameEngine {
  Size? _gameViewSize;
  double _targetPositionX = 10.0;
  double _targetPositionY = 0.0;
  double _targetPositionX1 = 150.0;

  double get targetPosX => _targetPositionX;
  double get targetPosY => _targetPositionY;
  double get targetPosX1 => _targetPositionX1;

  @override
  void updatePhysicsEngine(int tickCounter) {
    _targetPositionY += 2;
    if (_targetPositionY > _gameViewSize!.height) {
      _targetPositionY = -20.0;
    }
    var ghost0 = Rect.fromLTRB(_targetPositionX, _targetPositionY, _targetPositionX+100, _targetPositionY+50);
    var ghost1 = Rect.fromLTRB(_targetPositionX1, _targetPositionY, _targetPositionX1+100, _targetPositionY+50);
    var ship = Rect.fromLTRB(100, 400, 130, 450);
    if (collision(ship, ghost0) || collision(ship, ghost1)) {
      // TODO end of game
      print('hit');
      // ship.shift(Offset(dx, 0));
    }
    forceRedraw();
  }

  @override
  void stateChanged(GameState oldState, GameState newState) {
    if (newState == GameState.running) {
      _targetPositionX = 10.0;
      _targetPositionY = 0.0;
    }


  }
  void setGameViewSize(Size? size) {
    if (size != null) _gameViewSize = size;
  }

  bool collision(Rect r0, Rect r1){
      return pointInRect(r1, Point(r0.left, r0.top)) ||
          pointInRect(r1, Point(r0.right, r0.top)) ||
          pointInRect(r1, Point(r0.left, r0.bottom)) ||
          pointInRect(r1, Point(r0.right, r0.bottom));
  }

  bool pointInRect(Rect r, Point p){
    return
      r.left <= p.x && p.x < r.right &&
      r.top <= p.y && p.y < r.bottom;
  }
}

class MoveGameView extends GameView {
  final MoveGameEngine gameEngine;
  final myController = TextEditingController();

  MoveGameView(String title, this.gameEngine) : super(title);

  @override
  Widget getStartPageContent(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 30),
                Text('SPACE', textScaleFactor: 3),
                Text('INVADERS', textScaleFactor: 3),
                Container(
                  padding: EdgeInsets.only(top: 40),
                  width: 300.0,
                  child: Image.asset('assets/images/ufo.png'),
                ),
                Container(
                  width: 300.0,
                  height: 100.0,
                  child: TextField(
                    controller: myController,
                    onSubmitted: (String value) async {
                      gameEngine.setUsername(value);
                    },
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your username',
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () => { engine.state = GameState.running,
                    // TODO Name registieren
                    },
                    child: Text('Start game')
                )
              ],
            )),

      ],
    );
  }

  @override
  Widget getRunningPageContent(BuildContext context) {
    return SizeProviderWidget(
        onChildSize: (size) {
          gameEngine.setGameViewSize(size);
        },
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Text('Username: ${gameEngine.getUsername()}'),
                  Text('Score: ${gameEngine.tickCounter}'),
                ],
              )
            ),
            Positioned(
              top: 500,
              left: 140,
              child: Draggable(
                axis: Axis.horizontal, // just horizontal movements
                child: Container(
                  height: 50,
                  child: Image.asset('assets/images/ufo.png')
                ),
                childWhenDragging: Container(),
                feedback: Container(
                  height: 50,
                  child: Image.asset('assets/images/ufo.png')
                ),

              ),
            ),
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: Text('End Game'),
                        onPressed: () {
                          gameEngine.state = GameState.endOfGame;
                        })
                  ],
                )),
            Positioned(
                top: gameEngine.targetPosY,
                left: gameEngine.targetPosX,
                child: Container(
                  height: 50,
                  child: Image.asset('assets/images/alien.png')
                ),
            ),
            Positioned(
              top: gameEngine.targetPosY,
              left: gameEngine.targetPosX1,
              child: Container(
                  height: 50,
                  child: Image.asset('assets/images/alien.png')
              ),
            ),
          ],
        ));
  }

  @override
  Widget getEndOfGamePageContent(BuildContext context) {
    GameEngine engine = Provider.of<GameEngine>(context);
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('GAME', textScaleFactor: 4),
              Text('OVER', textScaleFactor: 4),
              Text('Score: ${gameEngine.tickCounter} ', textScaleFactor: 1.5,),
              Container(
                width: 260.0,
                child:
                Image.asset('assets/images/alien.png'),
              ),
              ElevatedButton(
                  onPressed: () => { engine.state = GameState.running},
                  child: Text('Play again')),
              ElevatedButton(
                  onPressed: () => { engine.state = GameState.waitForStart},
                  child: Text('Back to Startpage')
              )
            ]
        )
    );
  }
}