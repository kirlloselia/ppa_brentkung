`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2026 04:24:44 AM
// Design Name: 
// Module Name: ppa_brentkung
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


module ppa_brentkung #(
    parameter N = 64
)(
    input [N-1:0] x, y,
    input Cin,
    output [N-1:0] s,
    output Cout
    );
    wire [N-1:0] g, p, c;
    gp_logic #(.N(N)) gp_logic_inst (.x(x), .y(y), .g(g), .p(p));
    sum_logic #(.N(N)) sum_logic_inst (.c(c), .p(p), .s(s));
    wire [N-1:0] c_network;
    bk_prefix_tree #(.N(N)) bk_prefix_tree_inst (.g(g), .p(p), .Cin(Cin), .C(c_network));
    assign Cout = c_network[N-1];
    assign c = {c_network[N-2:0], Cin};  // Concatenate, not slice assignment
endmodule

