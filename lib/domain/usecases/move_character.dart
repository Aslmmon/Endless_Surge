import '../entities/character.dart';

abstract class MoveCharacter {
  Character call(Character character, double deltaTime);
}

class MoveCharacterImpl extends MoveCharacter {
  @override
  Character call(Character character, double deltaTime) {
    /**
     * that will make character only move horizontally for now
     */
    final newPositionX = character.positionX + character.speed * deltaTime;
    return character.copyWith(positionX: newPositionX);
  }
}
