import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:pixel_adventure/components/player.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum State {
  idle,
  jump,
}

class Trampoline extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure> {
  final int offsetVertical;
  Trampoline({
    super.position,
    super.size,
    required this.offsetVertical,
  });

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _jumpSpriteAnimation;
  late final Player player;

  bool isPlayerOnTram = false;
  static const tileSize = 16;
  late final double bounceHeight;

  @override
  FutureOr<void> onLoad() {
    debugMode = false;
    player = game.player;

    bounceHeight = position.y +
        offsetVertical * tileSize -
        player.position.y +
        player.height;

    _loadAnimations();

    add(
      RectangleHitbox(
        position: Vector2(2, 20),
        size: Vector2(26, 10),
      ),
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPlayerOnTram) {
      _bouncePlayer(dt);
    }
  }

  void _loadAnimations() {
    _idleSpriteAnimation = _spriteAnimation('Idle', 1);
    _jumpSpriteAnimation = _spriteAnimation('Jump', 8)..loop = false;

    animations = {
      State.idle: _idleSpriteAnimation,
      State.jump: _jumpSpriteAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Traps/Trampoline/$state (28x28).png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.05,
        textureSize: Vector2.all(28),
      ),
    );
  }

  void collidedWithPlayer() async {
    isPlayerOnTram = true;

    current = State.jump;
    await animationTicker?.completed;
    animationTicker?.reset();

    isPlayerOnTram = false;

    current = State.idle;
  }

  void _bouncePlayer(dt) {
    player.velocity.y = -bounceHeight;
    player.position.y += player.velocity.y * dt;
    player.hasJumped = true;
    player.isOnGround = false;
  }
}
