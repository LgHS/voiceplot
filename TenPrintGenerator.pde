class TenPrintGenerator implements Generator {
  int spacing = 8;
  float maxDist = 0.0f;
  ArrayList<PVector> redLines = new ArrayList<PVector>();
  ArrayList<PVector> blackLines = new ArrayList<PVector>();
  float paperWidth;
  float paperHeight;
  float seed = random(1);

  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float myWidth, float myHeight, boolean isRecording) {
    paperWidth = myWidth;
    paperHeight = myHeight;
    moveInGrid();
    
    if (isRecording) {
      hpgl.selectPen(1);
    }
    drawLines(redLines, 0);
    if (isRecording) {
      hpgl.selectPen(2);
    }
    drawLines(blackLines, 1);
  }

  void moveInGrid() {
    float cols = paperWidth/spacing;
    float rows = paperHeight/spacing;
    maxDist = dist(0, 0, paperWidth/2, paperHeight/2);
    for (int i = 0; i < rows; i +=1) {
      int y = i*spacing;
      for (int j = 0; j < cols; j += 1) {
        int x = j * spacing;
        storeLines(x, y);
      }
    }
  }
  void storeLines(float x, float y) {
    float p = map(x, paperWidth*.1, paperWidth*.9, 0, 1);

    if (seed < p) {
      redLines.add(new PVector(x, y));
    } else {
      blackLines.add(new PVector(x, y));
    }
  }

  void drawLines(ArrayList<PVector> lines, int dir) {
    for (PVector v : lines) {
      if (dir == 0) {
        stroke(0);
        line(v.x, v.y, v.x+spacing, v.y+spacing);
      } else if (dir == 1) {
        stroke(255, 0, 0);
        line(v.x+spacing, v.y, v.x, v.y+spacing);
      }
    }
  }
}