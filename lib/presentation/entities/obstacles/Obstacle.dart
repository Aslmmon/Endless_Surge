import 'package:endless_surge/presentation/entities/character/projectTiles/Projectile.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart' show SpriteSheet;
import 'dart:math';

class Obstacle extends SpriteAnimationComponent with CollisionCallbacks {
  double speed; // Add speed variable
  bool _isHitAnimationPlaying = false;
  double _hitAnimationTime = 0;

  double _hitAnimationDuration = 0;
  bool isMoving = true; // Add this flag
  SpriteAnimation? _hitAnimation;

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
    _hitAnimation = await _loadHitObstacleAnimation();
    if (_hitAnimation != null && _hitAnimation!.frames.isNotEmpty) {
      _hitAnimationDuration =
          _hitAnimation!.frames.length *
          GameConstants.obstacleFrameStepTime; // Example stepTime
    }
    add(
      RectangleHitbox(
        anchor: Anchor.topLeft,
        size: Vector2.all(60), // Adjust to your sprite's size
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isMoving) {
      position.x -= speed * dt; // Assuming horizontal movement
    }

    if (_isHitAnimationPlaying) {
      _hitAnimationTime += dt;
      if (_hitAnimationTime >= _hitAnimationDuration &&
          _hitAnimationDuration > 0) {
        removeFromParent();
      }
    }
  }

  @override
  Future<void> onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    if (other is Projectile && !_isHitAnimationPlaying) {
      isMoving = false; // Stop the obstacle's movement
      animation = _hitAnimation;
      _isHitAnimationPlaying = true;
      _hitAnimationTime = 0;
    }
    super.onCollision(intersectionPoints, other);
  }
}

Future<SpriteAnimation> _loadObstacleAnimation() async {
  final spriteSheetImage = await Flame.images.load(
    'enemy/mon3_sprite_base.png',
  );
  final spriteSheet = SpriteSheet(
    image: spriteSheetImage,
    srcSize: Vector2(
      GameConstants.obstacleFrameWidth,
      GameConstants.obstacleFrameHeight,
    ),
  );

  return spriteSheet.createAnimation(
    row: 0,
    // Assuming your animation frames are in the first (and only) row
    to: GameConstants.obstacleFrameAmount.toInt() - 1,
    // The index of the last frame (inclusive)
    stepTime: GameConstants.obstacleFrameStepTime,
    loop: true, // Set to false if you only want it to play once
  );
}

Future<SpriteAnimation> _loadHitObstacleAnimation() async {
  final spriteSheetImage = await Flame.images.load(
    'enemy/mon3_sprite_base.png',
  );
  final spriteSheet = SpriteSheet(
    image: spriteSheetImage,
    srcSize: Vector2(
      GameConstants.obstacleFrameWidth,
      GameConstants.obstacleFrameHeight,
    ),
  );

  return spriteSheet.createAnimation(
    row: 2,
    to: GameConstants.obstacleFrameAmountDying.toInt() - 1,
    stepTime: GameConstants.obstacleFrameStepTime,
    loop: true, // Set to false if you only want it to play once
  );
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
