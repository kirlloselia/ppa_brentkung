`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 05:16:45 AM
// Design Name: 
// Module Name: bk_expansion_stage
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

// in expansion stage we dont need all p, but half of them.
// also we use grey carry operator
module bk_expansion_stage #(
    parameter N = 2
)(
    p, g, G
    );
    localparam NDIV2 = N >> 1;
    input [NDIV2-1:0] p;
    input [N-1:0] g;
    output [NDIV2-1:0] G;
    
    genvar i;
    generate
        for (i = 0; i < NDIV2; i = i+1) begin: grey_carry_op
            grey_carry_operator op (.p(p[i]), .g(g[2*i+1:2*i]), .G(G[i])); 
        end
    endgenerate
endmodule
