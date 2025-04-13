import 'package:endless_surge/domain/usecases/move_character.dart'
    show MoveCharacterImpl;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerState, ConsumerStatefulWidget;
import 'package:flame/game.dart';

import 'package:endless_surge/domain/entities/character.dart';

import 'package:flame/game.dart';
import 'package:flame/components.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late MyGame game; // Use MyGame

  @override
  void initState() {
    super.initState();
    game = MyGame(); // Use MyGame
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: game));
  }
}

class MyGame extends FlameGame {
  late Character characterComponent;

  @override
  Future<void> onLoad() async {
    characterComponent = Character(
      position: Vector2(100, 100),
      size: Vector2(50, 50),
      speed: 100.0,
    );
    add(characterComponent);
  }
}
