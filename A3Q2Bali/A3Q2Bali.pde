// Jaivir Bali (7775370)
// A3Q2
float eyeX = 1, eyeY = 2, eyeZ = 0, centerX = 0, centerY = 1, centerZ = -2, upX = 0, upY = 1, upZ = 0;
boolean perspective = true;  //toggle between perspective 1 and 2
int positionCount = 0;


void setup() {
  size(640, 640, P3D);
  hint(DISABLE_OPTIMIZED_STROKE);
}

void draw() {
  clear();
  resetMatrix();
  if(perspective){
    ortho(-1, 1, 1, -1, 1, 6);
  }else{
    frustum(-1, 1, 1, -1, 1, 6);
  }
  
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ); //set the camera position
  
  translate(0, 0, -2.5); //move everything back so its viewable
  strokeWeight(1.0);
  beginShape(LINES);
  stroke(255,0,0);  //x
  vertex(-2,0,0);
  vertex(2,0,0);
  stroke(0,255,0);  //y
  vertex(0,-2,0);
  vertex(0,2,0);
  stroke(0,0,255);  //z
  vertex(0,0,-2);
  vertex(0,0,2);
  endShape();

  
  stroke(255);
  scale(0.2,0.2,0.2); //set the scene size
   
  fill(255);  //origin
  sphere(0.1);
  
  //drawing stuff now
  pushMatrix();
  strokeWeight(2.5);
  
  fill(60);
  translate(-3.3,-0.25,-3.3);
  box(5,0.5,8);  //table

  
  popMatrix();
  
  
  
  
  
  
} //<>//


void keyPressed() {
  switch(key) {
    case 'o':      //default perspective
      perspective = true;
      break;
    case 'p':
      perspective = false;
      break;
    case ' ':
      positionCount++;
      positionCount = positionCount % 6;  //want to keep in range between 0-5
      
      if (positionCount < 3) {    //determine perspective
        perspective = true;
      } else {
        perspective = false;
      };
      
      if (positionCount % 3 == 0) {        //determine view
        setView0();
      } else if (positionCount % 3 == 1) {
        setView1();
      } else if (positionCount % 3 == 2) {
        setView2();
      }
      
      break;
    case 'j':    //default view
      setView0();
      break;
    case 'k':    
      setView1();
      break;
    case 'l':
      setView2();
      break;
  } //end switch statement
} //end keypressed function

void setView0() {
  eyeX = 1;
  eyeY = 2;
  eyeZ = 0;
  centerX = 0;
  centerY = 1;
  centerZ = -2;
  upX = 0; 
  upY = 1;
  upZ = 0;
}

void setView1() {
  eyeX = -2;
  eyeY = 2;
  eyeZ = 0;
  centerX = -1;
  centerY = 1;
  centerZ = -2;
  upX = 0; 
  upY = 1;
  upZ = 0;
}

void setView2() {
  eyeX = 1;
  eyeY = 2;
  eyeZ = 0;
  centerX = 0;
  centerY = 1;
  centerZ = -2;
  upX = 0; 
  upY = 1;
  upZ = 1;
}
