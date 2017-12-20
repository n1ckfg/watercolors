// https://forum.processing.org/two/discussion/21070/smooth-paintbrush

Field g;

void setup() {
  size(1024, 1024, P2D);
  g = new Field(int(width/3));
  bloomSetup();
}

void draw() {
  g.run();
  bloomDraw();
  surface.setTitle(""+frameRate);
}