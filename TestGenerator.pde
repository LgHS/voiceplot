class TestGenerator implements Generator {
  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean  isRecording) {
    rect(0, 0, width, height);
  }
}