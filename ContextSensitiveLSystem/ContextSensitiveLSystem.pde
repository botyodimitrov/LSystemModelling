//alphabet: A, B 
//axiom: F1F1F1
//rule 1: 0 < 0 > 0 -> 0
//rule 2: 0 < 0 > 1 -> 1[+F1F1]
//rule 3: 0 < 1 > 0 -> 1
//rule 4: 0 < 1 > 1 -> 1
//rule 5: 1 < 0 > 0 -> 0
//rule 6: 1 < 0 > 1 -> 1F1
//rule 7: 1 < 1 > 0 -> 0
//rule 8: 1 < 1 > 1 -> 0
//rule 9: * < + > * -> -
//rule 10: * < - > * -> +

import java.util.regex.Matcher;
import java.util.regex.Pattern;

Turtle turtle;
LSystem lsys;
Rule[] ruleset;
int iter;

void setup() {
  size(600, 600);
  ruleset = new Rule[10];
  //e
  // axiom F1F1F1 0.009*height; 0.40 angle; 30 iterations
  ruleset [0] = new Rule("0", '0', "0", "0");
  ruleset [1] = new Rule("0", '0', "1", "1[-F1F1]");  //matching patterns/ regex
  ruleset [2] = new Rule("0", '1', "0", "1");
  ruleset [3] = new Rule("0", '1', "1", "1");
  ruleset [4] = new Rule("1", '0', "0", "0");
  ruleset [5] = new Rule("1", '0', "1", "1F1");
  ruleset [6] = new Rule("1", '1', "0", "1");
  ruleset [7] = new Rule("1", '1', "1", "0");
  ruleset [8] = new Rule(".", '+', ".", "-"); //always
  ruleset [9] = new Rule(".", '-', ".", "+"); 
  lsys = new LSystem("F1F1F1"); // axiom  
  turtle = new Turtle(0.40, 1, 0.009*height, 1); 
  iter = 26; //number of rewriting iterations
  println(lsys.sentence);
}

void draw() {
  background(0);
  translate(0.5*width, 0.9*height);
  rotate(-PI/2);
  turtle.render(lsys.sentence);
  noLoop();
}

int count = 0;
void keyPressed() { 
  for ( int m = 0; m < 2; m++) {

    StringBuffer next = new StringBuffer();
    println(count++);

    next.append(lsys.sentence.charAt(0));
    for (int i = 1; i<lsys.sentence.length()-1; i++) { 
      char c = lsys.sentence.charAt(i); 
      char cPrev = lsys.sentence.charAt(i-1);
      char cNext = lsys.sentence.charAt(i+1);    

      String replace = Character.toString(c);
      String contextLeft = Character.toString(checkedChar(cPrev, i, -1)); //previous(left)
      String contextRight = Character.toString(checkedChar(cNext, i, 1)); //next(right)

      for (int j = 0; j < ruleset.length; j++) {
        Pattern pLeft = Pattern.compile(ruleset[j].getLeftContext());
        Pattern pRight = Pattern.compile(ruleset[j].getRightContext());
        Matcher mLeft = pLeft.matcher(contextLeft);
        Matcher mRight = pRight.matcher(contextRight);

        if (c == ruleset[j].getInitial() && mLeft.find() && mRight.find()) {
          replace = ruleset[j].getReplacement();
          //println("Rule " + j);
        }
      }

      next.append(replace);
    }
    next.append(lsys.sentence.charAt(lsys.sentence.length()-1));
    lsys.sentence = next.toString();
  }
  if (key == 'e') redraw();
  println(lsys.sentence);
  println();
}

//check the possible context characters until finding a valid char or reaching the string limits
char checkedChar(char checked, int i, int coef) { //i doesn't start at index 0! but 1
  int level = 0;
  int k = 1;
  
  //'checked' is already the first character checked
  //if it is already 1 or 0 we don't have to check next neighbors
  //otherwise, if it is an invalid context symbols we have to continue according to the rules
  //level > 0//the level can be lower because of the bottom-up signal case
  while (!(checked == '1' || checked == '0') || level > 0) { //checked == '+' || checked == '-' || checked == 'F' || checked == '[' || checked == ']'
    // boundary error handling - exit before going out of boundaries
    if (i+coef*k == 0 && coef<0) break; //previous - backward
    else if (i+coef*k == lsys.sentence.length()-1 && coef > 0) break; //next - forward
    k ++;
    //basipetal checking - the next character in the string
    //if (i == 2 && coef == 1) println("current: " + lsys.sentence.charAt(i)+ " right: " + checked +" level: " + level + " counter: " + k 
    // + " sec: " + lsys.sentence.charAt(k));

    if (coef == 1) {
      if (checked == '[') level++; // we are entering a child branch -> no context will be valid here
      else if (checked == ']' && level > 0) level--; //we are in a child branch -> continue until you find our level
      else if (checked == ']' && level <= 0) break;  //we have reached the end of our current branch -> exit
    }

    //acropetal checking - the previous character in the string
    if (coef == -1) {
      if (checked == ']') level++; // we are entering a child branch -> no valid context here
      else if (checked == '[' && level > 0) level--; // we are exiting a child branch 
      //always look for context in the same level or LOWER! just make sure we are not 
      //in a different branch from same or higher level
    }
    checked = lsys.sentence.charAt(i+coef*k);
  }
  return checked;
}