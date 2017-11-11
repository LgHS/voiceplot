class Untitled4Generator implements Generator {
  /* 
   Part of the ReCode Project (http://recodeproject.com)
   Based on "Untitled 4" by Various
   Originally published in "Computer Graphics and Art" v1n4, 1976
   Copyright (c) 2013 Will Secor - OSI/MIT license (http://recodeproject/license).
   */


  // This sketch does not exactly duplicate the original, rather it
  // contains the same proportion of rotated elements, per column,
  // as the original in Computer Graphics and Art.  This is detailed 
  // in the array "rotated" below.

  int cols = 12;
  int rows; // calculated from cols
  boolean isRecording;

  void draw(ArrayList<Float> dataPoints, HPGLGraphics hpgl, float width, float height, boolean  myIsRecording) {
    //cols = (int) width / 18;
    float ratio = height / width;
    rows = (int) (cols * ratio) + 1;
    isRecording = myIsRecording;
    column((int) width / cols, 2, rows);
  }

  void element(int wide, int spacing) {
    for (int i = 0; i <= wide; i = i + spacing) {
      line(i, 0, i, wide);
    }
  }

  void column(int wide, int spacing, int total) {
    // create a 2D array, populate each column with the appropriate number
    // of rotated elements, then shuffle the columns

    int[][] numbers = new int[cols][rows];
    for (int i = 0; i < cols; i++) {
      for (int j= 0; j < rows; j++) {
        if (random(1) > 0.2) {
          numbers[i][j] = 1;
        } else {
          numbers[i][j] = 0;
        }
        //rotated[i] = rotated[i] - 1;
      }
    }
    shuffle(numbers);

    // draw according to instructions in the array (1 = rotated)

    for (int s = 0; s < cols; s++) {
      for (int t = 0; t < total; t++) {
        if (numbers[s][t] < 1) {
          pushMatrix();
          translate(s*wide, (wide*t));
          element(wide, spacing);
          popMatrix();
        }
      }
    }

    //stroke(0, 255, 0);
    if (isRecording) {
      //hpgl.selectPen(2);
    }
    for (int z = 0; z < cols; z++) {
      for (int m = 0; m < total; m++) {
        if (numbers[z][m] >= 1) {
          pushMatrix();
          translate(z*wide, (wide*m));
          rotate(radians(270));
          element(wide, spacing);
          popMatrix();
        }
      }
    }

    // draw in some white lines to simulate depth
    /*
    for (int x = 1; x < cols-1; x++) {
     for (int y= 0; y < rows-1; y++) {
     if ((numbers[x][y] == 1) && (numbers[x][y+1] == 0)) {
     stroke(255);
     line(x*wide, ((y+1)*wide), ((x+1)*wide), ((y+1)*wide));
     }
     }
     }
     
     for (int x = 1; x < cols-1; x++) {
     for (int y= 0; y < rows; y++) {
     if ((numbers[x][y] == 1) && (numbers[x+1][y] == 0)) {
     stroke(255);
     line((x+1)*wide, y*wide, (x+1)*wide, (y+1)*wide);
     }
     }
     }
     */
  }


  //Fisher-Yates shuffle, good times!

  void shuffle(int[][] numbers) {
    for (int k = 0; k < cols; k++) {
      for (int i = numbers[k].length-1; i > 0; i = i - 1) {
        int j = int(random(i+1));
        int temp1 = numbers[k][i];
        int temp2 = numbers[k][j];
        numbers[k][i] = temp2;
        numbers[k][j] = temp1;
      }
    }
  }

  boolean hasSignature() {
    return true;
  }

  boolean hasPaperTrace() {
    return true;
  }
}