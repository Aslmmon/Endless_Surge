import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../ui/game.dart' show SurgeGame;
import 'Obstacle.dart';

class Character extends PositionComponent
    with CollisionCallbacks, HasGameRef<SurgeGame> {
  Vector2 velocity = Vector2.zero();
  double speed = 200; // Character Speed

  Character({required Vector2 position, required Vector2 size})
    : super(position: position, size: size) {
    // Adds a red rectangle component to visually represent the character.
    add(RectangleComponent(size: size, paint: Paint()..color = (Colors.red)));
    add(RectangleHitbox());
  }

  void move(JoystickDirection direction, double dt) {
    Vector2 newPosition = position.clone();

    // Add dt parameter
    switch (direction) {
      case JoystickDirection.up:
        newPosition.y -= speed * dt;
        break;
      case JoystickDirection.down:
        newPosition.y += speed * dt;
        break;
      case JoystickDirection.left:
        newPosition.x -= speed * dt;
        break;
      case JoystickDirection.right:
        newPosition.x += speed * dt;
        break;
      case JoystickDirection.upLeft:
        newPosition += Vector2(-1, -1).normalized() * speed * dt;
        break;
      case JoystickDirection.upRight:
        newPosition += Vector2(1, -1).normalized() * speed * dt;
        break;
      case JoystickDirection.downLeft:
        newPosition += Vector2(-1, 1).normalized() * speed * dt;
        break;
      case JoystickDirection.downRight:
        newPosition += Vector2(1, 1).normalized() * speed * dt;
        break;
      case JoystickDirection.idle:
        break;
    }

    // Boundary checks using clamp
    newPosition.x = newPosition.x.clamp(0, GameConstants.screenWidth - size.x);
    newPosition.y = newPosition.y.clamp(0, GameConstants.screenHeight - size.y);

    position.setFrom(newPosition);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      game.gameOver(); // Use gameOver method
    }

  }
}
