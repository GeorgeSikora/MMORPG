String[] lines;
void nagenerovatMapu() {
  lines = loadStrings("map.qmap");
  linesLength = lines.length;
  for(line = 0;line < lines.length; line ++) {
    String[] pieces = split(lines[line], ' ');
      int x = int(pieces[0]);
      int y = int(pieces[1]);
      int id = int(pieces[2]);
      int layer = int(pieces[3]);
      tiles.add( new Tile(id, layer, x*32, y*32));
  }
  room = 1;
 /* for (int a = -250; a < 500; a++) {
    int t = 10;
    int bac;
    for (int b = -250; b < 500; b++) {
      bac = -1;
      if (t == 35) {
        t = 45;
        bac = 10;
      } else {
        t = 10;
      }
      int r = int(random(50));
      if (t!=35 && t!=45) {
        if (r == 0 || r == 1 || r == 2 || r == 3) {
          t = 35;
          bac = 10;
        }
        if(r == 4){
          t = 21;
          bac = 10;
        }
      }
      tiles.add( new Tile(t, bac, a*32, b*32));
    }
  }*/
}