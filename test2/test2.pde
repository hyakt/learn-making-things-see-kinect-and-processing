import processing.opengl.*;
import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI kinect;

Minim minim;
AudioPlayer player;

SkeletonPoser pose;

int[] userMap;

boolean tracking = false;
boolean firstDance = true;

PImage backgroundImage;
PImage dancingImage;

PImage userImage;

void setup(){
	size(640, 480, OPENGL);

	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();

	kinect.enableRGB();
	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

	kinect.setMirror(true);

	minim = new Minim(this);
	player = minim.loadFile("choochootrain.wav");

	pose = new SkeletonPoser(kinect);
	// pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_ELBOW);
	// pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_RIGHT_ELBOW);

	pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_LEFT_HIP);
	pose.addRule(SimpleOpenNI.SKEL_LEFT_FOOT, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_HIP);

	pose.addRule(SimpleOpenNI.SKEL_RIGHT_FOOT, PoseRule.BELOW, SimpleOpenNI.SKEL_RIGHT_HIP);
	pose.addRule(SimpleOpenNI.SKEL_RIGHT_FOOT, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_HIP);

	kinect.alternativeViewPointDepthToImage();

	backgroundImage = loadImage("exile.jpg");
	backgroundImage.resize(640,480);

	dancingImage = loadImage("exile2.jpg");
	dancingImage.resize(640,480);

	image(backgroundImage, 0, 0);

}

void draw(){

	kinect.update();

	IntVector userList = new IntVector();
	kinect.getUsers(userList);

	if (userList.size() > 0){

		int userId = userList.get(0);

		if (kinect.isTrackingSkeleton(userId)){
			
			if (pose.check(userId)){
				choochooTrain();
			}else{
				stroke(255, 0, 0);
				player.pause();
				image(backgroundImage, 0, 0);
				firstDance = true;
				drawSkeleton(userId);
			}

		}
	}
}

void choochooTrain(){
	stroke(255);
	
	if(firstDance)image(dancingImage, 0, 0);

	PImage rgbImage = kinect.rgbImage();
	rgbImage.loadPixels();

	loadPixels();

		userMap  = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);

		for (int i = 0; i<userMap.length; i++){
			if(userMap[i] != 0){
				pixels[i] = rgbImage.pixels[i];
			}
		}  

		if (!player.isPlaying()){
			player.loop();
		}

	updatePixels();

	delay(200);

	firstDance = false;
}

void drawSkeleton(int userId){
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
	kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);
}

void mousePressed(){
	save("image.png");
}

// user-tracking callbacks!
void onNewUser(int userId) {
  tracking = true;
  println("Start pose detection");
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
