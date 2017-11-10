class WaveFormGenerator implements Generator {
  void draw(ArrayList<Float> voiceData, HPGLGraphics hpgl, float width, float height, boolean isRecording) {
    //rect(0, 0, width, height);
    for (int i = 0; i < voiceData.size() - 1; i++) {
      int x = (int) map(i, 0, voiceData.size() - 1, 0, width);
      int nextX = (int) map(i+1, 0, voiceData.size() - 1, 0, width);
      int halfHeight = (int) height / 2;
      int waveHeight = (int) height / 8;
      line(x, halfHeight + voiceData.get(i) * waveHeight, nextX, halfHeight + voiceData.get(i+1) * waveHeight);
    }
  }
  
  boolean hasSignature() {
    return true;
  }
  
  boolean hasPaperTrace() {
    return true;
  }
}