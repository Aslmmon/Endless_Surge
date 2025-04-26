import 'package:endless_surge/presentation/entities/obstacles/Obstacle.dart'
    show Obstacle;
import 'package:endless_surge/utils/AssetsPaths.dart' show AssetPaths;
import 'package:endless_surge/utils/GameConstants.dart';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flame/flame.dart';

class Projectile extends SpriteAnimationComponent with CollisionCallbacks {
  Vector2 direction;
  double speed = 400;

  Projectile({required Vector2 position, required this.direction})
    : super(position: position, size: Vector2.all(30));

  @override
  Future<void> onLoad() async {
    animation = await _loadRunAnimation();
    add(RectangleHitbox(size: Vector2.all(20)));
    return super.onLoad();
  }

  Future<SpriteAnimation> _loadRunAnimation() async {
    final image1 = await Flame.images.load(AssetPaths.projectTiles_1);
    final image2 = await Flame.images.load(AssetPaths.projectTiles_2);
    final image3 = await Flame.images.load(AssetPaths.projectTiles_3);
    final image4 = await Flame.images.load(AssetPaths.projectTiles_4);

    return SpriteAnimation.spriteList([
      Sprite(image1),
      Sprite(image2),
      Sprite(image3),
      Sprite(image4),
    ], stepTime: AssetPaths.projectTileRunStepTime);
  }

  @override
  void update(double dt) {
    position += direction * speed * dt;
    if (position.x > GameConstants.screenWidth ||
        position.x < 0 ||
        position.y > GameConstants.screenHeight ||
        position.y < 0) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Obstacle) {
      removeFromParent(); // Destroy projectile on hit
    }
    super.onCollision(intersectionPoints, other);
  }
}
