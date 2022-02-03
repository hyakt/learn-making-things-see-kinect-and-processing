import processing.opengl.*;
import saito.objloader.*;

OBJModel model;
float rotateX;
float rotateY;

void setup(){
	size(640, 480, OPENGL);

	model = new OBJModel(this, "kinect.obj","relative",TRIANGLE);

	model.translateToCenter();
	noStroke();

}

void draw(){
	background(255);

	lights();

	translate(width/2, height/2, 0);

	rotateX(rotateY);
	rotateY(rotateX);

	model.draw();
}

void mouseDragged(){
	rotateX += (mouseX - pmouseX) * 0.01;
	rotateY += (mouseY - pmouseY) * 0.01;

}

boolean drawLines = false;

void keyPressed(){
	if(drawLines){
		model.shapeMode(LINES);
		stroke(0);
	}else{
		model.shapeMode(TRIANGLE);
		noStroke();
	}
	drawLines = !drawLines;
}