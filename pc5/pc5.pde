
import processing.opengl.*;
import SimpleOpenNI.*;
SimpleOpenNI kinect;

float rotation = 0;

int boxSize = 150;
PVector boxCenter = new PVector(0,0,600);

float s = 1;

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

	translate(0, 0, 1400);
	// Y軸の周りに開店し，回転角度を増加

	float mouseRotation = map(mouseX, 0, width, -90, 90);
	rotateY(radians(mouseRotation));

	//回転の中心をポイントクラウド内部へ移動(Kinectからおよそ1メートルの位置を中心にポイントクラウドを移動させる．)
	translate(0, 0, s*-1000);
	scale(s);

	println(s);

	stroke(255);

	// 距離データを３D ポイントとして取り込む
	PVector[] depthPoints = kinect.depthMapRealWorld();

	// このフレームでボックスの内部にあると分かったポイントの合計数を保存するために変数を初期化
	int depthPointsInBox = 0;

	for(int i=0; i < depthPoints.length; i+=10){
		// ポイントの配列から現在のポイントを得る
		PVector currentPoint = depthPoints[i];

		if (currentPoint.x > boxCenter.x - boxSize/2 && currentPoint.x < boxCenter.x + boxSize/2){
			if (currentPoint.y>boxCenter.y - boxSize/2 && currentPoint.y < boxCenter.y + boxSize/2){
				if (currentPoint.z>boxCenter.z - boxSize/2 && currentPoint.z < boxCenter.z + boxSize/2){
					depthPointsInBox++;
			}
		}
	}

		// 現在のポイントを描写
		point(currentPoint.x, currentPoint.y, currentPoint.z);
	}

	println(depthPointsInBox);

	float boxAlpha = map(depthPointsInBox, 0,1, 0, 255);

	translate(boxCenter.x, boxCenter.y, boxCenter.z);
	fill(255, 0, 0, boxAlpha);
	stroke(255,0,0);
	box(boxSize);
}


void keyPressed(){
	if(keyCode == 38){
		s = s + 0.01;
	}
	if(keyCode == 40){
		s = s - 0.01;
	}
}

void mousePressed(){
	save("touchPoint.png");
}