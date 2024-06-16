module demux_1_4(
 input [1:0] sel,
 input i,
 output reg y0,y1,y2,y3);
 
 always @(*) begin
 case(sel)
 2'h0: {y0,y1,y2,y3} = {i,3'b0};
 2'h1: {y0,y1,y2,y3} = {1'b0,i,2'b0};
 2'h2: {y0,y1,y2,y3} = {2'b0,i,1'b0};
 2'h3: {y0,y1,y2,y3} = {3'b0,i};
 default: $display("Invalid sel input");
 endcase
 end
endmodule
