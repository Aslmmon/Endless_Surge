import 'dart:async';
import 'dart:math';
import 'package:endless_surge/presentation/entities/background/Background.dart';
import 'package:endless_surge/presentation/entities/character/Character.dart';
import 'package:endless_surge/presentation/entities/particles/collision_particles.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart' show Anchor, TextComponent;
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import '../entities/obstacles/Obstacle.dart';
import '../entities/Joystick/joystick.dart';
import '../entities/obstacles/obstacle_pool/ObstaclePool.dart';

class SurgeGame extends FlameGame with HasCollisionDetection {
  late Character characterComponent;
  late BackgroundParallax backgroundParallax;
  late GameJoystick joystick;
  List<Obstacle> obstacleComponents = [];
  Timer? obstacleTimer;
  late ObstaclePool obstaclePool;
  GameState gameState = GameState.playing;
  Random random = Random();
  Duration generationTimer = GameConstants.initialObstacleGenerationDuration;
  late CameraComponent cameraComponent;
  int _score = 0;
  double _scoreTimer = 0;

  @override
  FutureOr<void> onLoad() {
    GameConstants.initialize(this);
    setupBackground();
    setupCharacter();
    setupJoystick();
    setupObstaclePool();
    setupCamera();
    startObstacleGeneration();
    debugMode = true;

    _setupTextScoreComponent();
    return super.onLoad();
  }

  void setupBackground() {
    backgroundParallax = BackgroundParallax();
    add(backgroundParallax);
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

  void _setupTextScoreComponent() {
    final scoreTextPaint = TextPaint(
      style: TextStyle(
        fontSize: 32.0,
        color: Colors.white,
        fontFamily: 'Arial', // You can choose a different font
      ),
    );

    final scoreComponent = TextComponent(
      text: 'Score: $_score',
      textRenderer: scoreTextPaint,
      position: Vector2(
        GameConstants.screenWidth * 0.05,
        GameConstants.screenHeight * 0.05,
      ),
      // Position in the top-left
      anchor: Anchor.topLeft,
    );

    add(scoreComponent);
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
    Obstacle obstacle = obstaclePool.getObstacle(characterComponent.position.x);
    add(obstacle);
    obstacleComponents.add(obstacle);
  }

  @override
  void update(double dt) {
    if (gameState == GameState.playing) {
      characterComponent.move(joystick.direction, dt);
      _incrementScore(dt);
      moveObstacles(dt);
      removeOffScreenObstacles();
    }
    super.update(dt);
  }

  void _incrementScore(double dt) {
    _scoreTimer += dt;
    if (_scoreTimer >= GameConstants.scoreIncrementInterval) {
      _score++;
      _scoreTimer -= GameConstants.scoreIncrementInterval; // Reset the timer
      // Update the text of the score component
      final scoreComponent = children.whereType<TextComponent>().first;
      scoreComponent.text = 'Score: $_score';
    }
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
