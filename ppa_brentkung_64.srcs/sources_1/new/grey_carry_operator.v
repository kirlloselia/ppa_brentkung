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

// grey cell: g output only
module grey_carry_operator (
    input p,                 // p''
    input [1:0] g,           // g'', g'
    output G
);

    assign G = g[1] | (p & g[0]);

endmodule
