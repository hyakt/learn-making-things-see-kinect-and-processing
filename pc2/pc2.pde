
import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

float rotation = 0;

void setup(){
	size(1024, 768, OPENGL);
	kinect = new SimpleOpenNI(this);
	kinect.enableDepth();
}

void draw(){
	background(0);
	kinect.update();

	// X軸とY軸方向の中央に，Z軸方向には1000ピクセル
	// 近づいた位置に描写する様に準備する
	translate(width/2, height/2, -1000);
	rotateX(radians(180)); //Y軸を「現実世界]から反転させる

	// Y軸の周りに開店し，回転角度を増加
	//rotateY(radians(rotation));
	//rotation++;

	float mouseRotation = map(mouseX, 0, width, -90, 90);
	rotateY(radians(mouseRotation));


	//回転の中心をポイントクラウド内部へ移動(Kinectからおよそ1メートルの位置を中心にポイントクラウドを移動させる．)

	translate(0, 0, -1000);
	stroke(255);

	// 距離データを３D ポイントとして取り込む
	PVector[] depthPoints = kinect.depthMapRealWorld();

	for(int i=0; i < depthPoints.length; i+=10){
		// ポイントの配列から現在のポイントを得る
		PVector currentPoint = depthPoints[i];
		// 現在のポイントを描写
		point(currentPoint.x, currentPoint.y, currentPoint.z);
	}
}
