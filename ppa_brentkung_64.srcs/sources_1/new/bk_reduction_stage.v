`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 04:27:43 AM
// Design Name: 
// Module Name: bk_reduction_stage
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

module bk_reduction_stage #(
    parameter N = 64
)(
    p, g, P, G
    );
    localparam NDIV2 = N >> 1;
    input [N-1:1] p;
    // input [N-1:0] p;
    input [N-1:0] g;
    localparam P_BUSWIDTH = N > 2 ? NDIV2-1 : 1;
    output [P_BUSWIDTH:1] P;
    output [NDIV2-1:0] G;
    
    grey_carry_operator op0 (.p(p[1]), .g(g[1:0]), .G(G[0])); 
    genvar i;
    generate
        for (i = 1; i < NDIV2; i = i+1) begin: black_carry_op
            black_carry_operator op (.p(p[2*i+1:2*i]), .g(g[2*i+1:2*i]), .P(P[i]), .G(G[i])); 
        end
    endgenerate
endmodule
