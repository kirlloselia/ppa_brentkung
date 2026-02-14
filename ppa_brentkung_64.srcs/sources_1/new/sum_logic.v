`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/09/2026 04:52:46 AM
// Design Name: 
// Module Name: sum_logic
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


module sum_logic#(
    parameter N = 64
)(
    input [N-1:0] c, p,
    output [N-1:0] s
    );
    assign s = c ^ p;
endmodule
