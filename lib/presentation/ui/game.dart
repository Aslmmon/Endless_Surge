import 'dart:async';
import 'dart:math';

import 'package:endless_surge/presentation/entities/Character.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart' show Anchor;
import 'package:flame/game.dart';

import '../entities/Obstacle.dart';
import '../entities/joystick.dart';

class SurgeGame extends FlameGame with HasCollisionDetection {
  late Character characterComponent;
  late GameJoystick joystick;
  List<Obstacle> obstacleComponents = [];
  Timer? obstacleTimer;
  late ObstaclePool obstaclePool;
  GameState gameState = GameState.playing; // Use GameState enum
  Random random = Random();
  Duration generationTimer = const Duration(
    seconds: 1,
  ); // Initial timer duration

  late CameraComponent cameraComponent; // Add camera component

  @override
  FutureOr<void> onLoad() {
    GameConstants.initialize(this); // Initialize constants
    debugMode = true;
    characterComponent = Character(
      position: Vector2(50, 50),
      size: Vector2(50, 50),
    );

    joystick = GameJoystick();
    add(joystick);

    obstaclePool = ObstaclePool();
    startObstacleGeneration();
    add(characterComponent);

    // Camera setup
    cameraComponent = CameraComponent.withFixedResolution(
      width: GameConstants.screenWidth, // Ensure camera matches screen size
      height: GameConstants.screenHeight,
    )..viewfinder.anchor = Anchor.topLeft;
    cameraComponent.follow(characterComponent); // Follow the character
    add(cameraComponent);
    return super.onLoad();
  }

  void startObstacleGeneration() {
    obstacleTimer = Timer.periodic(generationTimer, (timer) {
      if (gameState == GameState.playing) {
        generateObstacleOnScreen();
        resetObstacleGenerationTimer(); // Reset the timer
      }
    });
  }

  void resetObstacleGenerationTimer() {
    generationTimer = Duration(
      milliseconds: 500 + random.nextInt(2500),
    ); // Random duration between 0.5 and 3 seconds
    obstacleTimer?.cancel();
    startObstacleGeneration();
  }

  void generateObstacleOnScreen() {
    Obstacle obstacle = obstaclePool.getObstacle(
      size.x,
      size.y,
      characterComponent.position.x,
    );
    add(obstacle);
    obstacleComponents.add(obstacle);
  }

  @override
  void update(double dt) {
    if (gameState == GameState.playing) {
      characterComponent.move(joystick.direction, dt);

      // Moves all obstacles to the left based on their speed.
      for (var obstacle in obstacleComponents) {
        obstacle.position.x -= obstacle.speed * dt;
      }

      // Removes obst obstacles that are off-screen and returns them to the pool.
      obstacleComponents.removeWhere((obstacle) {
        if (obstacle.position.x + GameConstants.screenWidth < 0) {
          obstaclePool.returnObstacle(obstacle);
          print(
            "Removed obstacle and returned to pool - ${obstacleComponents.length}",
          );
          return true;
        }
        return false;
      });
    }
    super.update(dt);
  }

  void gameOver() {
    gameState = GameState.gameOver;
    obstacleTimer?.cancel();
  }

  void restartGame() {
    gameState = GameState.playing;
    obstacleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameState == GameState.playing) {
        generateObstacleOnScreen();
      }
    });

    obstacleComponents.forEach((obstacle) {
      obstaclePool.returnObstacle(obstacle);
    });
    obstacleComponents.clear();
    characterComponent.position = Vector2(50, 50);
    characterComponent.velocity.setZero();
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
