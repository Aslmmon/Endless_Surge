import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class CollisionParticles extends ParticleSystemComponent {
  CollisionParticles({required Vector2 position})
    : super(
        particle: Particle.generate(
          count: 50, // Number of particles
          generator:
              (i) => CircleParticle(
                radius: 20 + i * 0.1, // Varying initial size
                paint: Paint()..color = Colors.red.withOpacity(0.6),
                lifespan: 500.0, // 1 minute lifespan in seconds
              ),
        ),
        position: position,
      );

  // You might want a way to stop these particles after the game over effect
  // Consider adding a method to remove the component.
}
