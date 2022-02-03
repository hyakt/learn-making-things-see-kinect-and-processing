import SimpleOpenNI.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
AudioPlayer player2;

SkeletonPoser pose;
SkeletonPoser pose2;
SimpleOpenNI kinect;

void setup(){
	size(640, 480);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
	kinect.setMirror(true);

	minim = new Minim(this);

	player = minim.loadFile("hogehoge.wav");
	player2 = minim.loadFile("hogehoge2.wav");

	pose = new SkeletonPoser(kinect);
	pose2 = new SkeletonPoser(kinect);

// position
	// rules for the right arm
	pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.ABOVE, SimpleOpenNI.SKEL_RIGHT_ELBOW);
	pose.addRule(SimpleOpenNI.SKEL_RIGHT_HAND, PoseRule.RIGHT_OF, SimpleOpenNI.SKEL_RIGHT_ELBOW);

	pose2.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.ABOVE, SimpleOpenNI.SKEL_LEFT_ELBOW);
	pose2.addRule(SimpleOpenNI.SKEL_LEFT_HAND, PoseRule.LEFT_OF, SimpleOpenNI.SKEL_LEFT_ELBOW);

	strokeWeight(5);

}

void draw(){
	background(0);
	kinect.update();

	image(kinect.depthImage(), 0, 0);


	IntVector userList = new IntVector();
	kinect.getUsers(userList);

	if (userList.size() > 0){
		int userId = userList.get(0);

		if (kinect.isTrackingSkeleton(userId)){
			
			if (pose.check(userId)){
				stroke(255);

				if (!player.isPlaying()){
					player.play();
				}

	
			}else{
				stroke(255, 0, 0);
				player.rewind();
    			player.pause();
			}

			if (pose2.check(userId)){
				stroke(255);

				if (!player.isPlaying()){
					player2.play();
				}

	
			}else{
				stroke(255, 0, 0);
				player2.rewind();
    			player2.pause();
			}
	
			drawSkeleton(userId);
		}
	}
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

// user-tracking callbacks!
void onNewUser(int userId) {
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
