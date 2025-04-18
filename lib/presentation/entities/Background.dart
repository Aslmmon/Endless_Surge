import 'package:endless_surge/presentation/ui/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class BackgroundParallax extends ParallaxComponent<SurgeGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('parallax/orig2.png'),
      ],
      baseVelocity: Vector2(40, 0),
      fill: LayerFill.height, // Or LayerFill.width
      alignment: Alignment.topCenter, // Or adjust as needed
    );
  }
}
