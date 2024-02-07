import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:pixel_adventure/components/enemy.dart';

enum State {
  idle,
  flying,
  hit,
  ceilingIn,
  ceilingOut,
}

class Bat extends Enemy {
  Bat({
    super.position,
    super.size,
    super.offsetPositive,
    super.offsetNegative,
  });

  late final SpriteAnimation _idleAnimation;
  late final SpriteAnimation _flyingAnimation;
  late final SpriteAnimation _hitAnimation;
  late final SpriteAnimation _ceilingInAnimation;
  late final SpriteAnimation _ceilingOutAnimation;

  Vector2 startingPoint = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    startingPoint = Vector2(position.x, position.y);
    _loadAnimations();
    calculateRange();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updateState();
    movement(dt);
    super.update(dt);
  }

  void _loadAnimations() {
    _idleAnimation = _spriteAnimation('Idle', 12);
    _flyingAnimation = _spriteAnimation('Flying', 7);
    _hitAnimation = _spriteAnimation('Hit', 5);
    _ceilingInAnimation = _spriteAnimation('Ceiling In', 7);
    _ceilingOutAnimation = _spriteAnimation('Ceiling Out', 7);

    animations = {
      State.idle: _idleAnimation,
      State.flying: _flyingAnimation,
      State.hit: _hitAnimation,
      State.ceilingIn: _ceilingInAnimation..loop = false,
      State.ceilingOut: _ceilingOutAnimation..loop = false,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Enemies/Bat/$state (46x30).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.097,
        textureSize: Vector2(46, 36),
      ),
    );
  }

  void _updateState() async {
    current = (velocity.x != 0) ? State.flying : State.idle;

    //Flips enemy depending on the player's direction.
    if ((moveDirection > 0 && scale.x > 0) ||
        (moveDirection < 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
    }
  }
}
