class PerlinGenerator implements Generator {
  ArrayList points = new ArrayList();
  Boolean md = false;

  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean isRecording) {
    points.clear();

    for (int i = 0; i < random(10, 20); i++) {
      for (int f = 0; f < 50; f++) {
        points.add(new Point(random(0, width), random(0, height)));
      }
    }

    noiseDetail((int)random(4, 10), 0);

    for (int j = 0; j < random(50, 100); j++) {
      for (int i=points.size()-1; i>0; i--) {
        Point p = (Point)points.get(i);
        p.update();
        if (p.finished) {
          points.remove(i);
        }
      }
    }
  }

  boolean hasSignature() {
    return true;
  }

  boolean hasPaperTrace() {
    return true;
  }
}

class Point {
  float x, y, xv = 0, yv = 0;
  float maxSpeed = 3000000;

  Boolean finished = false;

  Point(float x, float y) {
    this.x = x;
    this.y = y;
  } 

  void update() {
    stroke(0);
    float r = random(1);
    this.xv = cos(  noise(this.x*random(.1), this.y*random(.1))*TWO_PI  );
    this.yv = -sin(  noise(this.x*.01, this.y*.01) * random(TWO_PI)  );
    //this.xv = cos(noise(this.x*.1, this.y*.1) * PI);
    //this.yv = -sin(noise(this.x*.1, this.y*.1)*TWO_PI  );
    //this.xv = cos(noise(this.x*.1, this.y*.1) * TWO_PI);
    //this.yv = -sin(noise(this.x*.1, this.y*.1)*HALF_PI  );

    if (this.x>width) {
      //this.x = 1;
      this.finished = true;
    } else if (this.x<0) {
      //this.x = width-1;
      this.finished = true;
    }
    if (this.y>height) {
      //this.y = 1;
      this.finished = true;
    } else if (this.y<0) {
      //this.y = height-1;
      this.finished = true;
    } 

    if (this.xv>maxSpeed) {
      this.xv = maxSpeed;
    } else if (this.xv<-maxSpeed) {
      this.xv = -maxSpeed;
    }
    if (this.yv>maxSpeed) {
      this.yv = maxSpeed;
    } else if (this.yv<-maxSpeed) {
      this.yv = -maxSpeed;
    }

    this.x += this.xv;
    this.y += this.yv;

    line(this.x+this.xv, this.y+this.yv, this.x, this.y );
  }
}