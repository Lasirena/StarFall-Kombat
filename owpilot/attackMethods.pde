void playerFire() {
  PVector pos = new PVector(0, 0);
  pos.add(slipstream.pos);
  playerLasers.add(new Projectile(pos));
}

void enemyFire(PVector enemyPos) {
  PVector pos = new PVector(0, 0);
  pos.add(enemyPos);
  enemyLasers.add(new EnemyProjectile(pos, slipstream.pos));
}