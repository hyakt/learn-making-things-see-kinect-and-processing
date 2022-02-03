int z = 200;

void setup(){
	size(640, 480,P3D);
}

void draw(){
	background(0);

	translate(0, 0, z);
	ellipse(width/2, height/2, 100, 100);

	z -= 1;
}