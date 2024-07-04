`timescale 1ns / 1ps

module clock_mux_tb;

// Inputs
reg pclk_62_5mhz;
reg pclk_250mhz;
reg [1:0] rate;

wire pclk;

clock_mux uut (
    .pclk_62_5mhz(pclk_62_5mhz), 
    .pclk_250mhz(pclk_250mhz), 
    .rate(rate), 
    .pclk(pclk)
);

initial begin
    pclk_62_5mhz = 0;
    pclk_250mhz = 0;
    rate = 2'b00;
    #100
    forever #8 pclk_62_5mhz = ~pclk_62_5mhz; 
    forever #2 pclk_250mhz = ~pclk_250mhz; 
    
end

initial begin
    #200; 
    rate = 2'b00; 
    #100;
    rate = 2'b10; 
    #100;
     #2000 $stop; 
end
  initial begin
    $dumpfile("clock_mux.vcd");
    $dumpvars();
  end
endmodule
