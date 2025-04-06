class Character {
  final double positionX;
  final double positionY;
  final double speed;

  Character({
    required this.positionX,
    required this.positionY,
    required this.speed,
  });

  Character copyWith({double? positionX, double? positionY, double? speed}) {
    return Character(
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      speed: speed ?? this.speed,
    );
  }
}
