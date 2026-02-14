`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2026 04:45:26 AM
// Design Name: 
// Module Name: ppa_brentkung_tb
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


module ppa_brentkung_tb;

    // --------------------------------------------------------
    // Parameters
    // --------------------------------------------------------
    parameter N = 64; // Parameterized Width
    localparam NUM_RANDOM_TESTS = 1000;

    // --------------------------------------------------------
    // Inputs & Outputs
    // --------------------------------------------------------
    reg [N-1:0] A;
    reg [N-1:0] B;
    reg Cin;

    wire [N-1:0] Sum;
    wire Cout;

    // --------------------------------------------------------
    // Variables for Verification
    // --------------------------------------------------------
    reg [N:0] expected_result; // N-bit to hold Sum + Carry
    integer i, j;
    integer error_count = 0;
    
    // --------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // --------------------------------------------------------
    ppa_brentkung #(.N(N)) uut (
        .x(A), 
        .y(B), 
        .Cin(Cin), 
        .s(Sum), 
        .Cout(Cout)
    );

    // --------------------------------------------------------
    // Test Procedure
    // --------------------------------------------------------
    initial begin
        // Initialize
        A = 0; B = 0; Cin = 0;
        
        $display("============================================================");
        $display("   Starting Self-Checking Testbench for %0d-bit PPA   ", N);
        $display("============================================================");

        // --- 1. Directed Corner Cases ---
        $display("--- Running Directed Corner Cases ---");
        
        check_case({N{1'b0}}, {N{1'b0}}, 1'b0); // Zero check
        check_case({N{1'b0}}, {N{1'b0}}, 1'b1); // Carry In check
        check_case({N{1'b1}}, {N{1'b0}}, 1'b0); // Max Value check (No Cout)
        check_case({N{1'b1}}, {N{1'b0}}, 1'b1); // Max Value check (With Cout)
        
        // Alternating Bits logic
        check_case({(N/2){2'b10}}, {(N/2){2'b01}}, 1'b0);

        // --- 2. Random Verification Loop ---
        $display("\n--- Running %0d Random Test Vectors ---", NUM_RANDOM_TESTS);
        
        for (i = 0; i < NUM_RANDOM_TESTS; i = i + 1) begin: random_test
            reg [N-1:0] rand_A, rand_B;
            
            // Robust random generation for widths > 32-bits
            for (j = 0; j < N; j = j + 32) begin
                rand_A[j +: 32] = $random;
                rand_B[j +: 32] = $random;
            end
            
            check_case(rand_A, rand_B, $random % 2);
        end

        // --- 3. Final Summary ---
        $display("============================================================");
        if (error_count == 0) begin
            $display("   SUCCESS: All tests passed!");
        end else begin
            $display("   FAILURE: Found %0d mismatches.", error_count);
        end
        $display("============================================================");
        
        $finish;
    end

    // --------------------------------------------------------
    // Task: check_case
    // --------------------------------------------------------
    task check_case;
        input [N-1:0] in_A;
        input [N-1:0] in_B;
        input         in_Cin;
        begin
            A   = in_A;
            B   = in_B;
            Cin = in_Cin;

            // Behavioral Golden Reference
            expected_result = in_A + in_B + in_Cin;

            #10; // Wait for logic to settle

            if ({Cout, Sum} !== expected_result) begin
                error_count = error_count + 1;
                $display("[ERROR] Time=%0t | A=%h | B=%h | Cin=%b", $time, A, B, Cin);
                $display("        Expected: %h | Got: %h_%h", expected_result, Cout, Sum);
            end
        end
    endtask

endmodule

