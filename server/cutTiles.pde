void cutTiles() {
  tileset = loadImage("tiles.png");
  tile = new PImage[tileset.width/16*tileset.height/16];

  //** cut the tiles **\\
  int x = 0, y = 0;
  for (int i = 0; i < tile.length; i++) {
    tile[i] = tileset.get(x*16, y*16, 16, 16);
    x++;
    if (x >= tileset.width/16) {
      x=0;
      y++;
    }
  }
}