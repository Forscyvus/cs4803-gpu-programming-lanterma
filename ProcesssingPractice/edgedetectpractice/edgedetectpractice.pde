PImage barca;
PImage edge;
void setup() {
  
  size(1280,720);
  barca = loadImage("hotel.jpg");
  edge = createImage(1280, 720, RGB);
  
  barca.loadPixels();
  for (int i = 0; i < barca.pixels.length; i++) {
    float c = .2126*red(barca.pixels[i]) + .7152*green(barca.pixels[i]) + .0722*blue(barca.pixels[i]);
    barca.pixels[i] = color(c, c, c);
  }
  barca.updatePixels();
  
  
  
  for (int i = 1; i < edge.width - 1; i++) {
    for (int j = 1; j < edge.height -1; j++) {
      float total = red(barca.get(i-1,j)) + red(barca.get(i+1, j)) + red(barca.get(i,j+1)) + red(barca.get(i,j-1));
      total -= 4*red(barca.get(i,j));
      total = abs(total);
//      if (total > 150) {
//         edge.set(i,j,color(255,255,255));
//      } else {
//        edge.set(i,j,color(0,0,0));
//      }
      if (total > 255) {
        print(total);
      }
      edge.set(i,j,color(total,total,total));
    }
  }
  
  
  
  
  
  
}

void draw() {
  
  image(edge,0,0);
  
}
