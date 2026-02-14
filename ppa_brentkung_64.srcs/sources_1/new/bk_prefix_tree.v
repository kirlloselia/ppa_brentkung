`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2026 03:23:03 AM
// Design Name: 
// Module Name: bk_prefix_tree
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

// carry network
module bk_prefix_tree #(
    parameter N = 16
)(
    input [N-1:0] p,g,
    input Cin,
    output [N-1:0] C       // C_-1 = Cin, C_N-1 = Cout
    );
    localparam red_stages_no = $clog2(N);
    localparam exp_stages_no = $clog2(N)-1;        
    localparam total_stages_no = red_stages_no + exp_stages_no;    // total number of stages: 2log2(N)-1
    localparam NDIV2 = N >> 1;

    // assign C[-1] = Cin;

    wire [N-2:0] g_inter_red, p_inter_red;      // note that all intermediate g signals numbers 
                                                // in reduction levels converges to N-1 (N/2+N/4+..+1 = N-1)
    // handle Cin
    wire g0;
    grey_carry_operator op_minus1 (.g({g[0], Cin}), .p(p[0]), .G(g0));
    assign C[0] = g0;       // 

    // first level, takes input from module's input
    bk_reduction_stage #(.N(N)) reduction_stage1 (.p(p[N-1:1]), .g({g[N-1:1], g0}),
                                                .P(p_inter_red[NDIV2-1:1]), .G(g_inter_red[NDIV2-1:0]));
    assign C[1] = g_inter_red[0];     // after level 1, x1 is ready

    genvar i;
    genvar j;
    generate
        for (i = 2; i <= red_stages_no; i = i + 1) begin: reduction_stage
            localparam in_idx = (1<<red_stages_no)-(1<<(red_stages_no-i+2));    // input index to current level = 2^levels-2^(levels-i+2)
            localparam in_size = N>>(i-1);                                          // input size = (N>>i)
            localparam out_idx = in_idx+in_size;                                // input index of current level = input index to current level + input size
            localparam out_size = in_size>>1;                                   // output size = input size/2
            wire [in_size-1:0] g_inter_red_in = g_inter_red[in_size+in_idx-1:in_idx];
            wire [in_size-1:1] p_inter_red_in = p_inter_red[in_size+in_idx-1:in_idx+1];
            if (i == red_stages_no) begin
                bk_reduction_stage #(.N(in_size)) reduction_stage (.p(p_inter_red_in), .g(g_inter_red_in),
                                                            .G(g_inter_red[out_size+out_idx-1:out_idx]));    
            end
            else begin
                bk_reduction_stage #(.N(in_size)) reduction_stage (.p(p_inter_red_in), .g(g_inter_red_in),
                                                .P(p_inter_red[out_size+out_idx-1:out_idx+1]), .G(g_inter_red[out_size+out_idx-1:out_idx]));            
            end
            localparam c_index = (1<<i) - 1;   // (2^level) - 1, level = i
            assign C[c_index] = g_inter_red[out_idx];
        end

    endgenerate
    generate
        for (i = 1; i <= exp_stages_no; i = i + 1) begin: expansion_stage
            // localparam stage_size = (1<<i) - 1;         // stage size = (2^level) - 1
            // localparam in_size = stage_size << 1;       // input size = stage size * 2
            localparam step = N>>(i+1);
            localparam c_index_start = 3*step-1;
            localparam c_index_end = N-step-1;
            if (i == exp_stages_no) begin
                for (j = c_index_start; j <= c_index_end; j = j + (step<<1)) begin: expansion_stage_op
                    localparam c_base_idx = j - step;
                    grey_carry_operator expansion_stage_op (.p(p[j]), .g({g[j], C[c_base_idx]}), .G(C[j]));
                end
            end
            else begin
                localparam i_red_stage = $clog2(step);
                localparam start_idx_red = (1<<red_stages_no)-(1<<(red_stages_no-i_red_stage+1));
                for (j = c_index_start; j <= c_index_end; j = j + (step<<1)) begin: expansion_stage_op
                    localparam c_base_idx = j - step;
                    localparam red_group = j>>(i_red_stage);
                    localparam red_idx = start_idx_red + red_group;
                    grey_carry_operator expansion_stage_op (.p(p_inter_red[red_idx]), .g({g_inter_red[red_idx], C[c_base_idx]}), .G(C[j])); 
                end
            end
        end
    endgenerate
    
endmodule
// wire [N-2:red_stages_no] p_inter_red;     // note that intermediate p signals = 
    //                                                 // intermediate g signals - reduction stages no = N-1-clog2(N)
    // bk_reduction_stage #(.N(N)) reduction_stage0 (.p(p[N-1:1]), .g(p[N-1:0]),
    //                                             .P(p_inter_red[N-2:NDIV2]), .G(g_inter_red[N-2:NDIV2-1]));
// generate
//         for (i = NDIV2; i > 1; i = i >> 1) begin: reduction_stage
//             wire [i-1:0] g_inter_red_in = g_inter_red[(i<<1)-2:i-1];
//             wire [i-1:1] p_inter_red_in = (i == 2) ? p_inter_red[red_stages_no] : p_inter_red[(i<<1)-2:i];
//             bk_reduction_stage #(.N(i)) reduction_stage (.p(p_inter_red_in), .g(g_inter_red_in),
//                                                 .P(p_inter_red[N-2:NDIV2]), .G(g_inter_red[i-2:(i>>1)-1]));        
//         end
//     endgenerate




// first level, takes input from module's input
    // bk_reduction_stage #(.N(N)) reduction_stage0 (.p(p[N-1:0]), .g({g[N-1:1], g0}),
    //                                             .P(p_inter_red[N-2:NDIV2]), .G(g_inter_red[N-2:NDIV2-1]));
    // assign C[1] = g_inter_red[NDIV2-1];     // after level 1, x1 is ready

    // genvar i;
    // genvar j;
    // generate
    //     for (i = NDIV2; i > 1; i = i >> 1) begin: reduction_stage
    //         wire [i-1:0] g_inter_red_in = g_inter_red[(i<<1)-2:i-1];
    //         wire [i-1:1] p_inter_red_in = p_inter_red[(i<<1)-2:i];
    //         if (i == 2) begin
    //             bk_reduction_stage #(.N(i)) reduction_stage (.p(p_inter_red_in), .g(g_inter_red_in),
    //                                                         .G(g_inter_red[i-2:(i>>1)-1]));    
    //         end
    //         else begin
    //             bk_reduction_stage #(.N(i)) reduction_stage (.p(p_inter_red_in), .g(g_inter_red_in),
    //                                             .P(p_inter_red[i-2:(i>>1)]), .G(g_inter_red[i-2:(i>>1)-1]));            
    //         end
    //         localparam level_no = red_stages_no - $clog2(i) + 1;
    //         localparam c_index =(1<<level_no) - 1;   // (2^level) - 1, level = ??
    //         assign C[c_index] = g_inter_red[(i>>1)-1];
    //     end

    // endgenerate

    // generate
        
    // endgenerate