module asyn_fifo_tb;

  // Parameters
  parameter data_width = 8;
  parameter fifo_depth = 8;
  parameter adress_size = 4;
  
  // Clock and reset
  reg wr_clk;
  reg rd_clk;
  reg rst;

  // FIFO control signals
  reg wr;
  reg rd;
  
  // Data signals
  reg  [data_width-1:0] wdata;
  wire [data_width-1:0] rdata;
  wire full;
  wire empty;
  wire valid;
  wire overflow;
  wire underflow;
  
  // Instantiate the FIFO
  asyn_fifo #(data_width, fifo_depth, adress_size) fifo (
      .wr_clk(wr_clk),
      .rd_clk(rd_clk),
      .rst(rst),
      .wr(wr),
      .rd(rd),
      .wdata(wdata),
      .rdata(rdata),
      .full(full),
      .empty(empty),
      .valid(valid),
      .overflow(overflow),
      .underflow(underflow)
  );

  // Clock generation
  always #5 wr_clk = ~wr_clk;  // Write clock toggles every 5 time units
  always #7 rd_clk = ~rd_clk;  // Read clock toggles every 7 time units

  // Test procedure
  initial begin
    // Initialize signals
    wr_clk = 0;
    rd_clk = 0;
    rst = 1;
    wr = 0;
    rd = 0;
    wdata = 0;
    
    // Reset the FIFO
    #10 rst = 0;  // De-assert reset after 10 time units
    
    // Write some data into FIFO
    #10 wr = 1;
    wdata = 8'hA5;  // Write 0xA5
    #10 wdata = 8'h5A;  // Write 0x5A
    #10 wdata = 8'h3C;  // Write 0x3C
    #10 wr = 0;  // Stop writing
    
    // Start reading data from FIFO
    #40 rd = 1;
    #30 rd = 0;  // Stop reading
    
    // End of simulation
    #100 $finish;
  end

  // Monitor the FIFO signals and states
  initial begin
    $monitor("Time=%0t | wr_clk=%b | rd_clk=%b | rst=%b | wr=%b | rd=%b | wdata=%h | rdata=%h | full=%b | empty=%b | valid=%b | overflow=%b | underflow=%b | wr_pointer=%d | rd_pointer=%d | wr_pntr_g=%b | rd_pntr_g=%b",
             $time, wr_clk, rd_clk, rst, wr, rd, wdata, rdata, full, empty, valid, overflow, underflow, fifo.wr_pointer, fifo.rd_pointer, fifo.wr_pntr_g, fifo.rd_pntr_g);
  end

endmodule
