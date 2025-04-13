import 'dart:async';
import 'package:flame/events.dart' show KeyboardEvents;
import 'package:endless_surge/presentation/entities/Character.dart';
import 'package:flame/components.dart'; // Correct import
import 'package:flame/game.dart';

import '../entities/joystick.dart';

class SurgeGame extends FlameGame with KeyboardEvents {
  late Character characterComponent;
  late GameJoystick joystick;

  @override
  FutureOr<void> onLoad() {
    characterComponent = Character(
      position: Vector2(50, 50),
      size: Vector2(50, 50),
    );
    add(characterComponent);

    joystick = GameJoystick();
    add(joystick);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    characterComponent.move(joystick.direction,dt);

    super.update(dt);
  }
}
