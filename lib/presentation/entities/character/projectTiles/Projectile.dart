import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';

class Projectile extends PositionComponent with CollisionCallbacks {
  Vector2 direction;
  double speed = 400;
  final Paint _paint = Paint()..color = Colors.yellow;

  Projectile({required Vector2 position, required this.direction})
      : super(position: position, size: Vector2(10, 5));

  @override
  void render(Canvas canvas) {
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), _paint);
  }

  @override
  void update(double dt) {
    position += direction * speed * dt;
    // Remove projectile when it goes off-screen
    if (position.x > GameConstants.screenWidth || position.x < 0 || position.y > GameConstants.screenHeight || position.y < 0) {
      removeFromParent();
    }
  }

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox());
    return super.onLoad();
  }
}