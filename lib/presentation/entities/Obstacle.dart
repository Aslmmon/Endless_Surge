import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Obstacle extends PositionComponent with CollisionCallbacks {
  Obstacle({required Vector2 position, required Vector2 size})
      : super(position: position, size: size) {
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = (Colors.blue),
    ));
    add(RectangleHitbox());
  }
}

Obstacle generateObstacle(double screenWidth, double screenHeight, double characterPositionX) {
  Random random = Random();
  double sizeX = 50.0;
  double sizeY = 50.0;
  double positionX = characterPositionX + screenWidth + 100; // Generate to the right of the character
  double positionY = random.nextDouble() * (screenHeight - sizeY);

  return Obstacle(
    position: Vector2(positionX, positionY),
    size: Vector2(sizeX, sizeY),
  );
}