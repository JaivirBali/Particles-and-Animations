// Jaivir Bali (7775370)
// A3Q1

//boolean t0 = false;
//float t = 0;
//float tmod;
//int t0time;

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
  Rocket newRocket = new Rocket (keys[0][0], keys[0][1],  0, 0, 200);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[1][0], keys[1][1],  0, 200, 200);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[2][0], keys[2][1],  0, 200, 0);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[3][0], keys[3][1],  200, 200, 0);
  rockets.add(newRocket);
  
  newRocket = new Rocket (keys[4][0], keys[4][1],  200, 0, 0);
  rockets.add(newRocket);
  
  //Rocket testRocket = rockets.get(0);
  //testRocket.setMovement(-1, 1);
}

void draw() {
  background(0);
  
  //if (t0) {
  //  t0time = millis();
  //}
  
  for (int i = 0; i < rockets.size(); i++){
    Rocket currRocket = rockets.get(i);
    currRocket.drawRocket();
  }
  
  
  //t = (millis() - t0time) / 2000.0 ;  //only want proportional to time, don't care about distance travelled
  //if (t > 1) {
  //  t0 = true;
  //  t = 0;
  //} else {
  //  t0 = false;
  //}
  
}

class Rocket {
  float xOffset, yOffset;
  float r,g,b;
  float testPosX, testPosY;
  
  boolean isMoving;
  float slope, angle;
  
  float t;
  float tmod;
  int t0time;
  
  Rocket (float xOffset, float yOffset, float r, float g, float b) {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    
    this.r = r;
    this.b = b;
    this.g = g;
    
    testPosX = xOffset;
    testPosY = yOffset;
    slope = 0;
    angle = PI/2;
    isMoving = false;
    
    t = 0;
  }
  
  void drawRocket() {
    //testPosX = 0;
    //testPosY = 1;
    //float slope, angle;

    pushMatrix();  //firework 1
    fill(r, g, b);
    tmod = 1 - cos(t * PI/2);
    
    if (isMoving) {
      slope = (testPosY-yOffset)/(testPosX-xOffset);
      angle = atan(slope);
            
      if (angle < 0){
        angle += PI;  //want in quadrant 2, not quadrant 4
      }
    } 
    
    x = lerp(xOffset, testPosX, tmod);
    y = lerp(yOffset, testPosY, tmod);
    
    //println(degrees(angle));
    //println(slope);
    
    translate(x, y);
    rotate(angle-PI/2);  //do in RADIANS
    
    if (isMoving) {
      scale(1.0-t);
    }
    
    triangle(triX1, triY1, triX2, triY2, triX3, triY3);
    popMatrix();   //end firework 1
    
    if (isMoving) {
      if (t > 1) {
        t = 0;
        isMoving = false;
        angle = PI/2;
      } else {
        t = (millis() - t0time) / 2000.0 ;  //only want proportional to time, don't care about distance travelled
      }
    }
    
  }
  
  void setMovement(float testPosX, float testPosY) {
    this.testPosX = testPosX;
    this.testPosY = testPosY;
    isMoving = true;
    slope = (testPosY-yOffset)/(testPosX-xOffset);
    angle = atan(slope);
    t0time = millis();
  }
}

Rocket selectedRocket;
boolean rocketSelected = false;
float dragTime = 0;
boolean currDragging = false;

void mousePressed() {
  float mousePosX = 2.0 * mouseX / width - 1;
  float mousePosY = 2.0 * (height-mouseY+1) / height - 1;
  int chosenRocket = -1;
  
  for (int i = rockets.size() - 1; i >= 0; i--) {
    Rocket currRocket = rockets.get(i);
    float totalDistance = dist(mousePosX, mousePosY, currRocket.xOffset, currRocket.yOffset);
    if (totalDistance <= 0.1) {
      chosenRocket = i;
      break;
    }
  }
  
  if (chosenRocket >= 0) {
    rocketSelected = true;
    selectedRocket = rockets.get(chosenRocket);
  }
  
  println("X: " + mousePosX + ", Y = " + mousePosY);
  println("Chosen rocket: " +chosenRocket);
}

void mouseDragged() {
  if (rocketSelected) {
    currDragging = true;
    dragTime = millis();
  }
}

void mouseReleased() {
  if (rocketSelected && currDragging) {
    currDragging = false;
    float mousePosX = 2.0 * mouseX / width - 1;
    float mousePosY = 2.0 * (height-mouseY+1) / height - 1;
    
    dragTime = millis() - dragTime;
    
    println("XR: " + mousePosX + ", YR = " + mousePosY);
    println("Drag Time: " + dragTime);
    rocketSelected = false;   //rocket will blow up, no longer want it selected
  }
}
