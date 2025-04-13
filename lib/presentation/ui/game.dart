
import 'dart:async';

import 'package:flame/events.dart' show KeyboardEvents;
import 'package:endless_surge/presentation/entities/Character.dart';
import 'package:flame/game.dart';

import '../entities/Obstacle.dart';
import '../entities/joystick.dart';

class SurgeGame extends FlameGame with KeyboardEvents {
  late Character characterComponent;
  late GameJoystick joystick;
  List<Obstacle> obstacleComponents = [];
  Timer? obstacleTimer;

  @override
  FutureOr<void> onLoad() {
    characterComponent = Character(
      position: Vector2(50, 50),
      size: Vector2(50, 50),
    );
    add(characterComponent);

    joystick = GameJoystick();
    add(joystick);


    obstacleTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      generateObstacleOnScreen();
    });

    return super.onLoad();
  }

  void generateObstacleOnScreen() {
    Obstacle obstacle = generateObstacle(size.x, size.y, characterComponent.position.x);
    add(obstacle);
    obstacleComponents.add(obstacle);


  }

  @override
  void update(double dt) {
    characterComponent.move(joystick.direction,dt);
    for (var obstacle in obstacleComponents) {
      obstacle.position.x -= 100 * dt; // Move obstacles to the left
    }
    obstacleComponents.removeWhere((obstacle) => obstacle.position.x < characterComponent.position.x - 100); // Remove obstacles off screen

    super.update(dt);
  }

  @override
  void onRemove() {
    obstacleTimer?.cancel();
    super.onRemove();
  }
}
