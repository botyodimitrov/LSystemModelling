class Rule {
  char a;
  String sentence;
  String leftContext; //context that allows the rule to be executed
  String rightContext;
  
  Rule(String leftContext_, char a_, String rightContext_, String s_) {
    a = a_;
    sentence = s_;
    leftContext = leftContext_;
    rightContext = rightContext_;
  }
  
  char getInitial() {
    return a;
  }
  
  String getReplacement() {
    return sentence;
  }
  
  String getLeftContext() {
   return leftContext;
  }
  
  String getRightContext() {
    return rightContext;
  }
}