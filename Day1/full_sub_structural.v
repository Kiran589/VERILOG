module Xor(input a,b, output y);
  assign y= a^b;
endmodule

module And(input a,b, output z);
  assign z= ~a&b;
endmodule

module half_sub(input a,b, output diff, borr);
  Xor dif( a,b,diff);
  And bor( a,b,borr);
endmodule 

module full_sub(input a,b,bin, output differ, borro);
  wire s,c0,c1;
  half_sub su1(a,b,s,c0);
  half_sub su2(s,bin,differ,c1);
  
  assign borro= c1 | c0;
endmodule
