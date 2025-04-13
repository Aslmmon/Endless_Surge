import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';

class GameJoystick extends JoystickComponent {
  GameJoystick()
      : super(
    knob: CircleComponent(radius: 30, paint: Paint()..color = const Color(0xff3f51b5)),
    background: CircleComponent(radius: 100, paint: Paint()..color = const Color(0x803f51b5)),
    margin: const EdgeInsets.only(left: 40, bottom: 40),
  );
}