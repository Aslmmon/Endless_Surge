import 'dart:collection';

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

Obstacle generateObstacle(
  double screenWidth,
  double screenHeight,
  double characterPositionX,
) {
  Random random = Random();
  double sizeX = 50.0;
  double sizeY = 50.0;
  double positionX =
      characterPositionX +
      screenWidth +
      100; // Generate to the right of the character
  double positionY = random.nextDouble() * (screenHeight - sizeY);
  double speed = 50 + random.nextDouble() * 200; // Random speed between 50 and 250


  return Obstacle(
    position: Vector2(positionX, positionY),
    size: Vector2(sizeX, sizeY),
    speed: speed,
  );
}

class ObstaclePool {
  final Queue<Obstacle> _pool = Queue();
  final int poolSize = 10; // Adjust pool size as needed
  Random random = Random();

  ObstaclePool() {
    for (int i = 0; i < poolSize; i++) {
      _pool.add(
        Obstacle(
          position: Vector2(
            GameConstants.screenWidth + 100,
            random.nextDouble() * (GameConstants.screenHeight),
          ),
          size: Vector2.all(50),
          speed: 100,
        ),
      );
    }
  }

  Obstacle getObstacle(
    double screenWidth,
    double screenHeight,
    double characterPositionX,
  ) {
     if (_pool.isNotEmpty) {
    Obstacle obstacle = _pool.removeFirst();
    obstacle.position =
        generateObstacle(
          screenWidth,
          screenHeight,
          characterPositionX,
        ).position;
    obstacle.size =
        generateObstacle(screenWidth, screenHeight, characterPositionX).size;
    print("generated from pool");

    return obstacle;
    }
    else {
      print("first time generated");
      return generateObstacle(screenWidth, screenHeight, characterPositionX);
    }
  }


  void returnObstacle(Obstacle obstacle) {
    _pool.add(obstacle);
    obstacle.removeFromParent();
  }



}
