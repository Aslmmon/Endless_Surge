import 'package:endless_surge/domain/entities/character.dart' show Character;

abstract class CharacterRepository {
  Character getCharacter();

  Character updateCharacter(Character character);
}

