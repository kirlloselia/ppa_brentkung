`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2026 04:46:32 AM
// Design Name: 
// Module Name: gp_logic
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


module gp_logic #(
    parameter N = 64
)(
    input [N-1:0] x, y,
    output [N-1:0] g, p
    );
    assign g = x&y;
    assign p = x^y;
endmodule
