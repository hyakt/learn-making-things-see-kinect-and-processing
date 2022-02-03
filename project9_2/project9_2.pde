import processing.opengl.*;
import SimpleOpenNI.*;
import saito.objloader.*;
import peasy.*;

PeasyCam cam;
SimpleOpenNI kinect;
OBJModel model;

void setup(){
	size(1024, 768, OPENGL);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();

	model = new OBJModel(this,"kinect.obj","relative",TRIANGLE);
	model.translateToCenter();
	noStroke();

	cam = new PeasyCam(this,0,0,0,1000);
}

void draw(){
	background(0);
	kinect.update();

	rotateX(radians(180));

	lights();
	noStroke();

	pushMatrix();
		rotateX(radians(-90));
		rotateZ(radians(180));
		model.draw();
	popMatrix();

	stroke(255);

	PVector[] depthPoints = kinect.depthMapRealWorld();

	for (int i = 0; i<depthPoints.length; i+=10){
		PVector currentPoint = depthPoints[i];
		point(currentPoint.x, currentPoint.y, currentPoint.z);
	}

}