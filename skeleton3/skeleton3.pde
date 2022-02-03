import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup(){
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);

	size(640, 480);
	stroke(255, 0, 0);
	strokeWeight(5);
	textSize(20);

	background(255);
}

void draw(){
	kinect.update();
	// image(kinect.depthImage(), 0, 0);

	IntVector userList = new IntVector();
	kinect.getUsers(userList);

	if (userList.size() > 0){
		int userId = userList.get(0);

		if (kinect.isTrackingSkeleton(userId)){
			PVector leftHand = new PVector();
			PVector rightHand = new PVector();

			kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
			kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);

			PVector differenceVector = PVector.sub(leftHand,rightHand);

			float magnitude  = differenceVector.mag();
			differenceVector.normalize();


			stroke(abs(differenceVector.x) * 255, abs(differenceVector.y) * 255, abs(differenceVector.z) * 255);
			
			strokeWeight(map(magnitude,100,1200,1,8));

			kinect.drawLimb(userId,SimpleOpenNI.SKEL_LEFT_HAND,SimpleOpenNI.SKEL_RIGHT_HAND);



		}
	}
}

void onNewUser(int userId){
	println("detect pose");
	kinect.startPoseDetection("Psi",userId);
}

void onEndCalibration(int userId, boolean successful){
	if (successful){
		println(" complete calibration");
		kinect.startTrackingSkeleton(userId);
	}
	else{
		println(" miss calibration");
		kinect.startPoseDetection("Psi",userId);
	}
}

void onStartPose(String pose, int userId){
	println("start pose");
	kinect.stopPoseDetection(userId);
	kinect.requestCalibrationSkeleton(userId,true);
}


