import 'package:endless_surge/presentation/entities/obstacles/Obstacle.dart';
import 'package:endless_surge/presentation/entities/obstacles/obstacle_pool/ObstaclePool.dart';
import 'package:endless_surge/presentation/ui/game.dart'; // Import your game class
import 'package:endless_surge/utils/GameConstants.dart';
import 'dart:math';
import 'dart:async';

import 'package:flame/components.dart' show TextComponent;
import 'package:flame/extensions.dart' show Vector2;

enum GameState { playing, gameOver }

class GameManager {
  final SurgeGame game;
  int score = 0;
  double scoreTimer = 0;
  GameState gameState = GameState.playing;
  Timer? obstacleTimer;
  final Random random = Random();
  Duration generationTimer = GameConstants.initialObstacleGenerationDuration;
  final ObstaclePool obstaclePool = ObstaclePool();
  final List<Obstacle> obstacleComponents = [];

  GameManager(this.game);

  // Game state management
  void gameOver() {
    gameState = GameState.gameOver;
    obstacleTimer?.cancel();
  }

  void restartGame() {
    gameState = GameState.playing;
    startObstacleGeneration();
    for (var obstacle in obstacleComponents) {
      obstaclePool.returnObstacle(obstacle);
    }
    obstacleComponents.clear();
    game.characterComponent.position = Vector2(
      GameConstants.characterInitialX,
      GameConstants.characterInitialY,
    );
    game.characterComponent.velocity.setZero();
    score = 0;
    scoreTimer = 0;
    _updateScoreDisplay();
  }

  // Score management
  void incrementScore(double dt) {
    scoreTimer += dt;
    if (scoreTimer >= GameConstants.scoreIncrementInterval) {
      score++;
      scoreTimer -= GameConstants.scoreIncrementInterval;
      _updateScoreDisplay();
    }
  }

  void _updateScoreDisplay() {
    final scoreComponent = game.children.whereType<TextComponent>().firstOrNull;
    if (scoreComponent != null) {
      scoreComponent.text = 'Score: $score';
    }
  }

  // Obstacle generation
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
      game.characterComponent.position.x,
    );
    game.add(obstacle);
    obstacleComponents.add(obstacle);
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
        return true;
      }
      return false;
    });
  }
}
