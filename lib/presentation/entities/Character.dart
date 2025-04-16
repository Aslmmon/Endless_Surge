import 'dart:async';

import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import '../ui/game.dart' show SurgeGame;
import 'Obstacle.dart';

class Character extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SurgeGame> {
  Vector2 velocity = Vector2.zero();
  double speed = GameConstants.characterSpeed; // Use GameConstants

  Character({required Vector2 position, required Vector2 size})
    : super(position: position, size: size) {
    // Adds a red rectangle component to visually represent the character.
    add(RectangleComponent(size: size, paint: Paint()..color = (Colors.red)));
    add(RectangleHitbox());
  }

  @override
  Future<void> onLoad() async {
    final image1 = await Flame.images.load('frame-1.png');
    final image2 = await Flame.images.load('frame-2.png');

    // final image3 = await images.load('character_run_3.png');
    // final image4 = await images.load('character_run_4.png');



    animation = SpriteAnimation.spriteList([
      Sprite(image1), Sprite(image2),
      // Sprite(image3), Sprite(image4)
    ], stepTime: 0.1);

    return super.onLoad();
  }

  void move(JoystickDirection direction, double dt) {
    Vector2 newPosition = position.clone();

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

    _applyBoundaryChecks(newPosition);
    position.setFrom(newPosition);
  }

  void _applyBoundaryChecks(Vector2 newPosition) {
    newPosition.x = newPosition.x.clamp(0, GameConstants.screenWidth - size.x);
    newPosition.y = newPosition.y.clamp(0, GameConstants.screenHeight - size.y);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Obstacle) {
      game.gameOver();
    }
  }
}
