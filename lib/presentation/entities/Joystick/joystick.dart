import 'dart:ui';
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class GameJoystick extends JoystickComponent {
  GameJoystick()
    : super(
        knob: CircleComponent(
          radius: GameConstants.joystickKnobRadius,
          paint: Paint()..color = GameConstants.joystickKnobColor,
        ),
        background: CircleComponent(
          radius: GameConstants.joystickBackgroundRadius,
          paint: Paint()..color = GameConstants.joystickBackgroundColor,
        ),
        margin: EdgeInsets.only(
          left: GameConstants.joystickMarginLeft,
          bottom: GameConstants.joystickMarginBottom,
        ),
      );
}
