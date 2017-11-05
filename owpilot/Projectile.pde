class Projectile {
  PVector pos;
  
  float projSize;
  float speed;
  float rotation, mouseposX, mouseposY;
  
  PImage laserImage = loadImage("img/playerLaser.png");
  
  Projectile(PVector position) {
    pos = position;
    projSize = 2;
    speed = 10;
    
    mouseposX = mouseX;
    mouseposY = mouseY;
    rotation = atan2(mouseposY - pos.y, mouseposX - pos.x) / PI * 180;
  }
  
  void edgeCheck() {
    if (pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height) {
      playerLasers.remove(i);
    }
  }
  
  boolean checkMotherCollision(ArrayList<EnemyMothership> motherships){
   for(EnemyMothership mothership : motherships){
     PVector distance = PVector.sub(pos, mothership.pos);
     if(distance.mag() < mothership.shipSize/2){
      motherships.remove(mothership);
      smallships.add(new EnemyShip(new PVector (mothership.pos.x - 25, mothership.pos.y - 25), slipstream.pos));
      smallships.add(new EnemyShip(new PVector (mothership.pos.x + 25, mothership.pos.y + 25), slipstream.pos));
      
      //explodeAnim.play();
      //image(explodeAnim, mothership.pos.x, mothership.pos.y, 100, 100);
      return true;
     }
   }
   return false;
  }
  
  boolean checkChildCollision(ArrayList<EnemyShip> smallships){
   for(EnemyShip banshee : smallships){
     PVector distance = PVector.sub(pos, banshee.pos);
     if(distance.mag() < banshee.shipSize*5/2){
      smallships.remove(banshee);
      
      //explodeAnim.play();
      //image(explodeAnim, banshee.pos.x, banshee.pos.y, 50, 50);
      return true;
     }
   }
   return false;
  }
  
  void render() {
    pos.x += cos(rotation/180*PI)*speed;
    pos.y += sin(rotation/180*PI)*speed;
    
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(mouseposY - pos.y, mouseposX - pos.x));
      image(laserImage, 0, 0, 10, 10);
    popMatrix();
  }
}