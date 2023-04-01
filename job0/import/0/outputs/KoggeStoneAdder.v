`timescale 1 ns / 1 ps

module PreProcessingGP (
    input  x,
    input  y,
    output G,
  	output P
);

    assign G = (x & y);
    assign P = (x ^ y);

endmodule

module GrayCell #(parameter W = 8) (
    input  [0 : (W - 1)] Gikp1,
    input  [0 : (W - 1)] Pikp1,
    input  [0 : (W - 1)] Gkj,
    output [0 : (W - 1)] Gij
);

    assign Gij = (Gikp1 | (Pikp1 & Gkj));

endmodule

module BlackCell #(parameter W = 8) (
    input  [0 : (W - 1)] Gikp1,
    input  [0 : (W - 1)] Pikp1,
    input  [0 : (W - 1)] Gkj,
    input  [0 : (W - 1)] Pkj,
    output [0 : (W - 1)] Gij,
    output [0 : (W - 1)] Pij
);

    assign Gij = (Gikp1 | (Pikp1 & Gkj));
    assign Pij = (Pikp1 & Pkj);

endmodule

module Adder8Bit (
    input  signed [7:0] A,
  	input  signed [7:0] B,
    input               Cin,
    output              Cout,
  	output signed [7:0] S,
  	output              overflowFlag
);
  
  	wire Cout_i;
  	wire [0:7] S_i;
  	wire [0:7] G [0:3], P [0:3];
  	genvar i;
  
    // preprocessing layer
  	generate
      	for (i = 0; i < 8; i = i + 1)
            begin: GP
              	PreProcessingGP GP (A[i], B[i], G[0][i], P[0][i]);
            end
    endgenerate

    // carry lookahead - layer 1
  	GrayCell #(.W(1)) GC1 (G[0][0], P[0][0], Cin, G[1][0]);
  	BlackCell #(.W(7)) BC1 (G[0][1:7], P[0][1:7], G[0][0:6], P[0][0:6], G[1][1:7], P[1][1:7]);
  
  	// carry lookahead - layer 2
  	GrayCell #(.W(2)) GC2 (G[1][1:2], P[1][1:2], {Cin, G[1][0]}, G[2][1:2]);
  	BlackCell #(.W(5)) BC2 (G[1][3:7], P[1][3:7], G[1][1:5], P[1][1:5], G[2][3:7], P[2][3:7]);
  
  	// carry lookahead - layer 3
    GrayCell #(.W(4)) GC3 (G[2][3:6], P[2][3:6], {Cin, G[1][0], G[2][1:2]}, G[3][3:6]);
  	BlackCell #(.W(1)) BC3 (G[2][7], P[2][7], G[2][3], P[2][3], G[3][7], P[3][7]);
  
  	// carry lookahead - layer 4
    GrayCell #(.W(1)) GC4 (G[3][7], P[3][7], Cin, Cout_i);
 	
  	// post-processing - sum bits
  	assign S_i = ({Cin, G[1][0], G[2][1:2], G[3][3:6]} ^ P[0]);
  
    generate
      	for (i = 0; i < 8; i = i + 1)
            begin: Adder8Bit
              	assign S[i] = S_i[i];
            end
    endgenerate
  
    // assign Cout
    assign Cout = Cout_i;
  
  	// overflow flag
    assign overflowFlag = (G[3][6] ^ Cout_i);
  
endmodule

module Adder16Bit (
    input  signed [15:0] A,
    input  signed [15:0] B,
    input                Cin,
    output               Cout,
    output signed [15:0] S,
  	output               overflowFlag
);
  
  	wire Cout_i;
  	wire [0:15] S_i;
  	wire [0:15] G [0:4], P [0:4];
  	genvar i;
  
    // preprocessing layer
  	generate
      	for (i = 0; i < 16; i = i + 1)
            begin: GP
              	PreProcessingGP GP (A[i], B[i], G[0][i], P[0][i]);
            end
    endgenerate

    // carry lookahead - layer 1
  	GrayCell #(.W(1)) GC1 (G[0][0], P[0][0], Cin, G[1][0]);
  	BlackCell #(.W(15)) BC1 (G[0][1:15], P[0][1:15], G[0][0:14], P[0][0:14], G[1][1:15], P[1][1:15]);
  
  	// carry lookahead - layer 2
  	GrayCell #(.W(2)) GC2 (G[1][1:2], P[1][1:2], {Cin, G[1][0]}, G[2][1:2]);
  	BlackCell #(.W(13)) BC2 (G[1][3:15], P[1][3:15], G[1][1:13], P[1][1:13], G[2][3:15], P[2][3:15]);
  
  	// carry lookahead - layer 3
    GrayCell #(.W(4)) GC3 (G[2][3:6], P[2][3:6], {Cin, G[1][0], G[2][1:2]}, G[3][3:6]);
    BlackCell #(.W(9)) BC3 (G[2][7:15], P[2][7:15], G[2][3:11], P[2][3:11], G[3][7:15], P[3][7:15]);
  
  	// carry lookahead - layer 4
  	GrayCell #(.W(8)) GC4 (G[3][7:14], P[3][7:14], {Cin, G[1][0], G[2][1:2], G[3][3:6]}, G[4][7:14]);
    BlackCell #(.W(1)) BC4 (G[3][15], P[3][15], G[3][7], P[3][7], G[4][15], P[4][15]);
  
  	// carry lookahead - layer 5
    GrayCell #(.W(1)) GC5 (G[4][15], P[4][15], Cin, Cout_i);
 
  	// post-processing - sum bits
  	assign S_i = ({Cin, G[1][0], G[2][1:2], G[3][3:6], G[4][7:14]} ^ P[0]);
  
    generate
        for (i = 0; i < 16; i = i + 1)
            begin: Adder16Bit
              	assign S[i] = S_i[i];
            end
    endgenerate
  
    // assign Cout
    assign Cout = Cout_i;
  
  	// overflow flag
    assign overflowFlag = (G[4][14] ^ Cout_i);
  
endmodule

module Adder32Bit (
  	input  signed [31:0] A,
  	input  signed [31:0] B,
    input                Cin,
    output               Cout,
  	output signed [31:0] S,
  	output               overflowFlag
);

  	wire Cout_i;
  	wire [0:31] S_i;
  	wire [0:31] G [0:5], P [0:5];
  	genvar i;
  
    // preprocessing layer
  	generate
      	for (i = 0; i < 32; i = i + 1)
            begin: GP
              	PreProcessingGP GP (A[i], B[i], G[0][i], P[0][i]);
            end
    endgenerate

    // carry lookahead - layer 1
  	GrayCell #(.W(1)) GC1 (G[0][0], P[0][0], Cin, G[1][0]);
  	BlackCell #(.W(31)) BC1 (G[0][1:31], P[0][1:31], G[0][0:30], P[0][0:30], G[1][1:31], P[1][1:31]);
  
  	// carry lookahead - layer 2
  	GrayCell #(.W(2)) GC2 (G[1][1:2], P[1][1:2], {Cin, G[1][0]}, G[2][1:2]);
  	BlackCell #(.W(29)) BC2 (G[1][3:31], P[1][3:31], G[1][1:29], P[1][1:29], G[2][3:31], P[2][3:31]);
  
  	// carry lookahead - layer 3
    GrayCell #(.W(4)) GC3 (G[2][3:6], P[2][3:6], {Cin, G[1][0], G[2][1:2]}, G[3][3:6]);
  	BlackCell #(.W(25)) BC3 (G[2][7:31], P[2][7:31], G[2][3:27], P[2][3:27], G[3][7:31], P[3][7:31]);
  
  	// carry lookahead - layer 4
  	GrayCell #(.W(8)) GC4 (G[3][7:14], P[3][7:14], {Cin, G[1][0], G[2][1:2], G[3][3:6]}, G[4][7:14]);
  	BlackCell #(.W(17)) BC4 (G[3][15:31], P[3][15:31], G[3][7:23], P[3][7:23], G[4][15:31], P[4][15:31]);
  
  	// carry lookahead - layer 5
  	GrayCell #(.W(16)) GC5 (G[4][15:30], P[4][15:30], {Cin, G[1][0], G[2][1:2], G[3][3:6], G[4][7:14]}, G[5][15:30]);
  	BlackCell #(.W(1)) BC5 (G[4][31], P[4][31], G[4][15], P[4][15], G[5][31], P[5][31]);
  
  	// carry lookahead - layer 6
    GrayCell #(.W(1)) GC6 (G[5][31], P[5][31], Cin, Cout_i);
 	
  	// post-processing - sum bits
  	assign S_i = ({Cin, G[1][0], G[2][1:2], G[3][3:6], G[4][7:14], G[5][15:30]} ^ P[0]);
  
    generate
      	for (i = 0; i < 32; i = i + 1)
            begin: Adder32Bit
              	assign S[i] = S_i[i];
            end
    endgenerate
  
    // assign Cout
    assign Cout = Cout_i;
  
  	// overflow flag
    assign overflowFlag = (G[5][30] ^ Cout_i);
  
endmodule

module KoggeStoneAdder #(parameter N = 64) (
  	input  signed [(N - 1) : 0] A,
  	input  signed [(N - 1) : 0] B,
    input 			 		            Cin,
    output			 		            Cout,
  	output signed [(N - 1) : 0] S,
    output 					            overflowFlag
);
  
  	// number of layers in the carry lookahead tree (depth)
  	localparam D = $clog2(N);

    wire Cout_i; // internal copy of the output carry flag
  	wire [0 : (N - 1)] S_i; // internal copy of the output sum
  	wire [0 : (N - 1)] G [0 : D], P [0 : D]; // generate and propagate bits
  	wire [0 : (N - 1)] temp [0 : D]; // a temporary array to make the code better
    genvar i; // looping variable
  
    // preprocessing layer
  	generate
      	for (i = 0; i < N; i = i + 1)
            begin: GeneratePropagate
              	PreProcessingGP GP (A[i], B[i], G[0][i], P[0][i]);
            end
    endgenerate
  
    // carry lookahead layers 1 - D
    generate
        for (i = 0; i < D; i = i + 1)
            begin: CarryLookahead
              	if (i == 0)
                    begin
                      	assign temp[i] = {{(N - 1){1'b0}}, Cin};
                    end
                else
                    begin
                        assign temp[i] = {temp[i - 1][(N - (2 ** (i - 1))) : (N - 1)], G[i][((2 ** (i - 1)) - 1) : (2 * ((2 ** (i - 1)) - 1))]};
                    end
              	GrayCell #(.W(2 ** i)) GC (G[i][((2 ** i) - 1) : (2 * ((2 ** i) - 1))], P[i][((2 ** i) - 1) : (2 * ((2 ** i) - 1))], temp[i][(N - (2 ** i)) : (N - 1)], G[i + 1][((2 ** i) - 1) : (2 * ((2 ** i) - 1))]);
              	BlackCell #(.W((N + 1) - (2 ** (i + 1)))) BC (G[i][((2 * ((2 ** i) - 1)) + 1) : (N - 1)], P[i][((2 * ((2 ** i) - 1)) + 1) : (N - 1)], G[i][((2 ** i) - 1) : ((N - 1) - (2 ** i))], P[i][((2 ** i) - 1) : ((N - 1) - (2 ** i))], G[i + 1][((2 * ((2 ** i) - 1)) + 1) : (N - 1)], P[i + 1][((2 * ((2 ** i) - 1)) + 1) : (N - 1)]);
            end
    endgenerate
    
  	assign temp[D] = {temp[D - 1][(N - (2 ** (D - 1))) : (N - 1)], G[D][((2 ** (D - 1)) - 1) : (2 * ((2 ** (D - 1)) - 1))]};
      
    // carry lookahead layer (D + 1)
    GrayCell #(.W(1)) GC (G[D][N - 1], P[D][N - 1], Cin, Cout_i);
 	
  	// post-processing - sum bits
    assign S_i = (temp[D] ^ P[0]);
  
    generate
      	for (i = 0; i < N; i = i + 1)
            begin: Revert
              	assign S[i] = S_i[i];
            end
    endgenerate
  
    // assign Cout
    assign Cout = Cout_i;
  
  	// overflow flag
    assign overflowFlag = (G[D][N - 2] ^ Cout_i);
    
endmodule

