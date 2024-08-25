module asyn_fifo (wr_clk,rd_clk,rst,wr,rd,wdata,rdata,valid,empty,full,overflow,underflow);
  
  parameter data_width=8;
  input wr_clk;
  input rd_clk;
  input rst;
  input [data_width-1:0] wdata;
  input wr;
  input rd;
  
  output reg [data_width-1:0] rdata;
  output full;
  output empty;
  output reg valid;
  output reg overflow;
  output reg underflow;
  
  parameter fifo_depth=8;
  parameter adress_size=4;
  
  reg [adress_size-1:0] wr_pointer,wr_pntr_g_s1,wr_pntr_g_s2;
  reg [adress_size-1:0] rd_pointer,rd_pntr_g_s1,rd_pntr_g_s2;
  
  wire [adress_size-1:0] wr_pntr_g;
  wire [adress_size-1:0] rd_pntr_g;
  
  // decalring 2darray
  reg [data_width-1:0] mem [fifo_depth-1:0];
  
  // writing data into FIFO 
  always @ (posedge wr_clk) begin 
    if(rst) wr_pointer<=0;
    else begin 
      if(wr && !full) begin
        wr_pointer<=wr_pointer+1;
        mem[wr_pointer]<=wdata;// write operation
      end
    end
  end
  
  // reading data into FIFO 
  always @ (posedge rd_clk) begin 
    if(rst) rd_pointer<=0;
    else begin 
      if(rd && !empty) begin
        rd_pointer<=rd_pointer+1;
        rdata<=mem[rd_pointer] ;// readoperation
      end
    end
  end
  
  // wr_pointer, rd_pointer binary to grey 
  assign wr_pntr_g= wr_pointer ^ (wr_pointer>>1);
  assign rd_pntr_g= rd_pointer ^ (rd_pointer>>1);
  
  // 2 stage synchronizer for wr_pointr wrt rd_clk
  
  always @ (posedge rd_clk) begin 
    if(rst) begin 
      wr_pntr_g_s1<=0;
      wr_pntr_g_s2<=0;
    end
    else begin 
      wr_pntr_g_s1<=wr_pntr_g; // 1ff
      wr_pntr_g_s2<=wr_pntr_g_s1;//1 ff
    end
  end
  // 2 stage synchronizer for rd_pointr wrt wr_clk
  always @ (posedge wr_clk) begin 
    if(rst) begin 
      rd_pntr_g_s1<=0;
      rd_pntr_g_s2<=0;
    end
    else begin 
      rd_pntr_g_s1<=rd_pntr_g; // 1ff
      rd_pntr_g_s2<=rd_pntr_g_s1;//1 ff
    end
  end
  
  // empty condition 
  assign empty= (rd_pntr_g==wr_pntr_g_s2);
  assign full =(wr_pntr_g[adress_size-1]!= rd_pntr_g_s2[adress_size-1])
               && (wr_pntr_g[adress_size-2]!= rd_pntr_g_s2[adress_size-2])
               && (wr_pntr_g[adress_size-3]== rd_pntr_g_s2[adress_size-3]);
  
  //overflow
  
  always @ (posedge wr_clk)  overflow<= full && wr;
  always @(posedge rd_clk) begin 
    underflow<= empty && rd;
    valid<= (rd && !empty);
    end
  
endmodule
