import 'dart:async';
import 'package:endless_surge/utils/AssetsPaths.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import '../../ui/game.dart' show SurgeGame;
import '../obstacles/Obstacle.dart';
import '../particles/collision_particles.dart';

class Character extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SurgeGame> {
  Vector2 velocity = Vector2.zero();
  double speed = GameConstants.characterSpeed; // Use GameConstants
  CollisionParticles? _collisionParticles; // To hold a reference

  Character({required Vector2 position, required Vector2 size})
    : super(position: position, size: size) {}

  @override
  Future<void> onLoad() async {
    animation = await _loadRunAnimation();
    add(
      RectangleHitbox(
        anchor: Anchor.topLeft,
        size: Vector2(40, 40), // Adjust to your sprite's size
      ),
    );
    return super.onLoad();
  }

  Future<SpriteAnimation> _loadRunAnimation() async {
    final image1 = await Flame.images.load(AssetPaths.characterFrame1);
    final image2 = await Flame.images.load(AssetPaths.characterFrame2);
    final image3 = await Flame.images.load(AssetPaths.characterFrame3);
    final image4 = await Flame.images.load(AssetPaths.characterFrame4);

    return SpriteAnimation.spriteList([
      Sprite(image1),
      Sprite(image2),
      Sprite(image3),
      Sprite(image4),
    ], stepTime: AssetPaths.characterRunStepTime);
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
      pauseAnimationPlayer();

      if (intersectionPoints.isNotEmpty) {
        final collisionPosition = intersectionPoints.first;
        _collisionParticles = CollisionParticles(position: collisionPosition);
        gameRef.add(_collisionParticles as Component);
      }
      Future.delayed(const Duration(seconds: 3), () {
        _collisionParticles?.removeFromParent();
        _collisionParticles = null;
      });
      removeFromParent();
    }
  }

  void pauseAnimationPlayer() {
    animationTicker?.paused = true;
  }

  void continueAnimationPlayer() {
    animationTicker?.paused = false;
  }
}
