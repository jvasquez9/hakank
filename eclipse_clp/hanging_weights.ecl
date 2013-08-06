/*

  Hanging weights problem in ECLiPSe.

  From 
  "Using LINQ to solve puzzles"
  http://blogs.msdn.com/lukeh/archive/2007/03/19/using-linq-to-solve-puzzles.aspx
  """
  Here's a puzzle similar to the one in the puzzle hunt.  The diagram 
  below is a bunch of weights (A-M) hanging from a system of bars.  
  Each weight has an integer value between 1 and 13, and the goal is 
  to figure out what each weight must be for the the diagram below to 
  balance correctly as shown: 

                           |
                           |
               +--+--+--+--+--+--+--+
               |                    |
               |                    |
            +--+--+--+--+--+        |
            |     L        M        |
            |                       |
   +--+--+--+--+--+--+     +--+--+--+--+--+
   H              |  I     |  J        K  |
                  |        |              |
         +--+--+--+--+--+  |     +--+--+--+--+--+
         E              F  |     G              |
                           |                    |
               +--+--+--+--+--+  +--+--+--+--+--+--+
               A              B  C                 D

  The rules for this kind of puzzle are: 
  (1) The weights on either side of a given pivot point must be equal, 
      when weighted by the distance from the pivot, and 
  (2) a bar hanging beneath another contributes it's total weight as 
      through it were a single weight.  For instance, the bar on the bottom 
      right must have 5*C=D, and the one above it must have 3*G=2*(C+D).
  """

  Compare with the MiniZinc model:
  - http://www.hakank.org/minizinc/hanging_weights.mzn
  

  Model created by Hakan Kjellerstrand, hakank@bonetmail.com
  See also my ECLiPSe page: http://www.hakank.org/eclipse/

*/

:-lib(ic).

go :-
   findall([All, Total, Backtracks], hanging_weights(All,Total, Backtracks), Result),
   ( foreach([All, Total, Backtracks], Result) do
         writeln(total:Total),
         writeln(all:All), 
         writeln(backtracks:Backtracks)
   ).

hanging_weights(All, Total, Backtracks) :-

        All = [A,B,C,D,E,F,G,H,I,J,K,L,M],
        All :: 1..13,

        alldifferent(All),
        Total #= sum(All),
        
        4 * A #= B, 
        5 * C #= D, 
        3 * E #= 2 * F, 
        3 * G #= 2 * (C + D), 
        3 * (A + B) + 2 * J #= K + 2 * (G + C + D), 
        3 * H #= 2 * (E + F) + 3 * I, 
        (H + I + E + F) #= L + 4 * M, 
        4 * (L + M + H + I + E + F) #= 3 * (J + K + G + A + B + C + D),

        term_variables([All,Total], Vars),
        search(Vars,0, first_fail, indomain_min, complete, [backtrack(Backtracks)] ).
        