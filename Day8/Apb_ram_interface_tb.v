module apb_ram_interface_tb;

    // Parameters
    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 10;

    // Signals
    reg PCLK;
    reg PSEL;
    reg PENABLE;
    reg PWRITE;
    reg [ADDR_WIDTH-1:0] PADDR;
    reg [DATA_WIDTH-1:0] PWDATA;
    wire [DATA_WIDTH-1:0] PRDATA;
    wire PREADY;
    wire PSLVERR;
 

    // Instantiate the APB RAM interface
    apb_ram_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) uut (
        .PCLK(PCLK),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );
    initial begin
	    $dumpfile("apb_ram_interface_tb.vcd");
      $dumpvars(0);
    end

    // Clock generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;  // 100MHz clock
    end

  task reset();
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
        PADDR = 0;
        PWDATA = 0;
     @(posedge PCLK);
    $display("time=%t,reset done",$time,);  
      endtask

  task write(input[ADDR_WIDTH-1:0]addr,input[DATA_WIDTH-1:0]datain);  
      @(posedge PCLK);
        PSEL = 1;
        PWRITE = 1;
        PADDR = addr;
        PWDATA = datain;
      @(posedge PCLK);
        PENABLE = 1;
      @(posedge PCLK);
   // if (PREADY) begin
        PSEL = 0;
        PENABLE = 0;
        PWRITE = 0;
      $display("write=%0d",PWDATA);
   // end
  endtask

  task read(input[ADDR_WIDTH-1:0]addr,output[DATA_WIDTH-1:0]dataout);
      @(posedge PCLK);
        PSEL = 1;
        PWRITE = 0;
        PADDR = addr;
      @(posedge PCLK);
        PENABLE = 1;
      @(posedge PCLK);
       if (PREADY) begin
            dataout = PRDATA;
            PSEL = 0;
            PENABLE = 0;
    $display("read=%0d",PRDATA);
       end
  endtask
  
  task run();
    reg [ADDR_WIDTH-1:0] Addr;
    reg [DATA_WIDTH-1:0] data_write;
    reg[DATA_WIDTH-1:0] data_read;
    integer i;
   
    for(i=0; i<=10 ;i=i+1)
    begin 
      
     Addr = $random % (2**ADDR_WIDTH);$display("Addr=%0d",Addr);
   data_write=$random;
      $display("data_write=%0d",data_write);
      write (Addr,data_write);
      
      
       @(posedge PCLK);
       @(posedge PCLK);
      read(Addr,data_read);
     
        if (data_read == data_write) begin
                    $display("Read operation successful at address %0d. Data: %0d", Addr, data_read);
                end else begin
                    $display("ERROR: Read data mismatch at address %0d. Expected: %0d, Got: %0d", Addr, data_write, data_read);
                end
    end
   #10 $finish;
  endtask  
    
    initial begin
      reset();
      run();
    end
      
        
       

endmodule
