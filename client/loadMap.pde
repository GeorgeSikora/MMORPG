String[] lines;
void nagenerovatMapu() {
  //lines = loadStrings(myIP + "/map.qmap");
  lines = loadStrings("http://"+ IP +"/map.qmap");
  linesLength = lines.length;
  for (line = 0; line < lines.length; line ++) {
    String[] pieces = split(lines[line], ' ');
    int x = int(pieces[0]);
    int y = int(pieces[1]);
    int id = int(pieces[2]);
    int layer = int(pieces[3]);
    tiles.add( new Tile(id, layer, x*32, y*32));
  }
  room = 1;
}