/**
 TODO
 * timestamp
 * bugfix textfield not updating
 * bugfix signature position
 * test pen
 * adaptors
 * random (no recording)
 * hotkeys
 ***** 10print
 ***** signature
 **/
import hpglgraphics.*;

import java.text.*;
import java.util.*;
import java.time.*;
import java.time.format.*;

import hpglgraphics.*;

import controlP5.*;  
import ddf.minim.*;

ControlP5 cp5;
Toggle recordToggle;
Button saveBtn;
Textfield signatureText;

HashMap<String, Object> generators = new HashMap<String, Object>();
ScrollableList generatorList;
int currentGeneratorIndex;

HashMap<String, Object> sizes = new HashMap<String, Object>();
ScrollableList sizeList;
int currentSizeIndex;
float machineWidth = 16158 / 40; // comes from weird A3 size in HPGLGraphics code
float machineHeight = 11040 / 40;  // comes from weird A3 size in HPGLGraphics code

HPGLGraphics hpgl;
boolean saveHpgl;

Minim minim;
AudioInput in;
AudioSample voice;
AudioRecorder recorder;
boolean hasRecord;
ArrayList<Float> voiceData = new ArrayList<Float>();

String timestamp;

int recordTimer;
int recordTime = 2000; // max record time in millis

void setup() {
  size(1000, 683); // 16158/11040 ratio (from HPGLGraphics code)
  pixelDensity(displayDensity());
  timestamp = getCurrentTimeStamp();

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 4);
  recorder = minim.createRecorder(in, "voiceplot.wav");
  recordTimer = 0;

  sizes.put("13x18cm", new Size(130, 180, 90, 150, true));
  //sizes.put("A4 30x21cm", new Size(297, 210, 217, 150, false));
  sizes.put("30x21cm", new Size(297, 210, 217, 150, true));

  generators.put("Wave Form", new WaveFormGenerator());
  generators.put("Joy Division", new JoyGenerator());
  //generators.put("Joy Division 2", new JoyGenerator2());
  generators.put("10print", new TenPrintGenerator());
  //generators.put("Test", new TestGenerator());

  cp5 = new ControlP5(this);
  initControls();

  hpgl = (HPGLGraphics) createGraphics(width, height, HPGLGraphics.HPGL);
  hpgl.setPath("voiceplot.hpgl");
  hpgl.setPaperSize("A3");
  smooth();
}

void draw() {
  if (!hasRecord) {
    stroke(0);
    if (recorder.isRecording()) {
      background(0, 255, 0);
    } else {
      background(150);
    }
    
    for (int i = 0; i < in.bufferSize() - 1; i++)
    {
      float d = in.left.get(i);
      int x = (int) map(i, 0, in.bufferSize() - 1, 0, width);
      int nextX = (int) map(i+1, 0, in.bufferSize() - 1, 0, width);
      line(x, height/2 + d*height/2, nextX, height/2 + in.left.get(i+1)*height/2);
      if (recorder.isRecording()) {
        voiceData.add(d);
      }
    }

    if (recordTimer > 0) {
      if (millis() > recordTimer + recordTime) {
        recordToggle.setValue(false);
      }
    }

    generatorList.hide();
    sizeList.hide();
    saveBtn.hide();
    signatureText.hide();
  } else {
    generatorList.show();
    sizeList.show();
    saveBtn.show();
    signatureText.show();    
  }
}

void drawCanvas() {
  if (!hasRecord) {
    return;
  }

  background(200);
  stroke(0);

  Size size = (Size) sizeList.getItem(currentSizeIndex).get("value");
  Generator currentGenerator = (Generator) generatorList.getItem(currentGeneratorIndex).get("value");
  int offsetX = (width - (int) size.getScaledCanvasWidth()) / 2;
  int offsetY = (height - (int) size.getScaledCanvasHeight()) / 2;

  float drawingWidth = size.getScaledCanvasWidth();
  float drawingHeight = size.getScaledCanvasHeight();
  float paperWidth = size.getScaledPaperWidth();
  float paperHeight = size.getScaledPaperHeight();

  // begin HPGL record
  if (saveHpgl) {
    beginRecord(hpgl);
    // wait for pendown
    rect(0, height - 50, 50, 50);
    rect(0, height - 50, 50, 50);
    rect(0, height - 50, 50, 50);
    rect(0, height - 50, 50, 50);
  }

  pushMatrix();
  // landscape, we need to rotate
  if (size.getPaperWidth() > size.getPaperHeight()) {
    translate(offsetX + width / 2, offsetY);
    rotate(PI/2);
    drawingWidth = size.getScaledCanvasHeight();
    drawingHeight = size.getScaledCanvasWidth();
    paperWidth = size.getScaledPaperHeight();
    paperHeight = size.getScaledPaperWidth();
  } else {
    translate(offsetX, offsetY);
  }

  // trace paper size
  if (size.isTraceLimits()) {
    tracePaperSize(size);
  }

  currentGenerator.draw(voiceData, hpgl, drawingWidth, drawingHeight, saveHpgl);

  if (signatureText.getText().length() > 0) {
    String text = signatureText.getText();
    float verticalMargin = (paperHeight - drawingHeight) / 2;
    textSize(drawingHeight / 50);
    fill(0);
    text(signatureText.getText(), drawingWidth - textWidth(text), drawingHeight + (verticalMargin / 2));
    noFill();
  }

  //popMatrix();
  popMatrix();
  // end HPGL record
  if (saveHpgl) {
    endRecord();
    saveHpgl = false;
  }
}

void tracePaperSize(Size size) {
  fill(255);
  // offset manually since HPGLGraphics doesn't seem to handle embedded pushMatrix
  float startX = -(size.getScaledPaperWidth() - size.getScaledCanvasWidth()) / 2;
  float startY = -(size.getScaledPaperHeight() - size.getScaledCanvasHeight()) / 2;
  // rotate if landscape
  if (size.getScaledPaperWidth() > size.getScaledPaperHeight()) {
    rect(startY, startX, size.getScaledPaperHeight(), size.getScaledPaperWidth());
    //rect(startX, startY, size.getScaledPaperWidth(), size.getScaledPaperHeight());
  } else {
    rect(startX, startY, size.getScaledPaperWidth(), size.getScaledPaperHeight());
    rect(startX, startY, size.getScaledPaperWidth(), size.getScaledPaperHeight());
  }
  noFill();
}

void initControls() {
  recordToggle = cp5.addToggle("toggleRecording")
    .setPosition(20, 20)
    .setLabel("Toggle Recording");

  sizeList = cp5.addScrollableList("sizeList")
    .setPosition(20, 70)
    .setBarHeight(20)
    .close()
    .addItems(sizes);

  generatorList = cp5.addScrollableList("generatorList")
    .setPosition(20, 100)
    .setBarHeight(20)
    .close()
    .addItems(generators);

  signatureText = cp5.addTextfield("signatureText")
    .setPosition(20, 130)
    .setValue("LGHS17");

  saveBtn = cp5.addButton("save")
    .setPosition(20, 180)
    .setLabel("Save");

  sizeList.setValue(1);
  generatorList.setValue(2);
  generatorList.bringToFront();
  sizeList.bringToFront();
}

void sizeList(int n) {
  currentSizeIndex = n;
  drawCanvas();
}

void generatorList(int n) {
  currentGeneratorIndex = n;
  drawCanvas();
}

public void toggleRecording(boolean toggled) {
  if (toggled) {
    voiceData.clear();
    hasRecord = false;
    recorder.beginRecord();
    loop();
    recordTimer = millis();
  } else {
    recorder.endRecord();
    recordTimer = 0;
    hasRecord = true;
    drawCanvas();
  }
}

public void signatureText(String theText) {
   drawCanvas(); 
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
}

public void save() {
  println("save HPGL");
  saveHpgl = true;
  drawCanvas();
}

public String getCurrentTimeStamp() {
  return DateTimeFormatter.ofPattern("mm-dd-").format(LocalDateTime.now());
}