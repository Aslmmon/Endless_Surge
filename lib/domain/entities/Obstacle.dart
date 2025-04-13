import 'package:flame/components.dart';

class Obstacle extends PositionComponent {
  Obstacle({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);
}