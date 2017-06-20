public class PFrame extends Frame {
  public PFrame() {
    setBounds(510,0,150,355);
    sControl = new secondApplet();
    add(sControl);
    sControl.init();
    show();
  }
}

public class secondApplet extends PApplet {
  public void setup() {
    size(150, 355);
    noLoop();
  }
  
  public void draw() {

  }
}

void DrawControlPanel() {
  bControlPanelDrawn = true;
  sControl.background(0);
  sControl.fill(255);
  sControl.stroke(255);
  sControl.textSize(14);
  sControl.text("FYIAW Capturer v3", 5, 15);
  sControl.line(0,20,200,20);
  sControl.textSize(12);
  
  sControl.text("FLOOD LIGHTS", 5, 40);
  sControl.text("Brightness", 5, 60);
  sControl.text("+ -", 75, 60);
  sControl.text("Smoothing", 5, 80);
  sControl.text("+ -", 75, 80);
  sControl.text("Fixed color:", 5, 100);
  sControl.fill(255,0,0);
  sControl.text("  Red", 5, 120);
  sControl.text("+ -", 75, 120);
  sControl.fill(0,255,0);
  sControl.text("  Green", 5, 140);
  sControl.text("+ -", 75, 140);
  sControl.fill(0,0,255);
  sControl.text("  Blue", 5, 160);
  sControl.text("+ -", 75, 160);
  
  if (bFloodLightsEnabled) {
    sControl.fill(0,255,0);
  }
  else {
    sControl.fill(255,0,0);
  }
  sControl.rect(115, 30, 10, 10);
  
  if (bFixedColor) {
    sControl.fill(0,255,0);
  }
  else {
    sControl.fill(255,0,0);
  }
  sControl.rect(115, 90, 10, 10);
  
  sControl.fill(255);
  sControl.text(round(100 * iDimmingFactor) + "%", 100, 60);
  sControl.text(round(iSmoothAmount), 105, 80);
  sControl.text(iFixedColorR, 105, 120);
  sControl.text(iFixedColorG, 105, 140);
  sControl.text(iFixedColorB, 105, 160);
  sControl.fill(iFixedColorR, iFixedColorG, iFixedColorB);
  sControl.rect(20, 170, 100, 10);
  
  sControl.fill(255);
  sControl.text("Pattern #" + iDMXLocationIndex, 5, 200);
  sControl.text(cDMXLocationNames[iDMXLocationIndex], 5, 220);
  sControl.text("+ -", 75, 200);
  
  sControl.text("LED BOARD", 5, 260);
  if (bLEDBoardEnabled) {
    sControl.fill(0,255,0);
  }
  else {
    sControl.fill(255,0,0);
  }
  sControl.rect(115, 250, 10, 10);
  sControl.fill(255);
  sControl.text("Brightness", 5, 280);
  sControl.text("+ -", 75, 280);
  sControl.text(round(100 * iLEDBrightness) + "%", 100, 280);
  
  sControl.text("DMX Test", 5, 310);
  if (bDMXTest) {
    sControl.fill(0,255,0);
  }
  else {
    sControl.fill(255,0,0);
  }
  sControl.rect(115, 300, 10, 10);
  
  sControl.redraw();
}


void ControlMouseTest() {
  //Buttons
  if (sControl.mouseX > 115 && sControl.mouseX < 125) {
    if (sControl.mouseY > 30 && sControl.mouseY < 40) {
      bFloodLightsEnabled = !bFloodLightsEnabled;
    }
    else if (sControl.mouseY > 90 && sControl.mouseY < 100) {
      bFixedColor = !bFixedColor;
    }
    else if (sControl.mouseY > 250 && sControl.mouseY < 260) {
      bLEDBoardEnabled = !bLEDBoardEnabled;
      OPCUpdate();
    }
    else if (sControl.mouseY > 300 && sControl.mouseY < 310) {
      //DMX Test
      bDMXTest = !bDMXTest;
    }
  }
  
  //Plus
  if (sControl.mouseX > 75 && sControl.mouseX < 85) {
    if (sControl.mouseY > 50 && sControl.mouseY < 60) {
      //DMX Brightness
      iDimmingFactor = constrain(iDimmingFactor+.01, 0, 1);
    }
    else if (sControl.mouseY > 70 && sControl.mouseY < 80) {
      //Smoothing
      iSmoothAmount = constrain(iSmoothAmount+1, 0, 60);
    }
    else if (sControl.mouseY > 110 && sControl.mouseY < 120) {
      //Red
      iFixedColorR = constrain(iFixedColorR+5, 0, 255);
    }
    else if (sControl.mouseY > 130 && sControl.mouseY < 140) {
      //Green
      iFixedColorG = constrain(iFixedColorG+5, 0, 255);
    }
    else if (sControl.mouseY > 150 && sControl.mouseY < 160) {
      //Blue
      iFixedColorB = constrain(iFixedColorB+5, 0, 255);
    }
    else if (sControl.mouseY > 190 && sControl.mouseY < 200) {
      //Pattern
      iDMXLocationIndex = constrain(iDMXLocationIndex+1, 0, 2);
    }
    else if (sControl.mouseY > 270 && sControl.mouseY < 280) {
      //LED Brightness
      iLEDBrightness = constrain(iLEDBrightness+.01, 0, 1);
      OPCUpdate();
    }
  }
  
  //Minus
  if (sControl.mouseX > 85 && sControl.mouseX < 95) {
    if (sControl.mouseY > 50 && sControl.mouseY < 60) {
      //DMX Brightness
      iDimmingFactor = constrain(iDimmingFactor-.01, 0, 1);
    }
    else if (sControl.mouseY > 70 && sControl.mouseY < 80) {
      //Smoothing
      iSmoothAmount = constrain(iSmoothAmount-1, 0, 60);
    }
    else if (sControl.mouseY > 110 && sControl.mouseY < 120) {
      //Red
      iFixedColorR = constrain(iFixedColorR-5, 0, 255);
    }
    else if (sControl.mouseY > 130 && sControl.mouseY < 140) {
      //Green
      iFixedColorG = constrain(iFixedColorG-5, 0, 255);
    }
    else if (sControl.mouseY > 150 && sControl.mouseY < 160) {
      //Blue
      iFixedColorB = constrain(iFixedColorB-5, 0, 255);
    }
    else if (sControl.mouseY > 190 && sControl.mouseY < 200) {
      //Pattern
      iDMXLocationIndex = constrain(iDMXLocationIndex-1, 0, 2);
    }
    else if (sControl.mouseY > 270 && sControl.mouseY < 280) {
      //LED Brightness
      iLEDBrightness = constrain(iLEDBrightness-.01, 0, 1);
      OPCUpdate();
    }
  }
  
  
  DrawControlPanel();
  
  //println(sControl.mouseX + " " + sControl.mouseY);
}

void OPCUpdate() {
  if (bLEDBoardEnabled == false) {
    opc.setColorCorrection(iLEDGamma, 0, 0, 0);
  }
  else {
    opc.setColorCorrection(iLEDGamma, iLEDBrightness, iLEDBrightness, iLEDBrightness);
  }
}
