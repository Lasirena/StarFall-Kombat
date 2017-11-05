class EnemyMothership {
  PVector pos, vel, rotation;
  
  float shipSize, spin, omegaLimit, angle;
  
  float whichaxis, whichpos;
  
  PImage mothershipImage = loadImage("img/mothership.png");
  
  EnemyMothership() {
    shipSize = 100;
    omegaLimit = 0.02;
    
    whichaxis = (int)random(0,1);
    whichpos = (int)random(0,1);
    pos = new PVector(0, 0);
    if (whichaxis == 1) {
      if (whichpos == 1) {
        pos = new PVector(width, (int)random(0, height));
      } else {
        pos = new PVector(0, (int)random(0, height));
      }
    } 
    else {
      if (whichpos == 1) {
        pos = new PVector((int)random(0, width), height);
      } else {
        pos = new PVector((int)random(0, width), 0);
      }
    }
    
    angle = random(2 * PI);
    vel = new PVector(cos(angle), sin(angle));
    vel.mult((150*150)/(shipSize*shipSize));
    rotation = new PVector(cos(angle), sin(angle));
    spin = (float)(Math.random()*omegaLimit-omegaLimit/2);
  }
  
  void update(){
    pos.add(vel);
    rotate2D(rotation, spin);
  }
  
  void render() {
    circ(pos.x, pos.y);
    
    if (pos.x < shipSize){
      circ(pos.x + width, pos.y);
    } 
    else if (pos.x > width - shipSize) {
      circ(pos.x - width, pos.y);
    }
    
    if (pos.y < shipSize) {
      circ(pos.x, pos.y + height);
    } 
    else if (pos.y > height - shipSize){
      circ(pos.x, pos.y - height);
    }
  }
  
  void circ(float x, float y){
    pushMatrix();
      translate(x, y);
      rotate(heading2D(rotation)+PI/2);
      image(mothershipImage, 0, 0, shipSize, shipSize);
    popMatrix();
 } 

  void edgeCheck() {
    if (pos.x < shipSize/2) {
      pos.x = width - shipSize/2;
    }
    if (pos.x > width - shipSize/2) {
      pos.x = shipSize/2;
    }
    if (pos.y < shipSize/2) {
      pos.y = height - shipSize/2;
    }
    if (pos.y > height - shipSize/2) {
      pos.y = shipSize/2;
    }
  }
}