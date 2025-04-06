import 'package:endless_surge/presentation/ui/providers/gamestateprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CharacterWidget extends ConsumerWidget {
  const CharacterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final character = ref.watch(
      characterProvider,
    ); // Assuming you create a characterProvider
    return Positioned(
      left: character.positionX,
      bottom: character.positionY,
      child: Container(
        width: 50,
        height: 50,
        color: Colors.red, // Replace with your character sprite
      ),
    );
  }
}
