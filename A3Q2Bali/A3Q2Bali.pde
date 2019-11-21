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
  
  //Axis for testing purposes
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
   
   //Origin for testing purposes
  fill(255);  //origin
  sphere(0.1);
  
  
  //Drawing stuff now
  pushMatrix();  //start scene
  strokeWeight(2.5);
 
  //TABLE
  pushMatrix();  //start table
  fill(60);
  translate(-2,-0.25,-2);
  box(4,0.5,8);  //table
  popMatrix();  //end table
 
  //BASE
  pushMatrix();  //start base
  fill(0,0,200);
  
  //translate(-1,0.25,1);    //***special bottom right edge of table
  //translate(-3,0.25,1);    //***special bottom left edge of table
  translate(-2,0.25,-2);    //***special middle of table (half height of base move up)
  //translate(-1,0.25,-5);    //***special top right edge of table
  //translate(-3,0.25,-5);    //***special top left edge of table


  rotateY(0);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)
  box(2,0.5,2);  //base
  
  //LOWER ARM
  pushMatrix();  //start lower arm
  fill(50,160,160);
  
  rotateZ(0);  //do Z axis rotation for lower arm (*** special default of 0) --> PI/3 (back) to -PI/3 (front)
  translate(0,1.5,0);  //half height of lower arm + another half height offset for base

  box(0.5,2.5,0.5);  //lower arm
  
  
  //ARM JOINT
  pushMatrix();  //start arm joint
  fill(15,120,75);
  
  
  translate(0,1.25,0);  //just offset half height of lower arm (want cube to be centered at middle of joint)
  rotateZ(-PI/2);       //do Z axis rotation for arm joint (***special start with default of -PI/2 to face right)
                        //--> 0 (vertical) to -PI/2 (perpendicular)
  box(0.75,0.75,0.75);  //arm joint
  
  
  //UPPER ARM
  pushMatrix();  //start upper arm
  fill(160,50,160);
  translate(0,1.0,0);  //just offset half height of upper arm (still want cube to be centered at middle of joint)
  box(0.25,2.0,0.25);  //upper arm
  
  
  //HEAD JOINT
  pushMatrix();  //start head joint
  fill(220,220,0);
    
  translate(0,1.0,0);   //just offset half height of upper arm (want cube to be centered at middle of joint)
  rotateY(0);          //do Y axis rotation for the head joint (***special default of 0 to face down)
                        //--> -PI (CW) to +PI (CCW)
  box(0.50,0.50,0.50);  //head joint
  
  
  
  //HEAD
  pushMatrix();  //start head
  fill (200,0,0);
  translate(0.5625,0,0);
  rotateX(0);  //do X axis rotation for the head itself (***special default of 0) --> -PI/4 to +PI/4 (doesn't matter)
  box(0.625,0.625,0.625);  //head joint
  
  popMatrix();  //end head
  popMatrix();  //end head joint
  popMatrix();  //end upper arm
  popMatrix();  //end arm joint 
  popMatrix();  //end lower arm
  popMatrix();  //end base
  popMatrix();  //end scene stuff
  
  
  
  
  
  
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
