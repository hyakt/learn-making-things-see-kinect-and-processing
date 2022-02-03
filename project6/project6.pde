import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;

float closestX;
float closestY;

float lastX;
float lastY;

float[] previousX = new float[25];
float[] previousY = new float[25];

int col = 0;
int rot = 0;
int currentIndex = 0;

void setup(){
	
	size(640, 480);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
	kinect.enableRGB();
	noStroke();
}

void draw(){

	closestValue = 8000;

	kinect.update();

	int[] depthValues = kinect.depthMap();

	for (int y = 0; y<480; y++){
		// 列の中のピクセルをひとつひとつ見ていき
		for (int x = 0; x<640; x++){

			int reversedX = 640-x-1;

			int i = reversedX + y * 640;
			int currentDepthValue = depthValues[i];

			// そのピクセルが今まで見た中で最も近いものであれば
			if(currentDepthValue > 500 && currentDepthValue < 1525 && currentDepthValue < closestValue){
				//その値を保存し
				closestValue = currentDepthValue;
				//　その位置(X座標とY座標)とする．
				closestX = x;
				closestY = y;

				println("x:"+x+"y:"+y+"depth:"+closestValue);

			}
		}
	}

	 currentIndex++;
	 if(currentIndex > 2){
		 currentIndex = 0;
	 }

	float interpolatedX = lerp(previousX[0], closestX, 0.3f);
	float interpolatedY = lerp(previousY[0], closestY, 0.3f);

	if(col>360){
		col = 0;
	}
	col++;

	colorMode(HSB,360,100,100);
	color c = color(col,100,100);

	// 左右反転処理+震度カメラ表示
	scale(-1, 1);
	image(kinect.rgbImage(), -width, 0);
	scale(-1, 1);

	//　玉投射
	//　一つ目
	//fill(c);
	//heart(interpolatedX, interpolatedY, 100, 100);

	previousX[0] = interpolatedX;
	previousY[0] = interpolatedY;

	//それ移行
	for (int i = previousX.length-1; i>0; i--){
		previousX[i] = previousX[(i-1)];
	}

	for (int i = previousY.length-1; i>0; i--){
		previousY[i] = previousY[(i-1)];
	}

	for (int i = 0; i<previousX.length-1; i++){
		fill(c, 100-(i*4));
		ellipse(previousX[i], previousY[i],100-(i*4),100-(i*4));
	}


}

void mousePressed(){
	saveFrame("drawing.png");
	background(0);
}

//  ハート形の描画
void heart(float centerX, float centerY, float width, float height){
  final float WIDTH = width / 2 * 0.85;
  final float HEIGHT = height / 2;
  final float OFFSET = centerY - (HEIGHT / 6 * 5);
  beginShape();
  for(int i = 0; i < 30; i++){
    float tx = abs(sin(radians(i * 12))) * (1 + cos(radians(i * 12))) * sin(radians(i * 12)) * WIDTH + centerX;
    float ty = (0.8 + cos(radians(i * 12))) * cos(radians(i * 12)) * HEIGHT + OFFSET;
    vertex(tx, ty);
  }
  endShape(CLOSE);
}

