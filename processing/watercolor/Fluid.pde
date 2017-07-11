//import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import com.thomasdiewald.pixelflow.java.fluid.DwFluidParticleSystem2D;
import controlP5.ControlP5;

int fluidgrid_scale = 1;

ControlP5 cp5;

//DwPixelFlow context;
DwFluid2D fluid;

MyFluidData cb_fluid_data;
DwFluidParticleSystem2D particle_system;

PGraphics2D pg_fluid;       // render target
PGraphics2D pg_image;       // texture-buffer, for adding fluid data

// some state variables for the GUI/display
int     BACKGROUND_COLOR           = 0;
boolean UPDATE_FLUID               = true;
boolean DISPLAY_FLUID_TEXTURES     = true;
boolean DISPLAY_FLUID_VECTORS      = false;
int     DISPLAY_fluid_texture_mode = 0;
boolean DISPLAY_PARTICLES          = false;
  
void fluidSetup() {
  //context = new DwPixelFlow(this);
  cp5 = new ControlP5(this);
  
  // fluid simulation
  fluid = new DwFluid2D(context, width, height, fluidgrid_scale);
  
  // some fluid parameters
  fluid.param.dissipation_density     = 1.00f;
  fluid.param.dissipation_velocity    = 0.95f;
  fluid.param.dissipation_temperature = 0.70f;
  fluid.param.vorticity               = 0.50f;
  
  // interface for adding data to the fluid simulation
  cb_fluid_data = new MyFluidData();
  fluid.addCallback_FluiData(cb_fluid_data);
  
    // fluid render target
  pg_fluid = (PGraphics2D) createGraphics(width, height, P2D);
  pg_fluid.smooth(4);
  
  // particles
  particle_system = new DwFluidParticleSystem2D();
  particle_system.resize(context, width/3, height/3);
  
  // image/buffer that will be used as density input
  /*
  pg_image = (PGraphics2D) createGraphics(width, height, P2D);
  pg_image.noSmooth();
  pg_image.beginDraw();
  pg_image.clear();
  pg_image.translate(width/2, height/2);
  pg_image.scale(height / (float) image.height);
  pg_image.imageMode(CENTER);
  pg_image.image(image, 0, 0);
  pg_image.endDraw();
  */
}

void fluidDraw() {
    if(UPDATE_FLUID){
      fluid.update();
      particle_system.update(fluid);
    }

    pg_fluid.beginDraw();
    pg_fluid.background(BACKGROUND_COLOR);
    pg_fluid.endDraw();
    
    if(DISPLAY_FLUID_TEXTURES){
      fluid.renderFluidTextures(pg_fluid, DISPLAY_fluid_texture_mode);
    }
    
    if(DISPLAY_FLUID_VECTORS){
      fluid.renderFluidVectors(pg_fluid, 10);
    }
    
    if(DISPLAY_PARTICLES){
      particle_system.render(pg_fluid, null, 0);
    }
    
    // display
    image(pg_fluid, 0, 0);
}
  
private class MyFluidData implements DwFluid2D.FluidData{
    
    @Override
    // this is called during the fluid-simulation update step.
    public void update(DwFluid2D fluid) {
    
      float px, py, vx, vy, radius, vscale;

      boolean mouse_input = !cp5.isMouseOver() && mousePressed;
      if(mouse_input ){
        
        vscale = 15;
        px     = mouseX;
        py     = height-mouseY;
        vx     = (mouseX - pmouseX) * +vscale;
        vy     = (mouseY - pmouseY) * -vscale;
        
        if(mouseButton == LEFT){
          radius = 20;
          fluid.addVelocity(px, py, radius, vx, vy);
        }
        if(mouseButton == CENTER){
          radius = 50;
          fluid.addDensity (px, py, radius, 1.0f, 0.0f, 0.40f, 1f, 1);
        }
        if(mouseButton == RIGHT){
          radius = 15;
          fluid.addTemperature(px, py, radius, 15f);
        }
      }
  
      // use the text as input for density
      float mix = fluid.simulation_step == 0 ? 1.0f : 0.01f;
      addDensityTexture(fluid, pg_image, mix);
    }
    
    // custom shader, to add density from a texture (PGraphics2D) to the fluid.
    public void addDensityTexture(DwFluid2D fluid, PGraphics2D pg, float mix){
      int[] pg_tex_handle = new int[1];
//      pg_tex_handle[0] = pg.getTexture().glName;
      context.begin();
      context.getGLTextureHandle(pg, pg_tex_handle);
      context.beginDraw(fluid.tex_density.dst);
      DwGLSLProgram shader = context.createShader(this, "data/addDensity.frag");
      shader.begin();
      shader.uniform2f     ("wh"        , fluid.fluid_w, fluid.fluid_h);                                                                   
      shader.uniform1i     ("blend_mode", 6);   
      shader.uniform1f     ("mix_value" , mix);     
      shader.uniform1f     ("multiplier", 1);     
      shader.uniformTexture("tex_ext"   , pg_tex_handle[0]);
      shader.uniformTexture("tex_src"   , fluid.tex_density.src);
      shader.drawFullScreenQuad();
      shader.end();
      context.endDraw();
      context.end("app.addDensityTexture");
      fluid.tex_density.swap();
    }
 
  }