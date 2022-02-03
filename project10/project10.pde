import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

SkeletonRecorder recorder;
boolean recording = false;
float offByDistance = 0.0;

boolean tracking;

void setup(){
	size(640, 480, OPENGL);

	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
	kinect.setMirror(true);

	recorder = new SkeletonRecorder(kinect,SimpleOpenNI.SKEL_PROFILE_ALL);

	PFont font = createFont("Verdana",40);
	textFont(font);

}

void draw(){
	background(0);
	kinect.update();

	lights();
	noStroke();

	fill(255);
	text("totalFrame:" + recorder.frames.size(), 5, 50);
	text("recording:" + recording, 5, 100);
	text("currentFrame:" + recorder.currentFrame, 5, 150);

	float c = map(offByDistance, 0, 1000, 0, 255);
	fill(c, 255-c, 0);
	text("off by:" + offByDistance, 5, 200);

	translate(width/2, height/2,0);
	rotateX(radians(180));

	IntVector userList = new IntVector();
	kinect.getUsers(userList);

	if (tracking){

		int userId = userList.get(0);
		recorder.setUser(userId);

		if (kinect.isTrackingSkeleton(userId)){
			PVector currentPosition = new PVector();
			kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,currentPosition);

			pushMatrix();
				fill(255, 0, 0);
				translate(currentPosition.x, currentPosition.y, currentPosition.z);
				sphere(80);
			popMatrix();

			if (recording){
				recorder.recordFrame();
			}else{
				PVector recordedPosition = recorder.getPosition();

				pushMatrix();
					fill(0, 255, 0);
					translate(recordedPosition.x, recordedPosition.y, recordedPosition.z);
					sphere(80);
				popMatrix();

				stroke(c,255-c,0);
				strokeWeight(20);
				line(currentPosition.x, currentPosition.y, currentPosition.z, recordedPosition.x, recordedPosition.y, recordedPosition.z);

				currentPosition.sub(recordedPosition);

				offByDistance = currentPosition.mag();

				recorder.nextFrame();
			}
		}
	}
}

void keyPressed(){
	recording = false;
}

void onNewUser(int userId){
	tracking = true;
	println("Detection Posing");
	kinect.startPoseDetection("Psi",userId);
}

void onEndCalibration(int userId,boolean successful){
	if (successful){
		println("onEndCalibration");
		kinect.startTrackingSkeleton(userId);
		recording = true;
	}else  {
		println("Miss Calibration");
		kinect.startPoseDetection("Psi",userId);
	}
}

void onStartPose(String pose,int userId){
	println("Start Posing");
	kinect.stopPoseDetection(userId);
	kinect.requestCalibrationSkeleton(userId,true);
}