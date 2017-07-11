// http://www.tylerlhobbs.com/writings/watercolor
// https://processing.org/examples/regularpolygon.html

ArrayList<Drop> drop;
boolean firstRun = true;

void setup() {
  size(1280, 720, P2D);
  drop = new ArrayList<Drop>();
  bloomSetup();
  //fluidSetup();
  tex.beginDraw();
  tex.background(0);
  //tex.blendMode(ADD);
  tex.endDraw();
}

void draw() {
  tex.beginDraw();

  for (int i=0; i<drop.size(); i++) {
    drop.get(i).run();
  }
  
  if (mousePressed) {
    if (firstRun) {
      drop.add(new Drop(new PVector(mouseX, mouseY)));
      firstRun = false;
    } else {
      drop.get(0).p = new PVector(mouseX, mouseY);
    }
  }
  tex.endDraw();
  bloomDraw();
  //fluidDraw();
  
  surface.setTitle(""+frameRate);
}

void mouseReleased() {
  drop.remove(0);
  firstRun = true;
}

void keyPressed() {
  drop = new ArrayList<Drop>();
  tex.beginDraw();
  tex.background(0);
  tex.endDraw();
  firstRun = true; 
}