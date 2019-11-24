// Jaivir Bali (7775370)
// A3Q1

boolean t0 = true;
float t = 0;
float tmod;
int t0time;
float x, y;

float[][] keys = {
  { 0, -0.9 },
  { -0.9, -0.9 },
  { -0.45,-0.9 },
  { 0.45,-0.9 },
  { 0.9,-0.9 }
};

float triX1 = -0.1;
float triX2 = 0;
float triX3 = 0.1;
float triY1 = -0.1;
float triY2 = 0.1;
float triY3 = -0.1;

void setup() {
  size(640, 640, P3D);
  ortho(-1, 1, 1, -1);
  resetMatrix();
}

void draw() {
  background(0);
  
  if (t0) {
    t0time = millis();
  }
  
  pushMatrix();  //firework 1
  fill(0,0,200);
  tmod = 1 - cos(t * PI/2);
  x = lerp(keys[0][0], 0, tmod);
  y = lerp(keys[0][1], 1, tmod);
  translate(x, y);
  scale(1.0-t);
  triangle(triX1, triY1, triX2, triY2, triX3, triY3);
  popMatrix();   //end firework 1
  
  pushMatrix();  //firework 2
  fill(0,200,200);
  translate(keys[1][0], keys[1][1]);
  triangle(triX1, triY1, triX2, triY2, triX3, triY3);
  popMatrix();   //end firework 2
  
  pushMatrix();  //firework 3
  fill(0,200,0);
  translate(keys[2][0], keys[2][1]);
  triangle(triX1, triY1, triX2, triY2, triX3, triY3);
  popMatrix();   //end firework 3
  
  pushMatrix();  //firework 4
  fill(200,200,0);
  translate(keys[3][0], keys[3][1]);
  triangle(triX1, triY1, triX2, triY2, triX3, triY3);
  popMatrix();   //end firework 4
  
  pushMatrix();  //firework 5
  fill(200,0,0);
  translate(keys[4][0], keys[4][1]);
  triangle(triX1, triY1, triX2, triY2, triX3, triY3);
  popMatrix();   //end firework 5
  
  
  t = (millis() - t0time) / 2000.0 ;
  if (t > 1) {
    t0 = true;
    t = 0;
  } else {
    t0 = false;
  }
  
}

class Rocket {
  float xOffset, yOffset;
  float r,g,b;
  
  Rocket (float xOffset, float yOffset, float r, float g, float b) {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
    
    this.r = r;
    this.b = b;
    this.g = g;
  }
  
}
