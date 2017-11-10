interface Generator {
  boolean hasSignature();
  boolean hasPaperTrace();
  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean isRecording);
}