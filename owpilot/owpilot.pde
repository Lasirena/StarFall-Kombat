//use left click mouse check for blink functionality? needs testing
//define explosion class that takes a position vector of the exploded ship - look into processing animation

//loading libraries
import ddf.minim.*;
//import gifAnimation.*;
Minim minim;
//Gif explodeAnim;

//defining sound samples
AudioSample laserSound, largeExplode, smallExplode, hoverUI, clickUI;
AudioPlayer combatMusic, menuMusic;

//defining images
PImage bgSpace, bgSpaceFaded;
PImage btnPlay, btnPlayActive, btnQuit, btnQuitActive, btnLeaderboards, btnLeaderboardsActive, btnYes, btnYesActive, btnNo, btnNoActive, btnBack, btnBackActive;
float btnWidth = 207, btnHeight = 41;
PImage gameCursor;
PImage livesImage, ammoImage;
PImage logo, gameOver, top10;

//defining other assets
PFont sc2font;
Table leaderboard;

//defining major variables
boolean upPressed, downPressed, leftPressed, rightPressed;//, shiftPressed;
boolean newGame;

float playerSpeed = 2;
float projSpeed = 10;

int mothershipCount;
int maxLives = 3;
int lives;
int maxAmmo = 5;
int ammo;
float regenRate = 60*1.5;
float regenCounter;
int score;

//list of gamestates:
//-2 - username input
//-1 - menu mode
//0 - play mode death
//1 - play mode
//2 - leaderboards
int gameState = -1;

int i;

String username;

ArrayList<Projectile> playerLasers;
ArrayList<EnemyProjectile> enemyLasers;

ArrayList<EnemyMothership> motherships;
ArrayList<EnemyShip> smallships;

PlayerShip slipstream;

void setup() {
  //eyecandy
  size(1366, 768);
  noStroke();
  imageMode(CENTER);
  frameRate(60);
  
  gameCursor = loadImage("img/sc2cursor.png");
  cursor(gameCursor, 0, 0);
  
  sc2font = createFont("fonts/sc2font.ttf", 32);
  textAlign(CENTER,CENTER);

  //sound
  minim = new Minim(this);
  combatMusic = minim.loadFile("fx/reptile.mp3");
  menuMusic = minim.loadFile("fx/menu.mp3");
  
  //hoverUI = 
  clickUI = minim.loadSample("fx/clickUI.wav");
  
  laserSound = minim.loadSample("fx/laserSound.wav");
  largeExplode = minim.loadSample("fx/largeExplode.mp3");
  smallExplode = minim.loadSample("fx/smallExplode.mp3");

  //images
  bgSpace =  loadImage("img/bgWideBlue.jpg");
  bgSpaceFaded = loadImage("img/bgWideBlueFaded.jpg");
  logo = loadImage("img/logo2.png");
  top10 = loadImage("img/top10.png");
  gameOver = loadImage("img/gameOver.png");
  btnPlay = loadImage("img/btnPlay.png");
  btnPlayActive = loadImage("img/btnPlayActive.png");
  btnQuit = loadImage("img/btnQuit.png");
  btnQuitActive = loadImage("img/btnQuitActive.png");
  btnLeaderboards = loadImage("img/btnLeaderboards.png");
  btnLeaderboardsActive = loadImage("img/btnLeaderboardsActive.png");
  btnYes = loadImage("img/btnYes.png");
  btnYesActive = loadImage("img/btnYesActive.png");
  btnNo = loadImage("img/btnNo.png");
  btnNoActive = loadImage("img/btnNoActive.png");
  btnBack = loadImage("img/btnBack.png");
  btnBackActive = loadImage("img/btnBackActive.png");
  
  livesImage = loadImage("img/player.png");
  ammoImage = loadImage("img/playerLaser.png");
  //explodeAnim = new Gif(this, "img/explosion.gif");
  
  //other
  leaderboard = loadTable("leaderboard.csv", "header");
}

void draw() {
  //main menu
  if (gameState == -1) {
    background(bgSpace);
    menuMusic.play();
    image(logo, width/2, 170, 1000, 90);
    
    image(btnPlay, width/2, height/2 - (btnHeight + 10), btnWidth, btnHeight);
    if (mouseOnPlay()) {
      image(btnPlayActive, width/2, height/2 - (btnHeight + 10), btnWidth, btnHeight);
    }
    
    image(btnLeaderboards, width/2, height/2, btnWidth, btnHeight);
    if (mouseOnLeaderboards()) {
      image(btnLeaderboardsActive, width/2, height/2, btnWidth, btnHeight);
    }
    
    image(btnQuit, width/2, height/2 + (btnHeight + 10), btnWidth, btnHeight);
    if (mouseOnQuit()) {
      image(btnQuitActive, width/2, height/2 + (btnHeight + 10), btnWidth, btnHeight);
    }
  }
  
  //play mode
  else if (gameState == 1) {
    background(bgSpace);
    combatMusic.play();
    
    if (newGame) {
      playerLasers = new ArrayList<Projectile>();
      enemyLasers = new ArrayList<EnemyProjectile>();
    
      motherships = new ArrayList<EnemyMothership>();
      smallships = new ArrayList<EnemyShip>();
    
      slipstream = new PlayerShip();
      
      regenCounter = 0;
      ammo = maxAmmo;
      lives = maxLives;
      score = 0;
      mothershipCount = 0;
      
      newGame = false;
    }
  
    regenCounter++;
    if ((regenCounter % regenRate == 0) && (ammo < maxAmmo)) {
      ammo++;
    } else if (regenCounter % regenRate == 0) {
      regenCounter = 0;
    }
  
    for (int i = 0; i < lives; i++) {
      image(livesImage, 50*i + 25, 35, 5*slipstream.shipSize, 6*slipstream.shipSize);
    }
  
    pushMatrix();
    translate(35, 100);
    for (int i = 0; i < ammo; i++) {
      image(ammoImage, 0, 35*i, 50, 25);
    }
    popMatrix();
    
    textAlign(CENTER,CENTER);
    textFont(sc2font, 32);
    //textSize(24);
    text("SCORE: " + score, width - 180, 25);
  
    //RENDERING
  
    slipstream.update();
    slipstream.edgeCheck();
    slipstream.render();
  
    if (slipstream.checkMotherCollision(motherships)) {
      largeExplode.trigger();
      lives--;
      mothershipCount--;
    }
  
    if (slipstream.checkChildCollision(smallships)) {
      smallExplode.trigger();
      lives--;
    }
  
    if (slipstream.checkLaserCollision(enemyLasers)) {
      smallExplode.trigger();
      lives--;
    }
    
    if (lives <= 0) {
      gameState = 0;
    }

    if (mothershipCount < 5) {
      motherships.add(new EnemyMothership());
      mothershipCount++;
    }
  
    for (EnemyMothership mothership : motherships) {
      mothership.update();
      mothership.edgeCheck();
      mothership.render();
    }
  
    for (EnemyShip banshee : smallships) {
      banshee.edgeCheck();
      banshee.render();
      banshee.fireCounter++;
      if (banshee.fireCounter % banshee.fireDelay == 0) {
        enemyFire(banshee.pos);
        laserSound.trigger();
        banshee.fireCounter = 0;
      }
    }
  
    for (i = enemyLasers.size()-1; i >= 0; i--) {
      EnemyProjectile laser = enemyLasers.get(i);
      laser.edgeCheck();
      laser.render();
    }
  
    for (i = playerLasers.size()-1; i >= 0; i--) {
      Projectile laser = playerLasers.get(i);
      laser.edgeCheck();
      laser.render();
      if (laser.checkMotherCollision(motherships)) {
        playerLasers.remove(laser);
        mothershipCount--;
        largeExplode.trigger();
        score += 10;
      }
      if (laser.checkChildCollision(smallships)) {
        playerLasers.remove(laser);
        smallExplode.trigger();
        score += 30;
      }
    }
  }
  
  //play mode death
  else if (gameState == 0) {
    background(bgSpaceFaded);
    image(gameOver, width/2, 170, 644, 90);
    
    textFont(sc2font, 32);
    textAlign(CENTER,CENTER);
    textSize(72);
    text("YOUR SCORE: " + score, width/2, 300);
    textSize(32);
    text("Save to leaderboards?", width/2, 500);
    //text("Y/N", width/2, 550);
    
    image(btnYes, width/2, height - 200, btnWidth, btnHeight);
    if (mouseOnYes()) {
      image(btnYesActive, width/2, height - 200, btnWidth, btnHeight);
    }
    
    image(btnNo, width/2, height - 190 + btnHeight, btnWidth, btnHeight);
    if (mouseOnNo()) {
      image(btnNoActive, width/2, height - 190 + btnHeight, btnWidth, btnHeight);
    }
  }
  
  //username input mode
  else if (gameState == -2) {
    background(bgSpace);
    textFont(sc2font, 32);
    textAlign(CENTER,CENTER);
    text("Enter username:", width/2, height/2);
    text(username, width/2, height/2+42);
  }
  
  //rankings mode
  else if (gameState == 2) {
    background(bgSpace);
    image(top10, width/2, 150);
    
    textFont(sc2font, 24);
    textAlign(LEFT,CENTER);
    
    for (TableRow row : leaderboard.rows()) {
      int place = row.getInt("placement");
      String name = row.getString("name");
      int score = row.getInt("score");
      
      text(place + ". " + name + "  " + score, width/2 - 180, 200 + 34 * place);
    }
    
    image(btnBack, width/2, height - 100);
    if (mouseOnBack()) {
      image(btnBackActive, width/2, height - 100);
    }
  }
}


//KEY AND MOUSE CONTROLS GROUP

void keyPressed() {
  //play mode
  if (gameState == 1) {
    if (key == 'w' || keyCode == UP) {
      upPressed = true;
    }
    if (key == 's' || keyCode == DOWN) {
      downPressed = true;
    }
    if (key == 'a' || keyCode == LEFT) {
      leftPressed = true;
    }
    if (key == 'd' || keyCode == RIGHT) {
      rightPressed = true;
    }
    
    if (keyCode == SHIFT) {
      gameState = -1;
      combatMusic.pause();
      combatMusic.rewind();
    }
  }
  
  //username input mode
  else if (gameState == -2) {
    if (keyCode == BACKSPACE && username.length() > 0) {
      username = username.substring(0, username.length() - 1);
    }
    else if (keyCode == ENTER) {
      clickUI.trigger();
      gameState = -1;
      combatMusic.pause();
      combatMusic.rewind();
      
      leaderboard.setColumnType("score", Table.INT);
      TableRow newRow = leaderboard.addRow();
      newRow.setString("name", username);
      newRow.setInt("score", score);
      
      leaderboard.sortReverse(2);
      while (leaderboard.getRowCount() > 10) {
        leaderboard.removeRow(leaderboard.lastRowIndex());
      }
      
      int newPlace = 1;
      for (TableRow row : leaderboard.rows()) {
        row.setInt("placement", newPlace);
        newPlace++;
      }
      
      saveTable(leaderboard, "leaderboard.csv");
    }
    else if (username.length() <= 16 && keyCode != BACKSPACE) {
      username += key;
    }
  }
}

void keyReleased() {
  //play mode
  if (gameState == 1) {
    if (key == 'w' || keyCode == UP) {
      upPressed = false;
      slipstream.accel = new PVector(0, 0);
    }
    if (key == 's' || keyCode == DOWN) {
      downPressed = false;
      slipstream.accel = new PVector(0, 0);
    }
    if (key == 'a' || keyCode == LEFT) {
      leftPressed = false;
      slipstream.accel = new PVector(0, 0);
    }
    if (key == 'd' || keyCode == RIGHT) {
      rightPressed = false;
      slipstream.accel = new PVector(0, 0);
    }
  }
}

void mousePressed() {
  //menu mode
  if (gameState == -1) {
    if (mouseOnPlay()) {
      clickUI.trigger();
      newGame = true;
      menuMusic.pause();
      menuMusic.rewind();
      gameState = 1;
    }
    else if (mouseOnLeaderboards()) {
      clickUI.trigger();
      gameState = 2;
    }
    else if (mouseOnQuit()) {
      clickUI.trigger();
      exit();
    }
  }
  
  //play mode
  else if (gameState == 1) {
    if (ammo > 0) {
      playerFire();
      laserSound.trigger();
      ammo--;
    }
  }
  
  //play mode death
  else if (gameState == 0) {
    if (mouseOnYes()) {
      clickUI.trigger();
      gameState = -2;
      username = "";
    }
    else if (mouseOnNo()) {
      clickUI.trigger();
      gameState = -1;
      combatMusic.pause();
      combatMusic.rewind();
    }
  }
  
  //rankings mode
  else if (gameState == 2) {
    if (mouseOnBack()) {
      clickUI.trigger();
      gameState = -1;
    }
  }
}