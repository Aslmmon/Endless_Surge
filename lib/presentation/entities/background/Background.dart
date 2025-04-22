import 'package:endless_surge/presentation/ui/game.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';

class BackgroundParallax extends ParallaxComponent<SurgeGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('parallax/1.png'),
        ParallaxImageData('parallax/2.png'),
        ParallaxImageData('parallax/3.png'),
        ParallaxImageData('parallax/4.png'),
        ParallaxImageData('parallax/5.png'),
        ParallaxImageData('parallax/6.png'),
      ],
      baseVelocity: Vector2(40, 0),
      fill: LayerFill.height, // Or LayerFill.width
      alignment: Alignment.topCenter, // Or adjust as needed
    );
  }
}
