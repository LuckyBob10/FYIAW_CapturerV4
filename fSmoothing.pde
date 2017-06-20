color SmoothColor(int x, int y, int DMXFixture) {
  if (iSmoothAmount == 0) {
    return color(get(x,y));
  }
  color cTemp = color(128, 128, 128);
  int rAvg = 0, gAvg = 0, bAvg = 0;
  cTemp = get(x, y);
  cDMXHistory[iDMXHistoryPos][DMXFixture][0] = int(red(cTemp));
  cDMXHistory[iDMXHistoryPos][DMXFixture][1] = int(green(cTemp));
  cDMXHistory[iDMXHistoryPos][DMXFixture][2] = int(blue(cTemp));
  iDMXHistoryPos++;
  if (iDMXHistoryPos >= iSmoothAmount || iDMXHistoryPos > 60) {
    iDMXHistoryPos = 0;
  }
  for (int i=0; i<iSmoothAmount; i++) {
    rAvg += cDMXHistory[i][DMXFixture][0];
    gAvg += cDMXHistory[i][DMXFixture][1];
    bAvg += cDMXHistory[i][DMXFixture][2];
  }
  return color(rAvg/iSmoothAmount, gAvg/iSmoothAmount, bAvg/iSmoothAmount);
}

//TODO: Fix smooth amount changes?
