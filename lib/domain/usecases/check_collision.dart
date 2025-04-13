import '../entities/character.dart';
import '../entities/obstacle.dart';

import 'package:flame/collisions.dart';
import '../entities/obstacle_component.dart';
import '../entities/character_component.dart';

bool checkCollision(CharacterComponent character, ObstacleComponent obstacle) {
  final characterHitbox = RectangleHitbox();
  final obstacleHitbox = RectangleHitbox();
  character.add(characterHitbox);
  obstacle.add(obstacleHitbox);
  return characterHitbox.intersects(obstacleHitbox);
}