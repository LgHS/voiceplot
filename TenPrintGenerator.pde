class TenPrintGenerator implements Generator {
  int spacing;
  ArrayList<PVector> redLines = new ArrayList<PVector>();
  ArrayList<PVector> blackLines = new ArrayList<PVector>();
  float paperWidth;
  float paperHeight;
  ArrayList<Float> dataPoints;

  void draw(ArrayList<Float> myDataPoints, HPGLGraphics hpgl, float myWidth, float myHeight, boolean isRecording) {
    paperWidth = myWidth;
    paperHeight = myHeight;
    dataPoints = myDataPoints;
    spacing = 5;
    
    redLines.clear();
    blackLines.clear();
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
    for (int i = 0; i < rows; i +=1) {
      int y = i*spacing;
      for (int j = 0; j < cols; j += 1) {
        int x = j * spacing;
        storeLines(y, x);
      }
    }
  }
  
  void storeLines(float x, float y) {
    float p = map(x, 0, paperHeight, 0, 1);
    int dataIndex = (int) ((y / paperWidth) * dataPoints.size());
    if(dataIndex > dataPoints.size()) {
      return;
    }
    float dataValue = map(dataPoints.get(dataIndex), -1, 1, 0, 1);
    float seed = random(1);
        
    if (seed < p * 2 - dataValue) {
      redLines.add(new PVector(x, y));
    } else {
      blackLines.add(new PVector(x, y));
    }
  }

  void drawLines(ArrayList<PVector> lines, int dir) {
    for (PVector v : lines) {
      if (dir == 0) {
        stroke(0);
        line(v.y, v.x, v.y+spacing, v.x+spacing);
      } else if (dir == 1) {
        stroke(255, 0, 0);
        line(v.y+spacing, v.x, v.y, v.x+spacing);
      }
    }
  }
}