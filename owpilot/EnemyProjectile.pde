class EnemyProjectile {
  PVector pos;
  
  float projSize;
  float speed;
  float rotation, currentPlayerY, currentPlayerX;
  
  PImage laserImage = loadImage("img/enemyLaser.png");
  
  EnemyProjectile(PVector position, PVector targetPosition) {
    pos = position;
    projSize = 2;
    speed = 10;
    
    currentPlayerY = targetPosition.y;
    currentPlayerX = targetPosition.x;
    
    rotation = atan2(targetPosition.y - pos.y, currentPlayerX - pos.x) / PI * 180;
  }
  
  void edgeCheck() {
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      enemyLasers.remove(i);
    }
  }
  
  void render() {
    pos.x += cos(rotation/180*PI)*speed;
    pos.y += sin(rotation/180*PI)*speed;
    
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(currentPlayerY - pos.y, currentPlayerX - pos.x));
      image(laserImage, 0, 0, 10, 10);
    popMatrix();
  }
}