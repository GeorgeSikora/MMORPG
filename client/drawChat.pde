String[] informace = new String[6];

void vykresleniInformaci() {
  textAlign(BOTTOM);
  textSize(18);
  for (int i = informace.length-1; i > -1; i--) {
    if (informace[i]!=null) {
      fill(255);
      text(informace[i], -width/2+5, height/2-30-(i*19));
    }
  }
}

void pridatInformaci(String str) {
  for (int i = informace.length-1; i > -1; i--) {
    if (i!=0) {
      informace[i]=informace[i-1];
    }
  }
  informace[0] = str;
}