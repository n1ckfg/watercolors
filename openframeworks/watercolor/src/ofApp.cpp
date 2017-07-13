#include "ofApp.h"

//--------------------------------------------------------------
void ofApp :: setup() {
    if (settings.loadFile("settings.xml")) {
        sW = settings.getValue("settings:width",0);
        sH = settings.getValue("settings:height",0);
        debugText = settings.getValue("settings:debug",false);
        //ofSetWindowShape(sW, sH);
    }
    
    bg.loadImage("bg_white.png");
    brush.loadImage("brush.png");
    
    canvas.addPigment(ofColor(255, 192,0, 255));
    canvas.addPigment(ofColor(30,92,225, 255));
    canvas.addPigment(ofColor(255,43,0, 255));
    canvas.addPigment(ofColor(36, 34, 59, 255));
    
    state = STATE_WATER;
    currentPigment = 0;
    width = 120;
    ofSetFrameRate(30);
}

//--------------------------------------------------------------
void ofApp :: update() {
    if (pressed) strokeDraw();
    
    canvas.update();
}

//--------------------------------------------------------------
void ofApp :: draw() {
    canvas.draw();
    
    glBlendFunc(GL_ZERO, GL_SRC_COLOR);
    bg.draw(0, 0, ofGetWidth(), ofGetHeight());
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    
    if (debugText) {
        string str;
        if (state == STATE_WATER) str = "water";
        if (state == STATE_PIGMENT) str = "pigment";
        if (state == STATE_MIX) str = "mix";
        str += "  width: " + ofToString(width) + "  pigment: " + ofToString(currentPigment);
        ofDrawBitmapString(str, 20, 20);
    }
}

//--------------------------------------------------------------
void ofApp :: strokeDraw() {
    int counter = 0;
    ofPoint target = ofPoint(mouseX, mouseY);
    float len = pos.distance(target);
 
    
    while (counter < 1000) {
        counter ++;
        currentWidth = min(width, max(width / 4.f, currentWidth - (len - 25) * 0.001f));
        
        vec += (target - pos).normalize() * 0.03;
        vec *= 0.97;
        if (vec.length() > 2) {
            vec = vec.normalize() * 2;
        }
        
        pos += vec;
        
        if (state == STATE_WATER || state == STATE_MIX) {
            canvas.beginWaterDraw();
            ofPushStyle();
            ofSetColor(128, ofRandom(100, 120), 0, 300 / currentWidth);
            brush.draw(pos.x - currentWidth * 1.05 / 2 * 2, pos.y - currentWidth * 1.05/ 2 * 2, currentWidth * 1.05 * 2, currentWidth * 1.05 * 2);
            ofPopStyle();
            canvas.endWaterDraw();
        }
        
        
        if (state == STATE_PIGMENT || state == STATE_MIX) {
            canvas.beginPigmentDraw(currentPigment);
            ofPushStyle();
            ofSetColor(ofRandom(100, 150), 0, 0, 300 / currentWidth / ((state == 2) ? 2 : 1));
            brush.draw(pos.x - currentWidth / 2 * 2, pos.y - currentWidth / 2 * 2, currentWidth * 2, currentWidth * 2);
            ofPopStyle();
            canvas.endPigmentDraw();
        }
        
        if (pos.distance(target) < 10) break;
    }
    
}



//--------------------------------------------------------------
void ofApp :: keyPressed(int key) {
    
    switch (key) {
        case OF_KEY_LEFT:
            currentPigment = (currentPigment == 0) ? 3 : currentPigment - 1;
            break;
        case OF_KEY_RIGHT:
            currentPigment = (currentPigment + 1) % 4;
            break;
        case OF_KEY_UP:
            width = min(width + 10, 150.f);
            break;
        case OF_KEY_DOWN:
            width = max(width - 10, 30.f);
            break;
        case OF_KEY_TAB:
            debugText = !debugText;
        case 'z':
            width = 150;
            break;
        case 'x':
            width = 100;
            break;
        case 'c':
            width = 50;
            break;
        case ' ':
            state = (state + 1) % 3;
            break;
    }
}

//--------------------------------------------------------------
void ofApp :: keyReleased(int key) {

}

//--------------------------------------------------------------
void ofApp :: mouseMoved(int x, int y ) {

}

//--------------------------------------------------------------
void ofApp :: mouseDragged(int x, int y, int button) {

}

//--------------------------------------------------------------
void ofApp :: mousePressed(int x, int y, int button) {
    pressed = true;
    pos.set(mouseX, mouseY);
    vec.set(0,0);
    currentWidth = width;
}

//--------------------------------------------------------------
void ofApp :: mouseReleased(int x, int y, int button) {
    pressed = false;
}

//--------------------------------------------------------------
void ofApp :: windowResized(int w, int h) {

}

//--------------------------------------------------------------
void ofApp :: gotMessage(ofMessage msg) {

}

//--------------------------------------------------------------
void ofApp :: dragEvent(ofDragInfo dragInfo) { 

}
