import 'package:endless_surge/domain/entities/character.dart';
import 'package:endless_surge/domain/repositories/character_repository.dart';
import 'package:flame/components.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  Character _character = Character(
    position: Vector2(100, 100), // Initial position
    size: Vector2(50, 50), // Character size
    speed: 100.0, // Character speed (pixels per second)
  );

  @override
  Character getCharacter() {
    return _character;
  }

  @override
  Character updateCharacter(Character character) {
    _character = character;
    return _character;
  }
}
