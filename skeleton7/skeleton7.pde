import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

PImage userImage;
int userID;
int[] userMap;

PImage rgbImage;

void setup(){
	size(640, 480, OPENGL);

	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);

}

void draw(){
	background(0);
	kinect.update();

	if (kinect.getNumberOfUsers() > 0){
		userMap  = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);

		loadPixels();

		for (int i = 0; i<userMap.length; i++){
			if(userMap[i] != 0){
				pixels[i] = color(0,255,0);
			}
		}
		updatePixels();
	}
}

void onNewUser(int uID){
	userID = uID;
	boolean tracking = true;
	print("Tracking Now!");
}