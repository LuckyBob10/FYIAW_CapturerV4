import java.awt.image.BufferedImage;
import java.awt.*;
import dmxP512.*;
import processing.serial.*;


OPC opc;
PImage screenShot;
GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
GraphicsDevice[] gs = ge.getScreenDevices();
DisplayMode mode = gs[0].getDisplayMode();
DmxP512 dmx;

PFrame fControl;
secondApplet sControl;

void setup() {
  //Set up window
  size(480, 216);
  frameRate(iFrameRate);
  if (frame != null) {
    frame.setAlwaysOnTop(true);
  }
  frame.setResizable(false);
  
  //Draw DMX area
  fill(0);
  rect(0, iCaptureHeight, width, 16);
  
  
  //Set up control panel window
  PFrame fControl = new PFrame();
  
  
  //Set up OPC
  if (bScreenEnabled) {
    int spacing = iCaptureHeight/16;
    opc = new OPC(this, "127.0.0.1", 7890);
    
    opc.ledStrip(0,   60, width/2, spacing-(spacing/2), width/60, 0, false);
    opc.ledStrip(60,  60, width/2, (spacing*2)-(spacing/2), width/60, 0, false);
    opc.ledStrip(120, 60, width/2, (spacing*3)-(spacing/2), width/60, 0, false);
    opc.ledStrip(180, 60, width/2, (spacing*4)-(spacing/2), width/60, 0, false);
    opc.ledStrip(240, 60, width/2, (spacing*5)-(spacing/2), width/60, 0, false);
    opc.ledStrip(300, 60, width/2, (spacing*6)-(spacing/2), width/60, 0, false);
    opc.ledStrip(360, 60, width/2, (spacing*7)-(spacing/2), width/60, 0, false);
    opc.ledStrip(420, 60, width/2, (spacing*8)-(spacing/2), width/60, 0, false);
    
    opc.ledStrip(480, 60, width/2, (spacing*9)-(spacing/2), width/60, 0, false);
    opc.ledStrip(540, 60, width/2, (spacing*10)-(spacing/2), width/60, 0, false);
    opc.ledStrip(600, 60, width/2, (spacing*11)-(spacing/2), width/60, 0, false);
    opc.ledStrip(660, 60, width/2, (spacing*12)-(spacing/2), width/60, 0, false);
    opc.ledStrip(720, 60, width/2, (spacing*13)-(spacing/2), width/60, 0, false);
    opc.ledStrip(780, 60, width/2, (spacing*14)-(spacing/2), width/60, 0, false);
    opc.ledStrip(840, 60, width/2, (spacing*15)-(spacing/2), width/60, 0, false);
    opc.ledStrip(900, 60, width/2, (spacing*16)-(spacing/2), width/60, 0, false);
  }
  
  
  //Set up DMX
  dmx = new DmxP512(this, universeSize, false);
  if (bFloodLightsEnabled) {
    dmx.setupDmxPro(DMXPRO_PORT,DMXPRO_BAUDRATE);
  }
}

void draw () {
  //Set initial position
  if (iInitialPositionSet < 15) {
    frame.setLocation(iInitialX, iInitialY);
    iInitialPositionSet++;
  }
  
  //Check for mouse click in control window and debounce
  if (sControl.mousePressed && millis() > iLastMouseClick+100) {
    iLastMouseClick = millis();
    ControlMouseTest();
  }
  
  //Capture screen
  screenShot = getScreen();
  image(screenShot,0,0, width, iCaptureHeight);
  frame.setTitle("FYIAW Capturer - " + int(frameRate) + " fps, beatcount " + iDMXBeatCount);
  
  //Control panel stuff
  if (!bControlPanelDrawn) {
    DrawControlPanel();
  }
  
  //Beat detection
  fill(0);
  stroke(1);
  line(iCaptureWidth-8, iCaptureHeight, iCaptureWidth, iCaptureHeight-8);
  iBeatPixel = get(iCaptureWidth-1, iCaptureHeight-1);
  if ((iBeatPixel == color(255) || iBeatPixel == color(0)) && iBeatPixel != iBeatPixelLast) {
    iDMXBeatCount++;
    iBeatPixelLast = iBeatPixel;
  }
  
  //Process DMX data
  int[] iDMXData = new int[(iDMXFixtureCount*3)+1];
  color cDMX = color(0, 0, 0);
  if (bDMXTest) {
    //Test mode
    fill(0);
    for (int i=0; i<universeSize; i++) {
      if (i == iDMXTestChan) {
        iDMXData[i] = 255;
      }
      else {
        iDMXData[i] = 0;
      }
      if (millis() > iLastDMXTest+iDMXTextLen) {
        iDMXTestChan++;
        println("Testing DMX channel " + iDMXTestChan);
        iLastDMXTest = millis();
        if (iDMXTestChan > universeSize) {
          iDMXTestChan = 0;
        }
      }
    }
  }
  else {
    for (int i=0; i<iDMXFixtureCount; i++) {          
      if (bFixedColor) {
        //Fixed color
        cDMX = color(iFixedColorR, iFixedColorG, iFixedColorB);
        fill(iFixedColorR, iFixedColorG, iFixedColorB);
      }
      else {
        //Capture pixels
        cDMX = SmoothColor(iDMXLocations[iDMXLocationIndex][i*2], iDMXLocations[iDMXLocationIndex][(i*2)+1], i);
      }
      
      //iDMXData[i*3] = iGammaMap[round(blue(cDMX) * iDimmingFactor)];
      //iDMXData[(i*3)+1] = iGammaMap[round(red(cDMX) * iDimmingFactor)];
      //iDMXData[(i*3)+2] = iGammaMap[round(green(cDMX) * iDimmingFactor)];

      iDMXData[i*3+1] = iGammaMap[round(red(cDMX) * iDimmingFactor)];
      iDMXData[(i*3)+2] = iGammaMap[round(green(cDMX) * iDimmingFactor)];
      iDMXData[(i*3)+3] = iGammaMap[round(blue(cDMX) * iDimmingFactor)];
      
      noStroke();
      fill(iGammaMap[round(red(cDMX) * iDimmingFactor)], iGammaMap[round(green(cDMX) * iDimmingFactor)], iGammaMap[round(blue(cDMX) * iDimmingFactor)]);
      rect(i*24, iCaptureHeight, 16, 16);
    }
  }
  if (bFloodLightsEnabled) {
    dmx.set(0, iDMXData);
  }
}

PImage getScreen() {
  Rectangle bounds = new Rectangle(frame.getLocation().x, frame.getLocation().y-height-30, width, iCaptureHeight);
  try {
    desktop = new Robot(gs[0]).createScreenCapture(bounds);
  }
  catch(AWTException e) {
  }
  return (new PImage(desktop));
}
