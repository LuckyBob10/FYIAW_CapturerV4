import java.awt.image.BufferedImage;
import java.awt.*;
OPC opc;

PImage screenShot;
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
  DisplayMode mode = gs[0].getDisplayMode();
  //Rectangle bounds = new Rectangle(0, 0, 240, 200);
  
  BufferedImage desktop = new BufferedImage(mode.getWidth(), mode.getHeight(), BufferedImage.TYPE_INT_RGB);

void setup() {
  size(480, 192);
  int spacing = height/16;
  if (frame != null) {
    //frame.setResizable(true);
    frame.setAlwaysOnTop(true);
  }
  frameRate(60);
  
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

void draw () {
  screenShot = getScreen();
  image(screenShot,0,0, width, height);
  //filter(BLUR, 2);
  
  frame.setTitle("FYIAW Capturer - " + int(frameRate) + " fps");
}

PImage getScreen() {
  Rectangle bounds = new Rectangle(frame.getLocation().x, frame.getLocation().y-height-30, width, height);
  try {
    desktop = new Robot(gs[0]).createScreenCapture(bounds);
  }
  catch(AWTException e) {
  }
  return (new PImage(desktop));
}
