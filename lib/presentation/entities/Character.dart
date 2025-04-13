import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

/// Represents the player character in the endless runner game.
class Character extends PositionComponent with CollisionCallbacks {
  /// The velocity of the character, used for movement and jump calculations.
  Vector2 velocity = Vector2.zero();
  double speed = 200; // Character Speed

  /// Creates a new character instance.
  ///
  /// [position]: The initial position of the character.
  /// [size]: The size of the character.
  Character({required Vector2 position, required Vector2 size})
    : super(position: position, size: size) {
    // Adds a red rectangle component to visually represent the character.
    add(RectangleComponent(size: size, paint: Paint()..color = (Colors.red)));
  }

  void move(JoystickDirection direction, double dt) {
    // Add dt parameter
    switch (direction) {
      case JoystickDirection.up:
        position.y -= speed * dt;
        break;
      case JoystickDirection.down:
        position.y += speed * dt;
        break;
      case JoystickDirection.left:
        position.x -= speed * dt;
        break;
      case JoystickDirection.right:
        position.x += speed * dt;
        break;
      case JoystickDirection.upLeft:
        position += Vector2(-1, -1).normalized() * speed * dt;
        break;
      case JoystickDirection.upRight:
        position += Vector2(1, -1).normalized() * speed * dt;
        break;
      case JoystickDirection.downLeft:
        position += Vector2(-1, 1).normalized() * speed * dt;
        break;
      case JoystickDirection.downRight:
        position += Vector2(1, 1).normalized() * speed * dt;
        break;
      case JoystickDirection.idle:
        break;
      }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
  }
}
