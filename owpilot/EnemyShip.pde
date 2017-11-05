class EnemyShip {
  PVector pos, playerPos, vel;
  
  float shipSize, speed, rotation, fireDelay, fireCounter;
  
  PImage banshee = loadImage("img/banshee.png");;
  
  EnemyShip(PVector motherPos, PVector targetPos) {
    pos = motherPos;
    playerPos = targetPos;
    fireDelay = 60*1;
    fireCounter = 0;
    shipSize = 10;
    speed = 2;
    rotation = atan2(playerPos.y - pos.y, playerPos.x - pos.x);
  }
  
  void render() {
    pos.x += cos(atan2(playerPos.y - pos.y, playerPos.x - pos.x))*speed;
    pos.y += sin(atan2(playerPos.y - pos.y, playerPos.x - pos.x))*speed;
    
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(playerPos.y - pos.y, playerPos.x - pos.x));
      image(banshee, 0, 0, 5.5*shipSize, 4*shipSize);
    popMatrix();
  }
  
  void edgeCheck() {
    if (pos.x < shipSize) {
      pos.x = width - shipSize;
    }
    if (pos.x > width - shipSize) {
      pos.x = shipSize;
    }
    if (pos.y < shipSize) {
      pos.y = height - shipSize;
    }
    if (pos.y > height - shipSize) {
      pos.y = shipSize;
    }
  }
}