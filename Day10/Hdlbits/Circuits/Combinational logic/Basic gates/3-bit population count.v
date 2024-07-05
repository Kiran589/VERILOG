module top_module( 
    input [2:0] in,
    output [1:0] out );
    reg [1:0] counter;
 integer i; // Loop variable

    always @(*) begin
        counter = 0; // Initialize the counter
        for (i = 0; i < 3; i = i + 1) begin
            if (in[i] == 1'b1)
                counter = counter + 1'b1; // Increment the counter for each '1'
        end
        out = counter; // Assign the count to the output
    end
endmodule
