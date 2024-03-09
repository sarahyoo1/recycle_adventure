import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:recycle_adventure/components/player.dart';
import 'package:recycle_adventure/recycle_adventure.dart';

enum State {
  idle,
  bomb,
}

class Bomb extends SpriteAnimationGroupComponent
    with HasGameRef<RecycleAdventure>, CollisionCallbacks {
  Bomb({
    super.position,
    super.size,
  });

  late final SpriteAnimation _idleSpriteAnimation;
  late final SpriteAnimation _bombSpriteAnimation;

  double fallingSpeed = 100;
  bool hasBoomed = false;
  Vector2 velocity = Vector2.zero();

  @override
  FutureOr<void> onLoad() {
    priority = 10;
    _loadSpriteAnimations();
    add(RectangleHitbox(size: Vector2.all(10)));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!hasBoomed) {
      velocity.y = fallingSpeed;
      position.y += velocity.y * dt;
    }
    if (position.y >= 400) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      if (game.isSoundEffectOn) {
        FlameAudio.play('boss-bomb-explosion.wav',
            volume: game.soundEffectVolume);
      }
      hasBoomed = true;
      game.health--;
      velocity.y = 0;
      current = State.bomb;
      await animationTicker?.completed;

      removeFromParent();
    }
  }

  void _loadSpriteAnimations() {
    _idleSpriteAnimation = _spriteAnimation('Bomb', 6);
    _bombSpriteAnimation = _specialSpriteAnimation('BOOM', 8)..loop = false;

    animations = {
      State.idle: _idleSpriteAnimation,
      State.bomb: _bombSpriteAnimation,
    };

    current = State.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Boss/Machine Operator/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2.all(10),
      ),
    );
  }

  SpriteAnimation _specialSpriteAnimation(String state, int amount) {
    return SpriteAnimation.fromFrameData(
      game.images.fromCache('Boss/Machine Operator/$state.png'),
      SpriteAnimationData.sequenced(
        amount: amount,
        stepTime: 0.1,
        textureSize: Vector2.all(48),
      ),
    );
  }
}

//Bomb spawn manager class
class BombSpawnManager extends Component with HasGameRef<RecycleAdventure> {
  late Timer timer;
  double limit;
  Vector2 droppingPosition;
  BombSpawnManager({
    required this.limit,
    required this.droppingPosition,
  }) : super() {
    timer = Timer(limit, onTick: _spawnBombs, repeat: true);
  }

  @override
  void onRemove() {
    super.onRemove();
    timer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer.update(dt);
  }

  void _spawnBombs() {
    if (game.isSoundEffectOn) {
      FlameAudio.play('boss-bomb-spawn.mp3', volume: game.soundEffectVolume);
    }
    Bomb bomb = Bomb(position: droppingPosition);
    add(bomb);
  }
}
