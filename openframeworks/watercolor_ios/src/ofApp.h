#pragma once

#include "ofxiOS.h"
#include "ofxXmlSettings.h"
#include "WaterColorCanvas.h"

class ofApp : public ofxiOSApp {

	public:
        void setup();
		void update();
		void draw();
    
        void strokeDraw();
        void clearLayers();
    
        void keyPressed(int key);
    
        void touchDown(int x, int y, int id);
        void touchMoved(int x, int y, int id);
        void touchUp(int x, int y, int id);
    
        ofxXmlSettings settings;
        int sW, sH;
        int posX, posY;
    
        ofImage bg;
        ofImage brush;
        WaterColorCanvas canvas;
        
        ofPoint pos, prev, vec;
        float width, currentWidth;
        int currentPigment;
        bool pressed;
        bool debugText;
    
        int state;
        static const int STATE_WATER = 0;
        static const int STATE_PIGMENT = 1;
        static const int STATE_MIX = 2;
    
};
