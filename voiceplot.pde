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

HashMap<String, Object> generators = new HashMap<String, Object>();
ScrollableList generatorList;
int currentGeneratorIndex;

HashMap<String, Object> sizes = new HashMap<String, Object>();
ScrollableList sizeList;
int currentSizeIndex;
int machineWidth = 420;
int machineHeight = 297;

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
  size(1000, 707);

  timestamp = getCurrentTimeStamp();
  println(timestamp);

  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 4);
  recorder = minim.createRecorder(in, "voiceplot.wav");
  recordTimer = 0;

  sizes.put("10x15", new PVector(150, 100));
  sizes.put("A3", new PVector(420, 297));
  sizes.put("A4", new PVector(297, 210));
  sizes.put("A5", new PVector(210, 148));

  generators.put("Wave Form", new WaveFormGenerator());
  generators.put("Joy Division", new JoyGenerator());
  generators.put("10print", new TenPrintGenerator());
  //generators.put("Test", new TestGenerator());

  cp5 = new ControlP5(this);
  initControls();

  hpgl = (HPGLGraphics) createGraphics(width, height, HPGLGraphics.HPGL);
  hpgl.setPath("voiceplot.hpgl");
  hpgl.setPaperSize("A3");
  //hpgl.setSize(machineWidth, machineHeight);
}

void draw() {
  stroke(1);
  if (recorder.isRecording()) {
    background(255, 230, 230);
  } else if (hasRecord) {
    background(200);
  } else {
    background(150);
  }

  if (!hasRecord) {
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
  } else {
    PVector size = getPrintSizeInPx(width, height);
    Generator currentGenerator = (Generator) generatorList.getItem(currentGeneratorIndex).get("value");
    int offsetX = (width - (int) size.x) / 2;
    int offsetY = (height - (int) size.y) / 2;
    pushMatrix();
    translate(offsetX, offsetY);
    fill(255);
    noStroke();
    rect(0, 0, size.x, size.y);
    stroke(1);
    noFill();
    popMatrix();

    // begin HPGL record
    if (saveHpgl) {
      beginRecord(hpgl);
    }
    pushMatrix();
    translate(offsetX, offsetY);
    currentGenerator.draw(voiceData, hpgl, size.x, size.y);
    popMatrix();
    // end HPGL record
    if (saveHpgl) {
      endRecord();
      saveHpgl = false;
    }
    
    generatorList.show();
    sizeList.show();
    saveBtn.show();
  }
  /*
  fill(0, 0, 0, 0.6);
   noStroke();
   rect(0, 0, 100, height);
   */
}

public PVector getPrintSizeInPx(int canvasWidth, int canvasHeight) {
  PVector size = (PVector) sizeList.getItem(currentSizeIndex).get("value");
  float width = size.x / machineWidth * canvasWidth;
  float height = size.y / machineHeight * canvasHeight;
  return new PVector(width, height);
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

  saveBtn = cp5.addButton("save")
    .setPosition(20, 130)
    .setLabel("Save");

  sizeList.setValue(0);
  generatorList.setValue(0);
  generatorList.bringToFront();
  sizeList.bringToFront();
}

void sizeList(int n) {
  currentSizeIndex = n;
}

void generatorList(int n) {
  currentGeneratorIndex = n;
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
  }
}

public void save() {
  println("save HPGL");
  saveHpgl = true;
}

public String getCurrentTimeStamp() {
  return DateTimeFormatter.ofPattern("mm-dd-").format(LocalDateTime.now());
}