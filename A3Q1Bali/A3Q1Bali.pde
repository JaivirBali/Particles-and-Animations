// Jaivir Bali (7775370)
// A3Q1

float x, y;
ArrayList<Rocket> rockets;

float[][] keys = {
  { -0.9, -0.9 },
  { -0.45,-0.9 },
  { 0, -0.9 },
  { 0.45,-0.9 },
  { 0.9,-0.9 }
};

float triX1 = -0.1;
float triX2 = 0.0;
float triX3 = 0.1;
float triY1 = -0.1;
float triY2 = 0.1;
float triY3 = -0.1;

void setup() {
  size(640, 640, P3D);
  ortho(-1, 1, 1, -1);
  resetMatrix();
  
  rockets = new ArrayList<Rocket>();
  Rocket newRocket = new Rocket (keys[0][0], keys[0][1],  0, 0, 200, 0);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[1][0], keys[1][1],  0, 200, 200, 1);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[2][0], keys[2][1],  0, 200, 0, 2);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[3][0], keys[3][1],  200, 200, 0, 3);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[4][0], keys[4][1],  200, 0, 0, 4);
  rockets.add(newRocket);
}

void draw() {
  background(0);
 
  for (int i = 0; i < rockets.size(); i++){
    Rocket currRocket = rockets.get(i);
    currRocket.drawRocket();
  }
}

class Rocket {
  float xOffset, yOffset;
  float testPosX, testPosY;
  
  float r,g,b;
  int rocketNum;
  
  boolean isMoving;
  float slope, angle;
  
  float t;
  float tmod;
  int t0time;
  
  ParticleSystem ps;
  
  Rocket (float xOffset, float yOffset, float r, float g, float b, int rocketNum) {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    
    this.r = r;
    this.b = b;
    this.g = g;
    this.rocketNum = rocketNum;
    
    testPosX = xOffset;
    testPosY = yOffset;
    slope = 0;
    angle = PI/2;
    isMoving = false;
    
    t = 0;
  }
  
  void drawRocket() {
    pushMatrix();  //firework 1
    fill(r, g, b);
    
    tmod = sin(t * PI/2);  //ease-out for deceleration
    
    if (isMoving) {
      slope = (testPosY-yOffset)/(testPosX-xOffset);
      angle = atan(slope);
            
      if (angle < 0){
        angle += PI;  //want in quadrant 2, not quadrant 4
      }
    } 
    
    if (currDragging && rocketNum == selectedRocket) {
      x = 2.0 * mouseX / width - 1;
      y = 2.0 * (height-mouseY+1) / height - 1;
      
      angle = atan((y-yOffset)/(x-xOffset));
      if (angle < 0){
        angle += PI;  //want in quadrant 2, not quadrant 4
      }
      
      //println("ANGLE DRAG " + angle);
    } else {
      x = lerp(xOffset, testPosX, tmod);
      y = lerp(yOffset, testPosY, tmod);
    }
    
    //println(degrees(angle));
    //println(slope);
    
    translate(x, y);
    rotate(angle-PI/2);  //do in RADIANS
    
    if (isMoving) {
      scale(1.0-t);
    }
    
    triangle(triX1, triY1, triX2, triY2, triX3, triY3);
    popMatrix();   //end firework 1
    
    boolean isEarly = false;
    //Automatically explode if out of bounds for X axis
    if (x <= -1 || x >= 1) {
      t = 1;
      testPosX = x;
      testPosY = y;
      isEarly = true;
    }
    
    //Automatically explode if out of bounds for Y axis at top only
    if (y >= 1) {
      t = 1;
      testPosX = x;
      testPosY = y;
      isEarly = true;
    }
    
    //decide when to stop and reset
    if (isMoving) {
      if (t >= 1) {
        t = 1;
        isMoving = false;
        
        ps = new ParticleSystem(testPosX, testPosY, isEarly);
     
        resetRocket();
      } else {
        t = (millis() - t0time + 1000) / 2000.0 / 4 ;  //only want proportional to time, starting at 1/2 completed
      }
    }
    
    //draw particle system
    if (ps != null) {
      if (ps.doneAnimating == false) {
        ps.addParticle();
        ps.run();
      } else {
        ps = null;
      }
    }
    
  }
  
  void resetRocket() {
    angle = PI/2;
    slope = 0;
    t = 0;
    testPosX = xOffset;
    testPosY = yOffset;
    //ps = null;
  }
  
  void setMovement(float newX, float newY, float dragTime) {
    isMoving = true;
    
    float dx = newX-xOffset;
    float dy = newY-yOffset;
    slope = dy/dx;
    angle = atan(slope);
    t0time = millis();
    
    float velocityX = (dx/dragTime)*1000.0;
    float velocityY = (dy/dragTime)*1000.0;
    
    //println("X velocity: " + velocityX + ", Y velocity: " + velocityY); 
    testPosX = newX + (1.0*velocityX);
    testPosY = newY + (1.0*velocityY);
  }
}

int selectedRocket;
boolean rocketSelected = false;
float dragTime = 0;
boolean currDragging = false;

void mousePressed() {
  float mousePosX = 2.0 * mouseX / width - 1;
  float mousePosY = 2.0 * (height-mouseY+1) / height - 1;
  
  for (int i = rockets.size() - 1; i >= 0; i--) {
    Rocket checkRocket = rockets.get(i);
    float totalDistance = dist(mousePosX, mousePosY, checkRocket.xOffset, checkRocket.yOffset);
    if (totalDistance <= 0.1) {
      selectedRocket = i;
      break;
    }
  }
  
  if (selectedRocket >= 0) {
    rocketSelected = true;
    dragTime = millis();
  }
  
  //println("X: " + mousePosX + ", Y = " + mousePosY);
  println("Chosen rocket: " + selectedRocket);
}

void mouseDragged() {
  if (rocketSelected) {
    currDragging = true;
    redraw();
  }
}

void mouseReleased() {
  if (rocketSelected && currDragging) {
    currDragging = false;
    float mousePosX = 2.0 * mouseX / width - 1;
    float mousePosY = 2.0 * (height-mouseY+1) / height - 1;
    
    dragTime = millis() - dragTime;
    
    //println("XR: " + mousePosX + ", YR = " + mousePosY);
    println("Drag Time: " + dragTime);
    
    rockets.get(selectedRocket).setMovement(mousePosX, mousePosY, dragTime);
    
    rocketSelected = false;   //rocket will blow up, no longer want it selected
    selectedRocket = -1;    
  }
}


class ParticleSystem {
  ArrayList<Spark> sparks;
  float originX;
  float originY;
  float startTime;
  boolean doneAnimating = false;
  float particleTime = 2000.0;
  float totalTime = 4000.0;
  boolean isEarly = false;

  ParticleSystem(float originX, float originY, boolean isEarly) {
    this.originX = originX;
    this.originY = originY;
    sparks = new ArrayList<Spark>();
    startTime = millis();
    this.isEarly = isEarly;
  }

  void addParticle() {
    if (millis() - startTime < particleTime) {
      sparks.add(new Spark(originX, originY, isEarly));
    }
  }

  void run() {
    if (millis() - startTime < totalTime) {
      for (int i = sparks.size()-1; i >= 0; i--) {
        Spark p = sparks.get(i);
        p.run();
        if (p.isDead()) {
          sparks.remove(i);
        }
      }
    } else {
      doneAnimating = true;
    }
  }
}

class Spark {
  float positionX;
  float positionY;
  float velocityX;
  float velocityY;
  float gravity;
  float lifespan;
  boolean onlyWhite;

  Spark(float originX, float originY, boolean onlyWhite) {
    positionX = originX;
    positionY = originY;
    gravity = -0.0009;
    velocityX = random(-0.0075, 0.0075);
    velocityY = random(0, 0.02);
    lifespan = 255.0;
    this.onlyWhite = onlyWhite;
  }

  void run() {
    update();
    display();
  }

  //update position
  void update() {
    velocityY += gravity;
    positionX += velocityX;
    positionY += velocityY;
    lifespan -= 2.5;
  }

  //draw spark
  void display() {
    float r, g, b;
    
    if (onlyWhite) {
      r = g = b = 255;
    } else {
      r = random(0,256);
      g = random(0,256);
      b = random(0,256);
    }
    stroke(0, lifespan);
    fill(r, g, b, lifespan);
    rect(positionX, positionY, 0.0125, 0.025);
  }

  //determine if spark should keep being drawn
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
