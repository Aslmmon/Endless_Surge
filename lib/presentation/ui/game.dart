import 'dart:async';
import 'dart:io';
import 'package:endless_surge/managers/GameManager.dart'
    show GameManager, GameState;
import 'package:endless_surge/presentation/entities/background/Background.dart';
import 'package:endless_surge/presentation/entities/character/Character.dart';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart' show Anchor, TextComponent;
import 'package:flame/events.dart' show TapCallbacks, TapDownEvent, TapDownInfo;
import 'package:flame/game.dart';
import 'package:flame/text.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import '../../utils/AssetsPaths.dart';
import '../entities/Joystick/joystick.dart';

class SurgeGame extends FlameGame with HasCollisionDetection, TapCallbacks {
  late Character characterComponent;
  late BackgroundParallax backgroundParallax;
  late GameJoystick joystick;
  late CameraComponent cameraComponent;
  late final GameManager gameManager; // Use final and initialize in onLoad
  static const double scoreIncrementInterval =
      0.5; // Keep as a constant here for now
  bool _audioStarted = false;
  AudioPlayer? _backgroundMusicPlayer; // Store the player instance

  @override
  Future<void> onLoad() async {
    GameConstants.initialize(this);
    gameManager = GameManager(this); // Initialize GameManager

    FlameAudio.audioCache.loadAll([
      AssetPaths.planeSound,
      AssetPaths.explosionSound,
      AssetPaths.backgroundSound,
    ]);

    if (isWeb()) {
      print("Running on Web");
    } else {
      print("Running on a native platform (Android, iOS, Desktop)");
      await _startBackgroundMusic(); // Start immediately on native
    }
    _setupBackground();
    _setupCharacter();
    _setupJoystick();
    _setupCamera();
    gameManager.startObstacleGeneration(); // Delegate to GameManager
    _setupTextScoreComponent();
    debugMode = false;

    return super.onLoad();
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isWeb() && !_audioStarted) {
      _startBackgroundMusic();
      _audioStarted = true;
    }
    super.onTapDown(event); // Don't forget to call super
  }

  Future<void> _startBackgroundMusic() async {
    if (_backgroundMusicPlayer?.state != PlayerState.playing &&
        gameManager.gameState == GameState.playing) {
      _backgroundMusicPlayer = await FlameAudio.loop(
        AssetPaths.backgroundSound,
        volume: 0.5,
      );
    }
  }

  void _setupBackground() {
    backgroundParallax = BackgroundParallax();
    add(backgroundParallax);
  }

  void _setupCharacter() {
    characterComponent = Character(
      position: Vector2(
        GameConstants.characterInitialX,
        GameConstants.characterInitialY,
      ),
      size: Vector2.all(GameConstants.characterSize),
    );
    add(characterComponent);
  }

  void _setupJoystick() {
    joystick = GameJoystick();
    add(joystick);
  }

  void _setupCamera() {
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
        fontFamily: AssetPaths.appFont, // You can choose a different font
      ),
    );

    final scoreComponent = TextComponent(
      text: 'Score: ${gameManager.score}', // Get initial score from GameManager
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

  @override
  void update(double dt) {
    if (gameManager.gameState == GameState.playing) {
      characterComponent.move(joystick.direction, dt);
      gameManager.incrementScore(dt); // Delegate to GameManager
      gameManager.moveObstacles(dt); // Delegate to GameManager
      gameManager.removeOffScreenObstacles(); // Delegate to GameManager
    }
    super.update(dt);
  }

  void gameOver() => gameManager.gameOver();

  void restartGame() => gameManager.restartGame();

  @override
  void onRemove() {
    gameManager.obstacleTimer?.cancel(); // Delegate to GameManager
    _backgroundMusicPlayer?.dispose(); // Clean up on removal
    super.onRemove();
  }
}

bool isWeb() {
  try {
    return Platform.environment.containsKey('FLUTTER_WEB_ORIGIN');
  } catch (e) {
    return true; // Assume it's web if there's an error accessing Platform
  }
}
