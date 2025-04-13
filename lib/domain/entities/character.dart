import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Character extends PositionComponent with CollisionCallbacks {
  double speed;

  Character({
    required Vector2 position,
    required Vector2 size,
    required this.speed,
  }) : super(position: position, size: size) {
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.red, // Set color to red
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += speed * dt;
  }
}
