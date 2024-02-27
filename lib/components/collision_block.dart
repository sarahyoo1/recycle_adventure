import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({
    super.position,
    super.size,
    this.isPlatform = false, //Set it is not platform as default.
  }) {
    debugMode = true;
  }
}
