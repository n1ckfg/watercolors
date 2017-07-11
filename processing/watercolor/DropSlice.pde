class DropSlice {

  PVector p;
  float s;
  ArrayList<PVector> vertices;
  int numReps;
  float gaussianScale = 5;
  color c = color(110, 50, 255);
  int a = 5;
  float rot = 0;
  
  DropSlice(PVector _p, float _s, int _numReps) {
    p = _p;
    s = _s;
    c = color(random(red(c)), random(green(c)), random(a, blue(c)), random(a/2, a));    
    vertices = new ArrayList<PVector>();
    createPolygon(0, 0, s, 10); // x, y, size, sides
    deformPolygonRepeat(_numReps);
  }

  DropSlice(PVector _p, float _s, int _numReps, ArrayList<PVector> _vertices) {
    p = _p;
    s = _s;
    c = color(red(c), green(c), blue(c), int(random(a)));    
    vertices = new ArrayList<PVector>();
    for (int i=0; i<_vertices.size(); i++) {
      vertices.add(_vertices.get(i));
    }
    deformPolygonRepeat(_numReps);
  }
  
  void draw() {
    tex.pushMatrix();
    tex.translate(p.x, p.y);
    tex.fill(c);
    if (random(1) > 0.8) {
      tex.fill(255, 127, 0, a);
    }
    if (random(1) > 0.5) {
      rot = random(2 * PI);
    }
    tex.rotate(rot);
    tex.noStroke();
    drawPolygon();
    tex.popMatrix();
  }
  
  void run() {
    draw();
  }

  void createPolygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertices.add(new PVector(sx, sy));
    }
  }
  
  void drawPolygon() {
    tex.beginShape();
    for (int i=0; i<vertices.size(); i++) {
      PVector v = vertices.get(i);
      tex.vertex(v.x, v.y);
    }
    tex.endShape(CLOSE);
  }
  
  void deformPolygonRepeat(int _numReps) {
    println("Start: " + vertices.size() + " verts.");
    for (int i=0; i<_numReps; i++) {
      vertices = deformPolygon(vertices);
    }
    println("End: " + vertices.size() + " verts.");    
  }
  
  ArrayList<PVector> deformPolygon(ArrayList<PVector> _vertices) {
    for (int i=0; i<_vertices.size(); i+=2) {
      PVector a, c;
      a = _vertices.get(i);
      if (i + 2 > vertices.size()) {
        c = _vertices.get(0);
      } else {
        c = _vertices.get(i+1);
      }
      PVector mid = getGaussianMidpoint(a, c);
      _vertices.add(i+1, mid);
    }
    return _vertices;
  }
  
  PVector getGaussianMidpoint(PVector a, PVector c) {
    float x = (a.x + c.x)/2;
    float y = (a.y + c.y)/2;
    x = x + (randomGaussian() * gaussianScale);
    y = y + (randomGaussian() * gaussianScale);
    PVector mid = new PVector(x,y);
    return mid;
  }
 
}