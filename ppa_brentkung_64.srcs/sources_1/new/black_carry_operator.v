`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 03:52:53 AM
// Design Name: 
// Module Name: black_carry_operator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// black cell: pg outputs
module black_carry_operator (
    input [1:0] p, g,           // g'', p'', g', p'
    output P, G
);

    assign P = &p;
    assign G = g[1] | (p[1] & g[0]);

endmodule
