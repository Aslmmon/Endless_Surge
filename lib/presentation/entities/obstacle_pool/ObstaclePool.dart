import 'dart:collection';
import 'package:endless_surge/presentation/entities/Obstacle.dart'
    show Obstacle, generateObstacle;
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'dart:math';

class ObstaclePool {
  final Queue<Obstacle> _pool = Queue();
  final int poolSize = GameConstants.obstaclePoolSize;
  final Random random = Random();

  ObstaclePool() {
    for (int i = 0; i < poolSize; i++) {
      _pool.add(generateInitialObstacle());
    }
  }

  Obstacle generateInitialObstacle() {
    return Obstacle(
      position: Vector2(
        GameConstants.screenWidth + GameConstants.obstacleGenerationOffsetX,
        random.nextDouble() * GameConstants.screenHeight,
      ),
      size: Vector2.all(GameConstants.obstacleSize),
      speed: GameConstants.obstacleInitialSpeedMin,
    );
  }

  Obstacle getObstacle(double characterPositionX) {
    if (_pool.isNotEmpty) {
      Obstacle obstacle = _pool.removeFirst();
      obstacle.position = generateObstacle(characterPositionX).position;
      obstacle.size = Vector2.all(GameConstants.obstacleSize);
      obstacle.speed = generateObstacle(characterPositionX).speed;
      return obstacle;
    } else {
      return generateObstacle(characterPositionX);
    }
  }

  void returnObstacle(Obstacle obstacle) {
    _pool.add(obstacle);
    obstacle.removeFromParent();
  }
}
