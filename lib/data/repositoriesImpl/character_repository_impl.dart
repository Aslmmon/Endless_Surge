import 'package:endless_surge/domain/entities/character.dart';
import 'package:endless_surge/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl extends CharacterRepository {
  Character _character = Character(
    positionX: 0,
    positionY: 0,
    speed: 100,
  ); // Initial character state

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
