import 'package:endless_surge/utils/AssetsPaths.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';

class CollisionParticles extends ParticleSystemComponent with HasGameRef {
  CollisionParticles({required Vector2 position}) : super(position: position);

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load(AssetPaths.particleEffect);
    final spriteSheet = SpriteSheet(image: image, srcSize: Vector2(128, 128));

    final animation = spriteSheet.createAnimation(
      row: 2,
      stepTime: 0.2,
      loop: true,
      to: 4,

    );

    particle = SpriteAnimationParticle(
      animation: animation,
      lifespan: 1,
      size: Vector2.all(128),
    );
  }
}
