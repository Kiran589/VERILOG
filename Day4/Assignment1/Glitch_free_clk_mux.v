module clock_mux(
    input wire pclk_62_5mhz,
    input wire pclk_250mhz,
    input wire [1:0] rate,
    output reg pclk
);

always @(*) begin
    case(rate)
        2'b00: pclk = pclk_62_5mhz;
        2'b10: pclk = pclk_250mhz;
        default: pclk = 1'b0; // Default case to avoid latches
    endcase
end

endmodule

