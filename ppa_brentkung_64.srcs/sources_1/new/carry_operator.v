`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 02:51:17 AM
// Design Name: 
// Module Name: carry_operator
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

// black cell: pg outputs, grey cell: g output only
module carry_operator #(
    parameter cell_type = 1
)(
    input [1:0] p, g,       // g'', p'', g', p'
    output p_out, g_out
    );
    generate
        if (cell_type) begin: black_cell
            assign p_out = &p;
            assign g_out = g[1]|(p[1]&g[0]);
        end
        else begin: grey_cell
            assign p_out = 1'b0;
            assign g_out = g[1]|(p[1]&g[0]);
        end
    endgenerate
endmodule
