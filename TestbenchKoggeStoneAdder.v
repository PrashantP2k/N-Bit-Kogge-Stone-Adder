`timescale 1 ns / 1 ps

// module TestbenchAdder8Bit;

//     reg signed [7:0] A, B;
//     reg Cin;
//     wire signed Cout;
//     wire overflowFlag;
//     wire [7:0] S;

//     Adder8Bit EBKSAT (A, B, Cin, Cout, S, overflowFlag);

//     initial
//         begin
//           $monitor ($time, ": A = %d, B = %d, Cin = %d, Cout = %d, S = %d, overflowFlag = %d", A, B, Cin, Cout, S, overflowFlag);
          
//           $dumpfile("test.vcd");
//           $dumpvars(0, TestbenchAdder8Bit);

//             A = 8'd0;
//             B = 8'd0;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 8'b10010110;
//             B = 8'b11001010;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 8'b00100111;
//             B = 8'b10011011;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 $finish;
//         end

// endmodule

// module TestbenchAdder16Bit;

//     reg signed [15:0] A, B;
//     reg Cin;
//     wire signed Cout;
//     wire overflowFlag;
//   	wire signed [15:0] S;

//   	Adder16Bit TA (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S), .overflowFlag(overflowFlag));

//     initial
//         begin
//           $monitor ($time, ": A = %d, B = %d, Cin = %d, Cout = %d, S = %d, overflowFlag = %d", A, B, Cin, Cout, S, overflowFlag);
          
//           $dumpfile("test.vcd");
//           $dumpvars(0, TestbenchAdder16Bit);
          
//             A = 16'b0110010010000111;
//             B = 16'b0110010010000111;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 16'b0101001010101000;
//             B = 16'b0100001100000101;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 16'b1111000000000000;
//             B = ($signed(16'b0111000000000000) >>> 2);
//             Cin = 1'b0;
//             #5 A = 16'b0111000000000000;
//             B = ($signed(16'b1111000000000000) >>> 2);
//           	Cin = 1'b1;
//             #5 $finish;
//         end

// endmodule

// module TestbenchAdder32Bit;

//     reg signed [31:0] A, B;
//     reg Cin;
//     wire signed Cout;
//     wire overflowFlag;
//   	wire signed [31:0] S;

//   	Adder32Bit TA (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S), .overflowFlag(overflowFlag));

//     initial
//         begin
//           $monitor ($time, ": A = %d, B = %d, Cin = %d, Cout = %d, S = %d, overflowFlag = %d", A, B, Cin, Cout, S, overflowFlag);
          
//           $dumpfile("test.vcd");
//           $dumpvars(0, TestbenchAdder32Bit);
          
//             A = 32'h00000000;
//             B = 32'h00000000;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 32'h4FFFFFFF;
//             B = 32'h4FFFFFFF;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 32'h12345678;
//             B = 32'hABCDEF01;
//             Cin = 1'b0;
//           	 #5 Cin = 1'b1;
//             #5 A = 32'hFFFFFFFF;
//             B = 32'h00000001;
//           	 Cin = 1'b0;
//           	 #5 Cin = 1'b1;
//             #5 $finish;
//         end

// endmodule

// module TestbenchKoggeStoneAdder;

//   	reg signed [31:0] A, B;
//     reg Cin;
//     wire Cout, overflowFlag;
//   	wire signed [31:0] S;

//   KoggeStoneAdder #(.N(32)) TKSA (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S), .overflowFlag(overflowFlag));

//     initial
//         begin
//           $monitor ($time, ": A = %d, B = %d, Cin = %d, Cout = %d, S = %d, overflowFlag = %d", A, B, Cin, Cout, S, overflowFlag);
          
//           $dumpfile("test.vcd");
//           $dumpvars(0, TestbenchKoggeStoneAdder);
          
//             A = 32'h00000000;
//             B = 32'h00000000;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 32'h4FFFFFFF;
//             B = 32'h4FFFFFFF;
//             Cin = 1'b0;
//             #5 Cin = 1'b1;
//             #5 A = 32'h12345678;
//             B = 32'hABCDEF01;
//             Cin = 1'b0;
//           	 #5 Cin = 1'b1;
//             #5 A = 32'hFFFFFFFF;
//             B = 32'h00000001;
//           	 Cin = 1'b0;
//           	 #5 Cin = 1'b1;
//             #5 $finish;
//         end

// endmodule

module TestbenchKoggeStoneAdder;

  	reg signed [63:0] A, B;
    reg Cin;
    wire Cout, overflowFlag;
  	wire signed [63:0] S;

  KoggeStoneAdder #(.N(64)) TKSA (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .S(S), .overflowFlag(overflowFlag));

    initial
        begin
          $monitor ($time, ": A = %d, B = %d, Cin = %d, Cout = %d, S = %d, overflowFlag = %d", A, B, Cin, Cout, S, overflowFlag);
          
          $dumpfile("test.vcd");
          $dumpvars(0, TestbenchKoggeStoneAdder);
          
            A = 64'h0000000000000000;
            B = 64'h0000000000000000;
            Cin = 1'b0;
            #5 Cin = 1'b1;
            #5 A = 64'h4FFFFFFFFFFFFFFF;
            B = 64'h4FFFFFFFFFFFFFFF;
            Cin = 1'b0;
            #5 Cin = 1'b1;
            #5 A = 64'h1234567812345678;
            B = 64'hABCDEF0123456789;
            Cin = 1'b0;
          	#5 Cin = 1'b1;
            #5 A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'h0000000000000001;
          	Cin = 1'b0;
          	#5 Cin = 1'b1;
            #5 $finish;
        end

endmodule