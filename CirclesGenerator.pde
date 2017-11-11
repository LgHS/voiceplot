class CirclesGenerator implements Generator {
  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean isRecording) {
    float radius = width / 2;
    pushMatrix();
    translate(radius, radius + ((height - radius * 2) / 2));
    for (int i = 0; i < random(100, 300); i++ ) {
      float a = random(0, TWO_PI);
      float x1 = radius*cos(a);
      float y1 = radius*sin(a);
      a = random(0, TWO_PI);
      float x2 = radius*cos(a);
      float y2 = radius*sin(a);
      line( x1, y1, x2, y2);
    }
    popMatrix();
  }

  boolean hasSignature() {
    return true;
  }

  boolean hasPaperTrace() {
    return true;
  }
}