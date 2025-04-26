import 'dart:ui';

import 'package:flame/game.dart';

class GameConstants {
  static late double screenWidth;
  static late double screenHeight;

  // Joystick Constants
  static const double joystickKnobRadius = 30.0;
  static const Color joystickKnobColor = Color(0xff3f51b5);
  static const double joystickBackgroundRadius = 40.0;
  static const Color joystickBackgroundColor = Color(0x803f51b5);
  static const double joystickMarginLeft = 40.0;
  static const double joystickMarginBottom = 40.0;

  // Character Constants
  static const double characterInitialX = 50.0;
  static const double characterInitialY = 50.0;
  static const double characterSize = 50.0;
  static const double characterSpeed = 200.0; // Character Speed

  // Obstacle Constants
  static const double obstacleSize = 50.0;
  static const double obstacleGenerationIntervalMin = 500;
  static const double obstacleGenerationIntervalMax = 2500;
  static const double obstacleInitialSpeedMin = 50.0;
  static const double obstacleInitialSpeedMax = 200.0;
  static const double obstacleGenerationOffsetX = 100.0;
  static const int obstaclePoolSize = 10;
  static const double scoreIncrementInterval =
      1.0; // Increase score every 1 second

  // Game Constants
  static const Duration initialObstacleGenerationDuration = Duration(
    seconds: 1,
  );

  static void initialize(FlameGame game) {
    screenWidth = game.size.x;
    screenHeight = game.size.y;
  }
}


