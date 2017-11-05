class PlayerShip {
  PVector pos;
  PVector vel;
  PVector accel;
  
  float drag;
  float shipSize;
  
  PImage playerImg = loadImage("img/player.png");
  
  PlayerShip() {
    pos = new PVector(width/2, height/2);
    vel = new PVector(0,0);
    accel = new PVector(0,0);
    drag = 0.9;
    shipSize = 10;
  }
  
  void update() {
    //KEY EVENT CHECKS
  
    /*if (upPressed && shiftPressed && blinks > 0) {
      slipstream.pos = slipstream.pos.add(new PVector(0, -40));
      blinks--;
    } else*/ 
    if (upPressed) {
      slipstream.accel = slipstream.accel.add(new PVector(0, -playerSpeed));
    }
    if (downPressed) {
      slipstream.accel = slipstream.accel.add(new PVector(0, playerSpeed));
    }
    if (leftPressed) {
      slipstream.accel = slipstream.accel.add(new PVector (-playerSpeed, 0));
    }
    if (rightPressed) {
      slipstream.accel = slipstream.accel.add(new PVector (playerSpeed, 0));
    }
    
    vel.add(accel);
    vel.mult(drag);
    vel.limit(4);
    pos.add(vel);
  }
  
  void render() {
    pushMatrix();
      translate(pos.x, pos.y);
      rotate(atan2(mouseY - pos.y, mouseX - pos.x));
      image(playerImg, 0, 0, 5*shipSize, 6*shipSize);
    popMatrix();
  }
  
  boolean checkMotherCollision(ArrayList<EnemyMothership> motherships){
   for(EnemyMothership mothership : motherships){
     PVector distance = PVector.sub(mothership.pos, pos);
     if(distance.mag() < mothership.shipSize/2 + shipSize*6/2){
       motherships.remove(mothership);
       smallships.add(new EnemyShip(new PVector (mothership.pos.x - 25, mothership.pos.y - 25), pos));
       smallships.add(new EnemyShip(new PVector (mothership.pos.x + 25, mothership.pos.y + 25), pos));
       
       //explodeAnim.play();
       //image(explodeAnim, mothership.pos.x, mothership.pos.y, 100, 100);
       return true;
     }
   }
   return false;
  }
  
  boolean checkChildCollision(ArrayList<EnemyShip> smallships){
   for(EnemyShip banshee : smallships){
    PVector distance = PVector.sub(banshee.pos, pos);
    if(distance.mag() < banshee.shipSize*5/2 + shipSize*6/2){
      smallships.remove(banshee);
      
      //explodeAnim.play();
      //image(explodeAnim, banshee.pos.x, banshee.pos.y, 50, 50);
     return true; 
    }
   }
   return false;
  }
  
  boolean checkLaserCollision(ArrayList<EnemyProjectile> enemyLasers){
   for(EnemyProjectile laser : enemyLasers){
    PVector distance = PVector.sub(laser.pos, pos);
    if(distance.mag() < laser.projSize*5/2 + shipSize*6/2){
      enemyLasers.remove(laser);
      
      //explodeAnim.play();
      //image(explodeAnim, pos.x, pos.y, 50, 50);
     return true;
    }
   }
   return false;
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