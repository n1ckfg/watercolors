import gab.opencv.*;

OpenCV opencv;
int levelOfDetails = 2;
int videoScale = 8;
int videoWidth, videoHeight;
PImage motionTexture;
PShader shaderBuffer;
PGraphics[] renderArray;
int currentRender;
float lerpSpeed = 0.05;

PGraphics texScale;

void opticalFlowSetup() {
  videoWidth = tex.width / videoScale;
  videoHeight = tex.height / videoScale;
  texScale = createGraphics(videoWidth, videoHeight, P2D);

  opencv = new OpenCV(this, videoWidth, videoHeight);
  motionTexture = createImage(videoWidth / levelOfDetails, videoHeight / levelOfDetails, RGB);
  shaderBuffer = loadShader("shaders/Buffer.frag", "shaders/Simple.vert");
  renderArray = new PGraphics[2];
  currentRender = 0;
  
  for (int i = 0; i < renderArray.length; i++) {
    renderArray[i] = createGraphics(width, height, P2D);

    renderArray[i].beginDraw();
    renderArray[i].background(0);
    renderArray[i].endDraw();

    // nearest filter mode
    ((PGraphicsOpenGL)renderArray[i]).textureSampling(2);
  }
}

void opticalFlowDraw() {
  opencv.useGray();
  texScale.beginDraw();
  texScale.image(tex, 0, 0, texScale.width, texScale.height);
  texScale.endDraw();
  opencv.loadImage(texScale);
  opencv.calculateOpticalFlow();
  opencv.useColor(PApplet.RGB);

  motionTexture.loadPixels();

  for (int x = 0; x < motionTexture.width; x++) {
    for (int y = 0; y < motionTexture.height; y++) {
      // get the vector motion from openCV
      PVector motion = opencv.getFlowAt(x * levelOfDetails, y * levelOfDetails);

      PVector direction = getNormal(motion.x, motion.y);

      // get index array from 2d position
      int index = x + y * motionTexture.width;

      // encode vector into a color
      colorMode(RGB, 1, 1, 1);
      motionTexture.pixels[index] = color(direction.x * 0.5 + 0.5, direction.y * 0.5 + 0.5, min(1, motion.mag()));
    }
  }

  motionTexture.updatePixels();

  PGraphics bufferWrite = getCurrentRender();
  nextRender();
  PGraphics bufferRead = getCurrentRender();

  // start recording render texture
  bufferWrite.beginDraw();

  shaderBuffer.set("frame", bufferRead);
  shaderBuffer.set("motion", motionTexture);
  shaderBuffer.set("frameOrig", opencv.getOutput());
  shaderBuffer.set("lerpSpeed", lerpSpeed);

  // apply pixel displacement with shader
  bufferWrite.shader(shaderBuffer);
  bufferWrite.rect(0, 0, width, height);

  bufferWrite.endDraw();

  // draw final render
  tex.beginDraw();
  tex.tint(255,30);
  tex.image(bufferWrite, 0, 0, tex.width, tex.height);
  //tex.noTint();
  tex.endDraw();  
  
}

// the current frame buffer
PGraphics getCurrentRender() {
  return renderArray[currentRender];
}

// swap between writing frame and reading frame
void nextRender() {
  currentRender = (currentRender + 1) % renderArray.length;
}

// return normalized vector
PVector getNormal(float x, float y) {
  float dist = sqrt(x*x+y*y);
  return new PVector(x / dist, y / dist);
}
