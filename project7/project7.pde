import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;

int currentImage = 1;

boolean imageMoving;
PImage image1;
PImage image2;
PImage image3;

ScalableImage sci;


void setup(){
	size(640, 480);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();

	imageMoving = true;

	image1 = loadImage("image1.jpg");
	image2 = loadImage("image2.jpg");
	image3 = loadImage("image3.jpg");


}

void draw(){
	background(0);

	closestValue = 8000;
	kinect.update();

	int[] depthValues = kinect.depthMap();

	for (int y = 0; y<480; y++){
		// 列の中のピクセルをひとつひとつ見ていき
		for (int x = 0; x<640; x++){
			int reversedX = 640 -x-1;
			int i = reversedX + y * 640;
			int currentDepthValue = depthValues[i];

			// そのピクセルが今まで見た中で最も近いものであれば
			if(currentDepthValue > 610 && currentDepthValue < closestValue && currentDepthValue<1525){
				//その値を保存し
				closestValue = currentDepthValue;
				//　その位置(X座標とY座標)とする．
				closestX = x;
				closestY = y;
			}
		}
	}

	float interpolatedX = lerp(lastX, closestX, 0.3f);
	float interpolatedY = lerp(lastY, closestY, 0.3f);

	sci = new ScalableImage();
	sci.contorolImage(interpolatedX,interpolatedY);

	lastX = interpolatedX;
	lastY = interpolatedY;
}


void mousePressed(){
	currentImage++;
	if (currentImage>3){
		currentImage = 1;
	}
	println("currentImage: "+currentImage);
}

void keyPressed(){
	saveFrame("image.png");
}

class ScalableImage{
	float image1X = 0;
	float image1Y = 0;
	
	float image1Scale = 1;
	int image1width = 100;
	int image1height = 100;
	
	float image2X = 320;
	float image2Y = 0;
	
	float image2Scale = 1;
	int image2width = 100;
	int image2height = 100;
	
	float image3X = 0;
	float image3Y = 240;
	
	float image3Scale = 1;
	int image3width = 100;
	int image3height = 100;

	void contorolImage(float interpolatedX,float interpolatedY){
	
	switch (currentImage){
		case 1:

			image1X =interpolatedX;
			image1Y =interpolatedY;

			image1Scale = map(closestValue,610,1525,0,4);
		break;

		case 2:
			image2X = interpolatedX;
			image2Y = interpolatedY;

			image2Scale =  map(closestValue, 610, 1525, 0, 4);
		break;

		case 3:
			image3X = interpolatedX;
			image3Y = interpolatedY;

			image3Scale =  map(closestValue, 610, 1525, 0, 4);
		break;
		
	}

	image(image1, image1X, image1Y, image1width*image1Scale, image1height*image1Scale);
	image(image2, image2X, image2Y, image2width*image2Scale, image2height*image2Scale);
	image(image3, image3X, image3Y, image3width*image3Scale, image3height*image3Scale);
	
	}


}