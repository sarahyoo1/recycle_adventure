import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false, //Set it is not platform as default.
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = true;
  }
}
