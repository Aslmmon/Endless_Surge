import 'dart:async';
import 'dart:math';
import 'package:endless_surge/presentation/entities/Character.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart' show Anchor;
import 'package:flame/game.dart';
import '../entities/Obstacle.dart';
import '../entities/joystick.dart';
import '../entities/obstacle_pool/ObstaclePool.dart';

class SurgeGame extends FlameGame with HasCollisionDetection {
  late Character characterComponent;
  late GameJoystick joystick;
  List<Obstacle> obstacleComponents = [];
  Timer? obstacleTimer;
  late ObstaclePool obstaclePool;
  GameState gameState = GameState.playing;
  Random random = Random();
  Duration generationTimer = GameConstants.initialObstacleGenerationDuration;
  late CameraComponent cameraComponent;

  @override
  FutureOr<void> onLoad() {
    GameConstants.initialize(this);
    setupCharacter();
    setupJoystick();
    setupObstaclePool();
    setupCamera();
    startObstacleGeneration();
    debugMode = true;
    return super.onLoad();
  }

  void setupCharacter() {
    characterComponent = Character(
      position: Vector2(
        GameConstants.characterInitialX,
        GameConstants.characterInitialY,
      ),
      size: Vector2.all(GameConstants.characterSize),
    );
    add(characterComponent);
  }

  void setupJoystick() {
    joystick = GameJoystick();
    add(joystick);
  }

  void setupObstaclePool() {
    obstaclePool = ObstaclePool();
  }

  void setupCamera() {
    cameraComponent = CameraComponent.withFixedResolution(
      width: GameConstants.screenWidth,
      height: GameConstants.screenHeight,
    )..viewfinder.anchor = Anchor.topLeft;
    cameraComponent.follow(characterComponent);
    add(cameraComponent);
  }

  void startObstacleGeneration() {
    obstacleTimer = Timer.periodic(generationTimer, (timer) {
      if (gameState == GameState.playing) {
        generateObstacleOnScreen();
        resetObstacleGenerationTimer();
      }
    });
  }

  void resetObstacleGenerationTimer() {
    generationTimer = Duration(
      milliseconds:
          GameConstants.obstacleGenerationIntervalMin.toInt() +
          random.nextInt(
            GameConstants.obstacleGenerationIntervalMax.toInt() -
                GameConstants.obstacleGenerationIntervalMin.toInt(),
          ),
    );
    obstacleTimer?.cancel();
    startObstacleGeneration();
  }

  void generateObstacleOnScreen() {
    Obstacle obstacle = obstaclePool.getObstacle(
      characterComponent.position.x,
    );
    add(obstacle);
    obstacleComponents.add(obstacle);
  }

  @override
  void update(double dt) {
    if (gameState == GameState.playing) {
      characterComponent.move(joystick.direction, dt);
      moveObstacles(dt);
      removeOffScreenObstacles();
    }
    super.update(dt);
  }

  void moveObstacles(double dt) {
    for (var obstacle in obstacleComponents) {
      obstacle.position.x -= obstacle.speed * dt;
    }
  }

  void removeOffScreenObstacles() {
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

  void gameOver() {
    gameState = GameState.gameOver;
    obstacleTimer?.cancel();

  }

  void restartGame() {
    gameState = GameState.playing;
    startObstacleGeneration();
    obstacleComponents.forEach((obstacle) {
      obstaclePool.returnObstacle(obstacle);
    });
    obstacleComponents.clear();
    characterComponent.position = Vector2(
      GameConstants.characterInitialX,
      GameConstants.characterInitialY,
    );
    characterComponent.velocity.setZero();
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
