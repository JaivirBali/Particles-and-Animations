// Jaivir Bali (7775370)
// A3Q2
float eyeX = 1, eyeY = 2, eyeZ = 0, centerX = 0, centerY = 1, centerZ = -2, upX = 0, upY = 1, upZ = 0;
boolean perspective = true;  //toggle between perspective 1 and 2
int positionCount = 0;
int currKey = 0;

float[][] keys = {
  { -2,0.25,-2, 0, 0, -PI/2, 0, 0 },    //***special middle of table (half height of base move up)
  { -1,0.25,1, PI/4, PI/3, (-2*PI)/3, PI/4, PI/4 },     //***special bottom right edge of table
  { -3,0.25,1, 0, 0, -PI/2, 0, 0 },     //***special bottom left edge of table
  { -1,0.25,-5, 0, 0, -PI/2, 0, 0 },    //***special top right edge of table
  { -3,0.25,-5, 0, 0, -PI/2, 0, 0 },    //***special top left edge of table
};


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
  float tableWidth = 4.0;
  float tableHeight = 0.5;
  float tableLength = 8.0;
  
  translate(keys[0][0], keys[0][1] - tableHeight, keys[0][2]);  //static middle location

  box(tableWidth, tableHeight, tableLength);  //table
  
  popMatrix();  //end table
 
  //BASE
  pushMatrix();  //start base
  fill(0,0,200);
  
  translate(keys[currKey][0], keys[currKey][1], keys[currKey][2]);
  
  float baseAngle = keys[currKey][3];
  rotateY(baseAngle);  //do Y axis rotation for base (***special default of 0) --> -PI (CW) to +PI (CCW)

  float baseWidth = 2.0;
  float baseHeight = 0.5;
  float baseLength = 2.0;
  box(baseWidth, baseHeight, baseLength);  //base
  
  //LOWER ARM
  pushMatrix();  //start lower arm
  fill(50,160,160);
  
  float lowerArmAngle = keys[currKey][4];
  rotateZ(lowerArmAngle);  //do Z axis rotation for lower arm (*** special default of 0) --> PI/3 (back) to -PI/3 (front)
  
  float lowerArmWidth = 0.5;
  float lowerArmHeight = 2.5;
  float lowerArmLength = 0.5;
  translate(0, (0.5*lowerArmHeight)+(0.5*baseHeight),0);  //half height of lower arm + another half height offset for base
  box(lowerArmWidth, lowerArmHeight, lowerArmLength);  //lower arm
  
  
  //ARM JOINT
  pushMatrix();  //start arm joint
  fill(15,120,75);
  
  translate(0, (0.5*lowerArmHeight), 0);  //just offset half height of lower arm (want cube to be centered at middle of joint)
  float upperArmAngle = keys[currKey][5];
  rotateZ(upperArmAngle); //do Z axis rotation for arm joint (***special start with default of -PI/2 to face right)
                          //--> 0 (vertical) to -PI/2 (perpendicular)
  float armJointLength = 0.75;
  box(armJointLength, armJointLength, armJointLength);  //arm joint
  
  
  //UPPER ARM
  pushMatrix();  //start upper arm
  fill(160,50,160);
  
  float upperArmWidth = 0.25;
  float upperArmLength = 2.0;
  float upperArmHeight = 0.25;
  translate(0, (0.5*upperArmLength), 0);  //just offset half height of upper arm (still want cube to be centered at middle of joint)
  box(upperArmWidth, upperArmLength, upperArmHeight);  //upper arm
  
  
  //HEAD JOINT
  pushMatrix();  //start head joint
  fill(220,220,0);
    
  translate(0, (0.5*upperArmLength), 0);   //just offset half height of upper arm (want cube to be centered at middle of joint)
  float headJointAngle = keys[currKey][6];
  rotateY(headJointAngle);  //do Y axis rotation for the head joint (***special default of 0 to face down)
                            //--> -PI (CW) to +PI (CCW)
  float headJointLength = 0.50;
  box(headJointLength, headJointLength, headJointLength);  //head joint
  
  
  //HEAD
  pushMatrix();  //start head
  fill (200,0,0);
  
  float headLength = 0.625;
  translate((0.5*headJointLength)+(0.5*headLength), 0, 0);
  float headAngle = keys[currKey][7];
  rotateX(headAngle);  //do X axis rotation for the head itself (***special default of 0) --> -PI/4 to +PI/4 (doesn't matter)
  box(headLength, headLength, headLength);  //head joint
  
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
    case '1':
      currKey = 0;
      break;
    case '2':
      currKey = 1;
      break;
    case '3':
      currKey = 2;
      break;
    case '4':
      currKey = 3;
      break;
    case '5':
      currKey = 4;
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
