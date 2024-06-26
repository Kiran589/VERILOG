module tb;

  reg [31:0] din;
  reg [9:0] addr;
 reg clk ,we;

  wire [31:0] dout;

  simple_ram ins (clk,we,addr,din,dout);
initial begin

  din  = 8'h0;

  addr  = 8'h0;

  we = 1'b0;

  clk  = 1'b0;

  #100;

  din  = 8'h0;

  addr  = 8'h0;

  we  = 1'b1;

  #20;

  din  = 8'h0;

  addr  = 8'h0;

  #20;

  din  = 8'h1;

  addr  = 8'h1;

  #20;

  din = 8'h10;

  addr  = 8'h2;

  #20;

  din  = 8'h6;

  addr  = 8'h3;

  #20;

  din = 8'h12;

  addr  = 8'h4;

  #40;

  addr  = 8'h0;

  we = 1'b0;

  #20;
  addr   = 8'h1;
  #20;
  addr   = 8'h2;
  #20;
  addr   = 8'h3;
  #20;
  addr   = 8'h4;
 end
 always #10 clk = ~clk;
   initial begin
     $dumpfile("simple_ram.vcd");
    $dumpvars();
     $monitor("clk=%0d,we=%0d,addr=%0d,din=%0d,dout=%0d",clk,we,addr,din,dout);
    #500 $finish;
  end
endmodule
