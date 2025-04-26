import 'dart:async';
import 'package:endless_surge/presentation/entities/character/projectTiles/Projectile.dart'
    show Projectile;
import 'package:endless_surge/utils/AssetsPaths.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import '../../ui/game.dart' show SurgeGame;
import '../obstacles/Obstacle.dart';
import '../particles/collision_particles.dart';

class Character extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<SurgeGame> {
  Vector2 velocity = Vector2.zero();
  double speed = GameConstants.characterSpeed; // Use GameConstants
  CollisionParticles? _collisionParticles; // To hold a reference
  AudioPlayer? _runningSoundPlayer; // To hold the AudioPlayer instance
  SpriteAnimation? _runAnimation;
  SpriteAnimation? _fireAnimation;
  bool _isFiring = false;
  double _fireAnimationTime = 0;

  Character({required Vector2 position, required Vector2 size})
    : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    _runAnimation = await _loadRunAnimation();
    _fireAnimation = await _loadFireAnimation();

    animation = _runAnimation;
    _startRunningSound();
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

    return SpriteAnimation.spriteList([
      Sprite(image1),
      Sprite(image2),
    ], stepTime: AssetPaths.characterRunStepTime);
  }

  Future<SpriteAnimation> _loadFireAnimation() async {
    final image1 = await Flame.images.load(AssetPaths.characterFire_1);
    final image2 = await Flame.images.load(AssetPaths.characterFire_2);
    final image3 = await Flame.images.load(AssetPaths.characterFire_3);
    final image4 = await Flame.images.load(AssetPaths.characterFire_4);

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
      game.gameManager.gameOver(); // Notify GameManager
      pauseAnimationPlayer();
      _stopRunningSound();
      if (intersectionPoints.isNotEmpty) {
        final collisionPosition = intersectionPoints.first;
        _collisionParticles = CollisionParticles(position: collisionPosition);
        gameRef.add(_collisionParticles as Component);
      }
      _playExplosionSound();
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

  void fire() {
    if (!_isFiring) {
      _isFiring = true;
      animation = _fireAnimation;
      final projectile = Projectile(
        position: position + Vector2(width, height / 3),
        direction: Vector2(1, 0), // Fire to the right initially
      );

      _fireAnimationTime = 0; // Reset the timer
      gameRef.add(projectile);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _handleFireAnimationCompletion(dt);
  }

  void _handleFireAnimationCompletion(double dt) {
    if (_isFiring && animation == _fireAnimation) {
      _fireAnimationTime += dt;
      if (_fireAnimationTime >=
          _fireAnimation!.frames.length * AssetPaths.projectTileRunStepTime) {
        _isFiring = false;
        animation = _runAnimation;
        _fireAnimationTime = 0; // Reset for potential future use
      }
    }
  }

  void continueAnimationPlayer() {
    animationTicker?.paused = false;
  }

  void _startRunningSound() async {
    _runningSoundPlayer = await FlameAudio.loop(
      AssetPaths.planeSound,
      volume: 0.2,
    );
  }

  void _playExplosionSound() async {
    await FlameAudio.play(AssetPaths.explosionSound, volume: 0.4);
  }

  void _stopRunningSound() {
    _runningSoundPlayer?.stop();
    _runningSoundPlayer?.dispose(); // Dispose of the player when stopped
    _runningSoundPlayer = null;
  }
}
