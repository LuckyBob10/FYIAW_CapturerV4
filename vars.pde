static byte DMX_PRO_MESSAGE_START = byte(0x7E);
static byte DMX_PRO_MESSAGE_END = byte(0xE7);
static byte DMX_PRO_SEND_PACKET = byte(6);

boolean
  bScreenEnabled = true,
  bControlPanelDrawn = false,
  bFloodLightsEnabled = false,
  bFixedColor = false,
  bLEDBoardEnabled = true,
  bDMXTest = false
;

float
  iDimmingFactor = 1,
  iSmoothAmount = 5,
  iLEDGamma = 2.5,
  iLEDBrightness = 1,
  iDMXEffectBias = .1
;

int
  iFrameRate = 80,
  iCaptureWidth = 480,
  iCaptureHeight = 200,
  iInitialX = 4,
  iInitialY = 266,
  iDMXFixtureCount = 14,
  iDMXHistoryPos = 0,
  universeSize = iDMXFixtureCount * 3,
  iInitialPositionSet = 0,
  iDMXLocationIndex = 1,
  iDMXLocations[][] = {
    {1,1, 10,10, 50,50, 60,60, 65,65, 78,78, 100,100, 120,120, 130,130, 135,135, 150,150, 175,175, 185,185, 190,190},
    {30,96, 60,96, 90,96, 120,96, 150,96, 180,96, 210,96, 230,96, 260,96, 290,96, 320,96, 350,96, 380,96, 410,96},
    {120,96, 240,96, 240,128, 240,64, 320,128, 320,96, 96,96, 64,64, 64,128, 416,64, 352,96, 416,128, 150,96, 290,96}
  },
  iDMXMessageLength = 0,
  iDMXTestChan = 0,
  iDMXTestColor = 0,
  iDMXTextLen = 333,
  iFixedColorR = 200,
  iFixedColorB = 200,
  iFixedColorG = 200,
  iLastMouseClick = millis(),
  iLastDMXTest = millis(),
  iBeatPixel = 0,
  iBeatPixelLast = 1,
  iDMXBeatCount = 0,
  iDMXBeatThreshold = 16, //Every four measures or so
  iDMXEffectCount = 2,
  iDMXLastEffect = 0
;

String
  cDMXLocationNames[] = {
    "Test",
    "Horizontal line",
    "FYIAW 2015"
  }
;

color cDMXHistory[][][] = new color[60][iDMXFixtureCount][3];

BufferedImage desktop = new BufferedImage(mode.getWidth(), iCaptureHeight, BufferedImage.TYPE_INT_RGB);

String DMXPRO_PORT = "COM8";
int DMXPRO_BAUDRATE = 115000;

int iGammaMap[] = {
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
    0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,
    1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,
    2,  3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  5,  5,  5,
    5,  6,  6,  6,  6,  7,  7,  7,  7,  8,  8,  8,  9,  9,  9, 10,
   10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16,
   17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 24, 24, 25,
   25, 26, 27, 27, 28, 29, 29, 30, 31, 32, 32, 33, 34, 35, 35, 36,
   37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 50,
   51, 52, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68,
   69, 70, 72, 73, 74, 75, 77, 78, 79, 81, 82, 83, 85, 86, 87, 89,
   90, 92, 93, 95, 96, 98, 99,101,102,104,105,107,109,110,112,114,
  115,117,119,120,122,124,126,127,129,131,133,135,137,138,140,142,
  144,146,148,150,152,154,156,158,160,162,164,167,169,171,173,175,
  177,180,182,184,186,189,191,193,196,198,200,203,205,208,210,213,
  215,218,220,223,225,228,231,233,236,239,241,244,247,249,252,255
};
