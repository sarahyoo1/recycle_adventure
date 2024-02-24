bool checkCollision(player, block) {
  final hitbox = player.hitboxSetting;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final fixedX = player.scale.x < 0
      ? playerX - (hitbox.offsetX * 2) - playerWidth
      : playerX;
  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (fixedY < block.y + block.height &&
      playerY + playerHeight > block.y &&
      fixedX < block.x + block.width &&
      fixedX + playerWidth > block.x);
}
