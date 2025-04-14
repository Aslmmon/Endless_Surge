import 'package:flame/game.dart';

class GameConstants {
  static late double screenWidth;
  static late double screenHeight;

  static void initialize(FlameGame game) {
    screenWidth = game.size.x;
    screenHeight = game.size.y;
  }
}

enum GameState {
  playing,
  gameOver,
}