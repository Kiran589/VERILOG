`include "simple_ram.v"
module apb_ram_interface
#(
    parameter DATA_WIDTH = 32,       // Number of bits in each word
    parameter ADDR_WIDTH = 10        // Number of bits for the address (2^10 = 1024 locations)
)
(
    input wire PCLK,                 // APB clock
    input wire PSEL,                 // APB select
    input wire PENABLE,              // APB enable
    input wire PWRITE,               // APB write enable
    input wire [ADDR_WIDTH-1:0] PADDR, // APB address bus
    input wire [DATA_WIDTH-1:0] PWDATA, // APB write data bus
    output reg [DATA_WIDTH-1:0] PRDATA, // APB read data bus
    output reg PREADY,               // APB ready signal
    output reg PSLVERR               // APB slave error signal
);

    // Internal signals
    reg we;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;

    // Instantiate the RAM module
    simple_ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    )
          ram_inst (
        .clk(PCLK),
        .we(we),
        .addr(PADDR),
        .din(din),
        .dout(dout)
    );

    // APB operation
    always @(posedge PCLK) begin
        if (PSEL && PENABLE) begin
            PREADY <= 1;
            PSLVERR <= 0;

            if (PWRITE) begin
                // Write operation
                we <= 1;
                din <= PWDATA;
            end else begin
                // Read operation
                we <= 0;
                PRDATA <= dout;
            end
        end else begin
            PREADY <= 0;
            PSLVERR <= 0;
            we <= 0;
        end
    end

endmodule
