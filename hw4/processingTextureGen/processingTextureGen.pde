void setup() {
  size(512,512);
  
  loadPixels();
  for (int i = 0; i < pixels.length; i++) {
    int col = int(random(255));
    pixels[i] = color(col, col, col);
  }
  updatePixels();
  save("rando.png");
  
  
  
}

void draw() {
}


