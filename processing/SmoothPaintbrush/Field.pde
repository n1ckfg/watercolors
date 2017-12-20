class Field {
  
  Subdivision[][] rid;
  long[] RULE;
  PGraphics buffer;
  int xyz;
  int paint;
  int speed;
  int rulecounter;
  int smooth = 1;
  int scaleMouseX, scaleMouseY, scalePMouseX, scalePMouseY;

  Field(int _xyz) {
    xyz = _xyz;
    buffer = createGraphics(xyz, xyz, P2D);
    buffer.loadPixels();
    RULE = new long[4];
    randomrule();
    int[] VAL;
    rid = new Subdivision[xyz][xyz];
    for (int y = 0; y < xyz; y++) {
      for (int x = 0; x < xyz; x++) {
        VAL = new int []{#000000,#000000,#000000,#000000};
        rid[x][y] = new Subdivision(x,y,VAL,RULE, xyz, smooth);
      }
    }
    for (int y = 0; y < xyz; y++) {
      for (int x = 0; x < xyz; x++) {
        rid[x][y].set_neighbours(this.rid);
      }
    }
  }
  
  long randomlong() {
    long result = floor(random(0,65536)); 
    for (int i=0; i<3; i++){
      result <<= 24;
      result += floor(random(0,16777216));
    }
    return result;
  }
  
  void randomrule() {
    RULE[0] = randomlong();
    RULE[1] = randomlong();
    RULE[2] = randomlong();
    RULE[3] = randomlong();
  }
  
  void update(){
    if (mousePressed) {
      if (mouseButton == LEFT) {
        paint = randomcolor();
      } else { 
        paint = #000000; 
      }
    }
  
    scaleMouseX = getScaleCoord(mouseX, width, buffer.width);
    scaleMouseY = getScaleCoord(mouseY, height, buffer.height);
    scalePMouseX = getScaleCoord(pmouseX, width, buffer.width);
    scalePMouseY = getScaleCoord(pmouseY, height, buffer.height);
    speed = floor(dist(scalePMouseX, scalePMouseY, scaleMouseX, scaleMouseY));

    for (int y=0;y<xyz;y++) {
      for (int x=0;x<xyz;x++) {
        rid[x][y].update_pixels(buffer);
        rid[x][y].speed = speed;
        rid[x][y].paint = paint;
        rid[x][y].scaleMouseX = scaleMouseX;
        rid[x][y].scaleMouseY = scaleMouseY;
      }
    }
    buffer.updatePixels();
  }
  
  int getScaleCoord(int input, int max, int min) {
    return int(map(input, 0, max, 0, min));
  }
  
  void draw() {
    for (int y=0; y<xyz; y++) {
      for (int x=0; x<xyz; x++) {
        rid[x][y].buffer();
      }
    }
    
    tex.beginDraw();
    tex.image(buffer, 0, 0, width, height);
    tex.endDraw();
    
    if (rulecounter++ % 100 == 0) {
      randomrule();
    }
  }
  
  void run() {
    update();
    draw();
  }
  
  int randomcolor() {
    return floor(random(#000000,#ffffff));
  }
  
}