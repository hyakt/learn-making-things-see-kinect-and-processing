import SimpleOpenNI.*;
SimpleOpenNI  kinect;

PImage image1;

void setup() {
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  kinect.enableRGB();
  kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

  image1 = loadImage("image1.gif");
  size(640, 480);
  fill(255, 0, 0);
}

void draw() {
  kinect.update();
  image(kinect.rgbImage(), 0,0);

  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {
    int userId = userList.get(0);

    if ( kinect.isTrackingSkeleton(userId)) {
      drawSkeleton(userId);
    }
  }
}

void drawSkeleton(int userId) {

  noStroke();
  
  fill(255,0,0);

  drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP,SimpleOpenNI.SKEL_RIGHT_HIP);    

}

void drawJoint(int userId, int jointID ,int jointID2) {
  PVector joint = new PVector();
  PVector joint2= new PVector();

  kinect.getJointPositionSkeleton(userId, jointID, joint);
  kinect.getJointPositionSkeleton(userId, jointID2, joint2);
  
  PVector convertedJoint = new PVector();
  PVector convertedJoint2 = new PVector();

  kinect.convertRealWorldToProjective(joint, convertedJoint);
  kinect.convertRealWorldToProjective(joint2, convertedJoint2);

  float imageSize = map((convertedJoint.z+convertedJoint2.z)/2, 700, 2500, 200, 1);


  image(image1,(convertedJoint.x + convertedJoint2.x)/2, (convertedJoint.y + convertedJoint2.y )/2,imageSize,imageSize);

  // ellipse((convertedJoint.x + convertedJoint2.x)/2, (convertedJoint.y + convertedJoint2.y)/2, 50 , 50);

}

// user-tracking callbacks!
void onNewUser(int userId) {
  println("start pose detection");
  kinect.startPoseDetection("Psi", userId);
}

void onEndCalibration(int userId, boolean successful) {
  if (successful) { 
    println("  User calibrated !!!");
    kinect.startTrackingSkeleton(userId);
  } 
  else { 
    println("  Failed to calibrate user !!!");
    kinect.startPoseDetection("Psi", userId);
  }
}

void onStartPose(String pose, int userId) {
  println("Started pose for user");
  kinect.stopPoseDetection(userId); 
  kinect.requestCalibrationSkeleton(userId, true);
}
