class Size {
  float paperWidth;
  float paperHeight;
  float canvasWidth;
  float canvasHeight;
  boolean traceLimits;
  
  public Size(float myPaperWidth, float myPaperHeight, float myCanvasWidth, float myCanvasHeight, boolean myTraceLimits) {
    paperWidth = myPaperWidth;
    paperHeight = myPaperHeight;
    canvasWidth = myCanvasWidth;
    canvasHeight = myCanvasHeight;
    traceLimits = myTraceLimits;
  }
  
  public float getPaperWidth() {
    return paperWidth;
  }
  
  public float getPaperHeight() {
    return paperHeight;    
  }
  
  public float getCanvasWidth() {
    return canvasWidth;    
  }
  
  public float getCanvasHeight() {
    return canvasHeight; 
  }
  
  public float getScaledPaperWidth() {
      return getPaperWidth() / machineWidth * width;
  }
  
  public float getScaledPaperHeight() {
      return getPaperHeight() / machineHeight * height;
  }
  
  public float getScaledCanvasWidth() {
      return getCanvasWidth() / machineWidth * width;
  }
  
  public float getScaledCanvasHeight() {
      return getCanvasHeight() / machineHeight * height;
  }
  
  public boolean isTraceLimits() {
    return traceLimits;
  }
  
  public String toString() {
    return "{paperWidth: " + Float.toString(getPaperWidth()) 
      + ", paperHeight: " + Float.toString(getPaperHeight())
      + ", canvasWidth: " + Float.toString(getCanvasWidth())
      + ", canvasHeight: " + Float.toString(getCanvasHeight())
      + ", scaledPaperWidth: " + Float.toString(getScaledPaperWidth())
      + ", scaledPaperHeight: " + Float.toString(getScaledPaperHeight())
      + ", scaledCanvasWidth: " + Float.toString(getScaledCanvasWidth())
      + ", scaledCanvasHeight: " + Float.toString(getScaledCanvasHeight()) 
      + "}";
  }
}