import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../../utils/AssetsPaths.dart';

class Obstacle extends SpriteAnimationComponent with CollisionCallbacks {
  double speed; // Add speed variable

  Obstacle({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(position: position, size: size) {
    flipHorizontally();
  }

  @override
  Future<void> onLoad() async {
    animation = await _loadObstacleAnimation();
    add(
      RectangleHitbox(
        anchor: Anchor.topLeft,
        size: Vector2(40, 40), // Adjust to your sprite's size
      ),
    );
    return super.onLoad();
  }
}

Future<SpriteAnimation> _loadObstacleAnimation() async {
  final image1 = await Flame.images.load(AssetPaths.enemyFrame1);
  final image2 = await Flame.images.load(AssetPaths.enemyFrame2);
  final image3 = await Flame.images.load(AssetPaths.enemyFrame3);
  final image4 = await Flame.images.load(AssetPaths.enemyFrame4);
  final image5 = await Flame.images.load(AssetPaths.enemyFrame5);
  final image6 = await Flame.images.load(AssetPaths.enemyFrame6);
  final image7 = await Flame.images.load(AssetPaths.enemyFrame7);
  final image8 = await Flame.images.load(AssetPaths.enemyFrame8);

  return SpriteAnimation.spriteList([
    Sprite(image1),
    Sprite(image2),
    Sprite(image3),
    Sprite(image4),
    Sprite(image5),
    Sprite(image6),
    Sprite(image7),
    Sprite(image8),
  ], stepTime: AssetPaths.characterRunStepTime);
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
