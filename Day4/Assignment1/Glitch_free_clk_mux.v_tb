`timescale 1ns / 1ps

module clock_mux_tb;

// Inputs
reg pclk_62_5mhz;
reg pclk_250mhz;
reg [1:0] rate;

// Output
wire pclk;

// Instantiate the Unit Under Test (UUT)
clock_mux uut (
    .pclk_62_5mhz(pclk_62_5mhz), 
    .pclk_250mhz(pclk_250mhz), 
    .rate(rate), 
    .pclk(pclk)
);

initial begin
    // Initialize Inputs
    pclk_62_5mhz = 0;
    pclk_250mhz = 0;
    rate = 2'b00;

    // Wait 100 ns for global reset to finish
    #100;
    
    // Add stimulus here
    forever #8 pclk_62_5mhz = ~pclk_62_5mhz; // Toggle every 8ns for 62.5MHz
    forever #2 pclk_250mhz = ~pclk_250mhz; // Toggle every 2ns for 250MHz
    
end

initial begin
    #200; // Wait for clocks to stabilize
    rate = 2'b00; // Select 62.5MHz clock
    #100;
    rate = 2'b10; // Select 250MHz clock
    #100;
     #2000 $stop; 
end
  initial begin
    $dumpfile("clock_mux.vcd");
    $dumpvars();
  end
endmodule
