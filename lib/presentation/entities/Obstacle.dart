import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Obstacle extends PositionComponent with CollisionCallbacks {
  double speed; // Add speed variable

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(position: position, size: size) {
    add(RectangleComponent(size: size, paint: Paint()..color = (Colors.blue)));
    add(RectangleHitbox());
  }
}

Obstacle generateObstacle(double characterPositionX) {
  Random random = Random();
  double speed =
      GameConstants.obstacleInitialSpeedMin +
      random.nextDouble() *
          (GameConstants.obstacleInitialSpeedMax -
              GameConstants.obstacleInitialSpeedMin);

  return Obstacle(
    position: Vector2(
      characterPositionX +
          GameConstants.screenWidth +
          GameConstants.obstacleGenerationOffsetX,
      random.nextDouble() *
          (GameConstants.screenHeight - GameConstants.obstacleSize),
    ),
    size: Vector2.all(GameConstants.obstacleSize),
    speed: speed,
  );
}

