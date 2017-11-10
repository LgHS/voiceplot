class JoyGenerator2 implements Generator {
  float xoff = 0;
  float yoff = 1000;
  
  float secXoff = 0;
  float secyYoff = 1000;

  float u(float n) {
    return width/100 * n;
  }

  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean isRecording) {
    for (int y = 0; y < dataPoints.size(); y += 8) {
      pushMatrix();
      translate(0, y / (dataPoints.size() / height));
      noFill();
      beginShape();
      for (float x = 0; x < width; x++) {
        float ypos = map(noise(x/100 + xoff, y/100 + yoff), 0, 1, -200, 200);
        //float ypos = map(dataPoints.get(y), -1, 1, -200, 0);
        float magnitude = x < width*0.5 ? map(x, width*0.1, width*0.5, -1, 2) : map(x, width*0.5, width*0.9, 2, -1);
        ypos *= magnitude * dataPoints.get(y);
        if (ypos > 0) ypos = 0;

        vertex(x, ypos);


      }
      endShape();
      popMatrix();
    }

   // xoff += 0.01;
    // yoff += -0.01;
  }
  
  boolean hasSignature() {
    return true;
  }
  
  boolean hasPaperTrace() {
    return true;
  }
}