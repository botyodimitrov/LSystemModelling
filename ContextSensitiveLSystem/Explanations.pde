//press 'e' key to create L-System generations
//*************************************************
//based on Dan Shiffman's L-System work in Processing and "The Nature of Code"
//context branch search algorithm developed by Botyo Dimitrov
//according to 'The Algorithmic Beauty of Plants'
//additional use of Regular Expressions was necessary
//*************************************************
//contents:
//1: Explanation of concept of context and types of signals
//2. Set of predefined rules
//*************************************************



//*************************************************
//1. Signal type and transimssion. Algorithm
//*************************************************
//basipetal - up->down signal
//basipetal signal propagates only in the same hierarchical level
//if looking forward, if we are in a branch and the get to ']', then that is the end 
//of the branch
//so no context further applies

//acropetal - down->up signal
//if looking backward we have to consider the branch we are in
//basipetal signals transmit only within the current branch
//for instance if we have:
//F[f][f]F - that is a trunk FF with two branches f and f, the context of the
//last F is the first F, and none of the branches
//so if the previous char is ']', that indicates another branch 
//and we have to skip it go to its end e.g. '['
//However, if have nested branches like F[f[ff[f]f]][f]F, it is a bit more difficult
//In that case we have have to count the level (hierarchy)
//we start from the last F and look back:
//there is a ']' -> level++
//skip
//there is a '[' -> level-- (any context on level 0 will be valid)
//there is a ']' -> level++ (level = 1)
//there is a ']' -> level++ (level = 2)
//skip (invalid context)
//there is a ']' -> level++ (level = 3)
//skip (invalid context)
//there is a '[' -> level-- (level = 2)
//........
//continue until level == 0
//the first char in level 0 is a valid acropetal context



//*************************************************
//2.Set of predefined Rules
//*************************************************
//rule template (leftcontext, current char, rightcontext, replacement)
//a 
// axiom F1F1F1 angle 0.33 height 0.009 29
//ruleset [0] = new Rule("0", '0', "0", "0");
//ruleset [1] = new Rule("0", '0', "1", "1[+F1F1]");  
//ruleset [2] = new Rule("0", '1', "0", "1");
//ruleset [3] = new Rule("0", '1', "1", "1");
//ruleset [4] = new Rule("1", '0', "0", "0");
//ruleset [5] = new Rule("1", '0', "1", "1F1");
//ruleset [6] = new Rule("1", '1', "0", "0");
//ruleset [7] = new Rule("1", '1', "1", "0");
//ruleset [8] = new Rule(".", '+', ".", "-"); //always
//ruleset [9] = new Rule(".", '-', ".", "+"); //always

//b
//axiom F1F1F1 0.015*height angle 0.33; 30 iterations
//ruleset [0] = new Rule("0", '0', "0", "1");
//ruleset [1] = new Rule("0", '0', "1", "1[-F1F1]");  
//ruleset [2] = new Rule("0", '1', "0", "1");
//ruleset [3] = new Rule("0", '1', "1", "1");
//ruleset [4] = new Rule("1", '0', "0", "0");
//ruleset [5] = new Rule("1", '0', "1", "1F1");
//ruleset [6] = new Rule("1", '1', "0", "1");
//ruleset [7] = new Rule("1", '1', "1", "0");
//ruleset [8] = new Rule(".", '+', ".", "-"); 
//ruleset [9] = new Rule(".", '-', ".", "+");

//c
// axiom F1F1F1 0.015*height; angle 0.44; 26 iterations
//ruleset [0] = new Rule("0", '0', "0", "0");
//ruleset [1] = new Rule("0", '0', "1", "1");  
//ruleset [2] = new Rule("0", '1', "0", "0");
//ruleset [3] = new Rule("0", '1', "1", "1[+F1F1]"); //0[+F0F1]
//ruleset [4] = new Rule("1", '0', "0", "0");
//ruleset [5] = new Rule("1", '0', "1", "1F1"); //"0F0"
//ruleset [6] = new Rule("1", '1', "0", "0");
//ruleset [7] = new Rule("1", '1', "1", "0");
//ruleset [8] = new Rule(".", '+', ".", "-"); 
//ruleset [9] = new Rule(".", '-', ".", "+");

//d
//axiom F0F1F1 0.004*height 0.44 angle; 24 iterations
//ruleset [0] = new Rule("0", '0', "0", "1");
//ruleset [1] = new Rule("0", '0', "1", "0");  //matching patterns/ regex
//ruleset [2] = new Rule("0", '1', "0", "0");
//ruleset [3] = new Rule("0", '1', "1", "1F1");
//ruleset [4] = new Rule("1", '0', "0", "1");
//ruleset [5] = new Rule("1", '0', "1", "1[+F1F1]");
//ruleset [6] = new Rule("1", '1', "0", "1");
//ruleset [7] = new Rule("1", '1', "1", "0");
//ruleset [8] = new Rule(".", '+', ".", "-"); //always
//ruleset [9] = new Rule(".", '-', ".", "+"); 

//e
// axiom F1F1F1 0.009*height; 0.40 angle; 30 iterations
//ruleset [0] = new Rule("0", '0', "0", "0");
//ruleset [1] = new Rule("0", '0', "1", "1[-F1F1]");  //matching patterns/ regex
//ruleset [2] = new Rule("0", '1', "0", "1");
//ruleset [3] = new Rule("0", '1', "1", "1");
//ruleset [4] = new Rule("1", '0', "0", "0");
//ruleset [5] = new Rule("1", '0', "1", "1F1");
//ruleset [6] = new Rule("1", '1', "0", "1");
//ruleset [7] = new Rule("1", '1', "1", "0");
//ruleset [8] = new Rule(".", '+', ".", "-"); //always
//ruleset [9] = new Rule(".", '-', ".", "+"); 

//debugging axioms - not growing
//ruleset [0] = new Rule("0", '0', "1", "1");
////axiom F0[F0]F0F0[F1[F1]]F1F0[F0[F[F0]F0F0[F1]F0]F1
////axiom F0F1F0F0F0[F0F1]
