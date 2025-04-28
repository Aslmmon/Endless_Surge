import 'dart:ui';

import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class FireButton extends JoystickComponent with TapCallbacks {
  final VoidCallback onFireButtonClicked;

  FireButton(this.onFireButtonClicked, {required Vector2 size})
    : super(
        knob: CircleComponent(
          radius: size.x / 3,
          paint: Paint()..color = Colors.red.withOpacity(0.8),
        ),
        background: CircleComponent(
          radius: size.x / 2,
          paint: Paint()..color = Colors.red.withOpacity(0.2),
        ),
        margin: EdgeInsets.only(
          right: GameConstants.joystickMarginLeft,
          bottom: GameConstants.joystickMarginBottom,
        ),
      );

  @override
  void onTapDown(TapDownEvent event) {
    onFireButtonClicked();
    super.onTapDown(event);
  }
}
