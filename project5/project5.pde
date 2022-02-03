import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
/*
int closestX;
int closestY;
*/

float closestX;
float closestY;

int[] recentXValues = new int[3];
int[] recentYValues = new int[3];

int currentIndex = 0;

void setup(){
	size(640, 480);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
}

void draw(){
	closestValue = 8000;
	kinect.update();

	int[] depthValues = kinect.depthMap();

	for (int y = 0; y<480; y++){
		// 列の中のピクセルをひとつひとつ見ていき
		for (int x = 0; x<640; x++){
			int i = x + y * 640;
			int currentDepthValue = depthValues[i];

			// そのピクセルが今まで見た中で最も近いものであれば
			if(currentDepthValue > 0 && currentDepthValue < closestValue){
				//その値を保存し
				closestValue = currentDepthValue;
				//　その位置(X座標とY座標)とする．
				//closestX = x;
				//closestY = y;
				recentXValues[currentIndex] = x;
				recentYValues[currentIndex] = y;
			}
		}
	}

	currentIndex++;
	if(currentIndex > 2){
		currentIndex = 0;
	}

	closestX = (recentXValues[0]  + recentXValues[1]+ recentXValues[2])/3;
	closestY = (recentYValues[0] +  recentYValues[1] + recentYValues[2])/3;

	image(kinect.depthImage(), 0, 0);

	fill(255, 0, 0);
	ellipse(closestX, closestY, 25, 25);
}