#include "PigmentLayer.h"

PigmentLayer :: PigmentLayer() {
    fbo = new ofFbo();
    fbo -> allocate(ofGetWidth(), ofGetHeight());//, GL_RGBA32F);
    fbo -> begin();
    ofClear(0.f, 0.f, 0.f, 255.f);
    fbo -> end();
}

PigmentLayer :: ~PigmentLayer() {
    
}


ofFbo* PigmentLayer :: update(ofFbo* water, ofFbo* noise, ofFbo* temp, ofShader& shader) {
    temp -> begin();
    ofClear(0.f, 0.f, 0.f, 0.f);
    shader.begin();
    shader.setUniformTexture("noise", *noise, 1);
    shader.setUniformTexture("water", *water, 2);
    fbo -> draw(0, 0);
    shader.end();
    temp -> end();
    
    ofFbo *swap = fbo;
    fbo = temp;
    return swap;
}



