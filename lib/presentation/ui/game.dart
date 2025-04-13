import 'dart:async';
import 'package:endless_surge/domain/usecases/move_character.dart' show MoveCharacterImpl;
import 'package:endless_surge/presentation/ui/providers/gamestateprovider.dart' show characterProvider;
import 'package:endless_surge/presentation/ui/widgets/Character.dart';
import 'package:flutter/cupertino.dart' show TickerProviderStateMixin;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerState, ConsumerStatefulWidget;

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  final _moveCharacter = MoveCharacterImpl();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final character = ref.read(characterProvider);
      final newCharacter = _moveCharacter(character, 0.016);
      ref.read(characterProvider.notifier).state = newCharacter;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: const [CharacterWidget()]));
  }
}
