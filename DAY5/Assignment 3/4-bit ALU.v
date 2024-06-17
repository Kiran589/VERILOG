module alu_4bit(
    input [3:0] a,
    input [3:0] b,
    input [2:0] sel,
    output reg [3:0] result
);

always @(*) begin
    case(sel)
        3'b000: result = a + b; // Addition
        3'b001: result = a - b; // Subtraction
        3'b010: result = a / b; // Division
        3'b011: result = (a && b); // Logical AND (Note: This will give either 1 or 0)
        3'b100: result = a & b; // Bitwise AND
        3'b101: result = a | b; // Bitwise OR
        3'b110: result = ~(a & b); // Bitwise NAND
        3'b111: result = ~(a ^ b); // Bitwise XNOR
        default: result = 4'bxxxx; // Undefined operation
    endcase
end

endmodule
