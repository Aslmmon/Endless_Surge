import 'dart:ui';

import 'package:endless_surge/presentation/ui/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class FireButton extends PositionComponent
    with TapCallbacks, HasGameRef<SurgeGame> {
  final Paint _buttonPaint = Paint()..color = Colors.blue.withOpacity(0.5);

  final VoidCallback onFireButtonClicked;
  final Paint _borderPaint =
      Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

  FireButton(
    this.onFireButtonClicked, {
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _buttonPaint);
    canvas.drawCircle(Offset(size.x / 2, size.y / 2), size.x / 2, _borderPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    onFireButtonClicked();
    super.onTapDown(event);
  }
}
