class Subdivision {
  
  long [] rule;
  int [] ra; // results array
  int [] val; // value array
  int x,y; // coordinate of the pixel
  int xy; // x,y in one dimensional framebuffer
  int [][] neighbours;
  int smooth;
  int paint;
  int speed;
  int dis;
  int scaleMouseX, scaleMouseY;
  int xyz;

  Subdivision(int X, int Y, int[]VAL, long[]RULE, int XYZ, int SMOOTH) {
    x = X;
    y = Y;
    val = VAL;
    rule = RULE;
    xyz = XYZ;
    xy = x + xyz * y;
    neighbours = new int[8][4];
    ra = new int[4];
    smooth = SMOOTH;
  }
  
  void set_neighbours(Subdivision[][] rid) {
    int x1, x3, y1, y3;
    for (int i=0; i < 4; i++) {
      x1=(x + 1) % xyz; 
      x3 = (x + xyz - 1) % xyz; // 3 is -1 as it "wraps around"
      y1=(y + 1) % xyz; 
      y3 = (y + xyz - 1) % xyz;
      
      // surrounding pixels clockwise
      neighbours[0] = rid[x1][y3].val;
      neighbours[1] = rid[x1][y].val;
      neighbours[2] = rid[x1][y1].val;
      neighbours[3] = rid[x][y1].val;
      neighbours[4] = rid[x3][y1].val;
      neighbours[5] = rid[x3][y].val;
      neighbours[6] = rid[x3][y3].val;
      neighbours[7] = rid[x][y3].val;  
    }
  }
 
  /* Thanks to u/ErasmusDarwin */
  int blackbox(long n, long rule) {
    return int((rule>>(n*4))&15);
  }
 
  int pixel(int foo, int bar) { 
    if (smooth <= 0){
      return foo;
    } else if (smooth >= 8) {
      return bar;
    } else{
      int r,g,b;
      r = (((foo >> 16 & 0xFF) * ((1 << smooth) - 1) + (bar >> 16 & 0xFF)) >> smooth) << 16;
      g = (((foo >>  8 & 0xFF) * ((1 << smooth) - 1) + (bar >>  8 & 0xFF)) >> smooth) << 8;
      b = (((foo & 0xFF) * ((1 << smooth) - 1) + (bar & 0xFF)) >> smooth);
      return r+g+b;
    }
  }
 
  int merge()  {
    int r,g,b;
    r = (((ra[0] >> 16 & 0xFF) + (ra[1] >> 16 & 0xFF) + (ra[2] >> 16 & 0xFF) + (ra[3] >> 16 & 0xFF)) >> 2) << 16;
    g = (((ra[0] >>  8 & 0xFF) + (ra[1] >>  8 & 0xFF) + (ra[2] >>  8 & 0xFF) + (ra[3] >>  8 & 0xFF)) >> 2) << 8;
    b = ((ra[0] & 0xFF) + (ra[1] & 0xFF) + (ra[2] & 0xFF) + (ra[3] & 0xFF)) >> 2;
    return #000000+r+g+b;
  }
  
  void update_pixels(PGraphics target) {
    dis = floor(dist(scaleMouseX, scaleMouseY, x, y));
    int c;   // comparission
    int t;  // transformation
    int r; // result
    int top, bottom, layer; // 
    
    for (int l=0; l<4; l++) {
      if (mousePressed) {
          smooth = max(0, min(8, dis >> 6));
        } else {
          smooth=0;
        }
      if (mousePressed && dis < 1 + speed) {
        r = paint;
      } else {
        top = (l + 1) % 4; 
        bottom=(l + 3) % 4;
        c = 0;
        for (int n=0; n<8; n++) {
          if (val[l] > neighbours[n][top]) c++;
          if (val[l] > neighbours[n][bottom]) c++;
        }
        t = blackbox(c, rule[l]);
        if (t <= 7) { 
          layer = top; 
        } else { 
          t -= 8; 
          layer = bottom; 
        }
        r = neighbours[t][layer];
      }
      ra[l] = pixel(r,val[l]);
    }
    target.pixels[xy] = merge();
  }
  
  void buffer() {
    for (int l=0; l<4; l++) {
      val[l]=ra[l];
    }
  }
  
}