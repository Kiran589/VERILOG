module mux_example_1(
 input [1:0] sel,
 input i0,i1,i2,i3,
 output reg y);
 
 always @(*) begin
 case(sel)
 2'b00: y = i0;
 2'b01: y = i1;
 2'b10: y = i2;
 2'b11: y = i3;
 default: $display("Invalid sel input");
 endcase
 end
endmodule
