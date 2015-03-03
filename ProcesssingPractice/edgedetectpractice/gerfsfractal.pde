//I really should have written a complex number class... WHOOPS.

int SIZE = 600;
ArrayList<Float> origin;
ArrayList<Float> one;

void setup(){
  size(SIZE,SIZE);
  origin = new ArrayList<Float>();
  origin.add(0.0);
  origin.add(0.0);
  one = new ArrayList<Float>();
  one.add(1.0);
  one.add(0.0);
  noStroke();
}

void draw(){
  background(0,0,0);
  ArrayList<Float> mouseV = getV();
  ArrayList<ArrayList<Float>> points = generatePoints(mouseV);
  makeFractal( points, origin, 0, 0 );
  fill(255,255,255);
  text(mouseV.toString(),15,15);
}

ArrayList<Float> getV(){
  float x = (mouseX * (4.0 / SIZE)) - 2;
  float y = -((mouseY * (4.0 / SIZE)) - 2);
  ArrayList<Float> result = new ArrayList<Float>();
  result.add(x);
  result.add(y);
  return result;
}

void makeFractal(ArrayList<ArrayList<Float>> v, ArrayList<Float> running, int i, int c){
  if (i > 12){
    return;
  }
  ArrayList<Float> curr = v.get(i+1);
  ArrayList<Float> runningPlus = complexAdd(running, curr);
  ArrayList<Float> runningMinus = complexSubt(running, curr);
  makeFractal(v, runningPlus, i + 1, c + 25);
  makeFractal(v, runningMinus, i + 1, c + 25);
  drawPoint(running, c, i);

  return;
}

void drawPoint(ArrayList<Float> point, int c, int i){
  fill(280-(c/.85),150-(c),-100+(c));
  ellipse(toScreen(point.get(0)), toScreen(point.get(1)), 10 - (i/1.5), 10 - (i/1.5));
}

float toScreen(float x){
  return ( (x + 3) * (SIZE / 6.0) );
}

ArrayList<ArrayList<Float>> generatePoints( ArrayList<Float> V ){
  
  ArrayList<ArrayList<Float>> points = new ArrayList<ArrayList<Float>>();
  
  points.add(origin);
  points.add(one);
  for (int i = 0; i < 12; i++){
    points.add(complexMult(V, points.get(i+1)));
  }
  return points;
}

ArrayList<Float> complexMult(ArrayList<Float> A, ArrayList<Float> B){
  ArrayList<Float> result = new ArrayList<Float>();
  result.add( (A.get(0) * B.get(0)) - (A.get(1) * B.get(1)) );
  result.add( (A.get(0) * B.get(1)) + (A.get(1) * B.get(0)) );
  return result;
}

ArrayList<Float> complexAdd(ArrayList<Float> A, ArrayList<Float> B){
  ArrayList<Float> result = new ArrayList<Float>();
  result.add( A.get(0)+B.get(0) );
  result.add( A.get(1)+B.get(1) );
  return result;
}

ArrayList<Float> complexSubt(ArrayList<Float> A, ArrayList<Float> B){
  ArrayList<Float> result = new ArrayList<Float>();
  result.add( A.get(0) - B.get(0) );
  result.add( A.get(1) - B.get(1) );
  return result;
}

