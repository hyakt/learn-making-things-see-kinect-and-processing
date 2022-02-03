import processing.opengl.*;
import SimpleOpenNI.*;

SimpleOpenNI kinect;

boolean tracking;

PImage userImage;
int userID;
int[] userMap;

PImage backgroundImage;

void setup(){
	size(640, 480, OPENGL);

	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableRGB();

	kinect.enableUser(SimpleOpenNI.SKEL_PROFILE_NONE);

	kinect.alternativeViewPointDepthToImage();
	backgroundImage = loadImage("empire_state.jpg");

}

void draw(){
	image(backgroundImage, 0, 0);
	kinect.update();

	if (tracking){

		PImage rgbImage = kinect.rgbImage();
		rgbImage.loadPixels();

		PImage depthImage = kinect.depthImage();
		depthImage.loadPixels();

		loadPixels();

		userMap  = kinect.getUsersPixels(SimpleOpenNI.USERS_ALL);

		for (int i = 0; i<userMap.length; i++){
			if(userMap[i] != 0){
				pixels[i] = depthImage.pixels[i];
			}
		}
		updatePixels();
	}
}

void onNewUser(int uID){
	userID = uID;
	tracking = true;
	println("Tracking Now!");
}