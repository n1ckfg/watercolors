import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;
import processing.opengl.PGraphics2D;
import processing.opengl.PGraphics3D;

DwPixelFlow context;
DwFilter filter;
PGraphics2D tex, bloom;

void bloomSetup() {
  tex = (PGraphics2D) createGraphics(width, height, P2D);
  bloom = (PGraphics2D) createGraphics(width, height, P2D);
  context = new DwPixelFlow(this);
  filter = new DwFilter(context);
  //filter.bloom.setBlurLayers(10);
  filter.bloom.param.mult = 3.5; // 0.0-10.0
  filter.bloom.param.radius = 0.5; // 0.0-1.0
}

void bloomDraw() {
  bloom.beginDraw();
  bloom.image(tex,0,0);
  bloom.endDraw();
  filter.bloom.apply(bloom);
  
  image(bloom, 0, 0);
}