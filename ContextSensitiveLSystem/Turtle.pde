class Turtle {
  float decrement;
  float angle;
  float l;
  float t = 0;
  float strokeW;

  Turtle(float a, float d, float l_, float w) {
    angle = a;
    decrement = d;
    l=l_;
    strokeW = w;
  }
  void render(String current) {
    stroke(255);
    strokeWeight(strokeW);
    println("drawing ...");
    for (int i=0; i<current.length(); i++) {
      //float ang = noise(t);
      //ang = map(ang, 0, 1, angle-PI/15, angle+PI/15);
      float ang = angle ;
      char c = current.charAt(i);
      switch(c) {
        case ('F'):
        line(l, 0, 0, 0);
        translate(l, 0);
        break;
        case ('+'):
        rotate(-ang);
        break;
        case ('-'):
        rotate(ang);
        break;
        case ('f'):
        line(l, 0, 0, 0);
        translate(l, 0);
        break;
        case ('['):
        pushMatrix();
        break;
        case(']'):
        popMatrix();
        break;
        
      //  case ('E'):
        
      }
     // t+=.01;
    }

    l/=decrement;

  }
}