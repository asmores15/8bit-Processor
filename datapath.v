module datapath(input clk, reset, weCU, buffIRCU, buffAHCU,
                input buffALCU, buffRCU, srcbmuxCU, adrmuxCU,
			       input [1:0] acmuxCU, pcmuxCU,
			       input [2:0] aluopCU,
			       input [7:0] memdata,
			       output [15:0] address,
			       output [7:0] writedata, instrCU,
			       output zeroCU);

wire [7:0]  adrHout, buffIRout, buffAHout, buffALout, srcbmuxout;
wire [7:0]  acout, acmuxout, rout, buffRout, aluout;
wire [15:0] pcout, pcaddout, mdaout, pcmuxout, adrmuxout;
  

flopr #(8) IR(clk, reset, buffIRout, instrCU);
flopr #(8) adrH(clk, reset, buffAHout, adrHout);
buff buffIR(memdata, buffIRCU, buffIRout);
buff buffadrH(memdata, buffAHCU, buffAHout);
buff buffadrL(memdata, buffALCU, buffALout);

mux3 #(8) acmux(aluout, memdata, rout, acmuxCU, acmuxout);
flopr #(8) AC(clk, reset, acmuxout, acout);
flopr #(8) R(clk, reset, buffRout, rout);
buff buffR(acout, buffRCU, buffRout);

mux2 #(8) srcbmux(rout, 8'b00000001, srcbmuxCU, srcbmuxout);
alu alu(acout, srcbmuxout, aluopCU, aluout, zeroCU);

flopr #(16) PC(clk, reset, pcmuxout, pcout);
mux3 #(16) pcmux(pcout, pcaddout, {adrHout, buffALout}, pcmuxCU, pcmuxout);
adder pcadder(pcout, 16'b000000000000001, pcaddout);
flopr #(16) MDA(clk, reset, {adrHout, buffALout}, mdaout);
mux2 #(16) addressmux(pcout, mdaout, adrmuxCU, adrmuxout);

assign address = adrmuxout;
assign writedata = aluout;
endmodule

module mux2 # (parameter WIDTH = 8)
(input  [WIDTH-1:0] a0, a1,
 input s,
 output [WIDTH-1:0] y);
 
  assign y = s ? a1 : a0;
endmodule

module mux3 # (parameter WIDTH = 8)
(input  [WIDTH-1:0] a0, a1, a2,
 input  [1:0] s,
 output [WIDTH-1:0] y);

  assign #1 y = s[1] ? a2 : (s[0] ? a1 : a0); 
endmodule

module flopr # (parameter WIDTH = 8)
(input clk, reset,
 input [WIDTH-1:0] d,
 output reg [WIDTH-1:0] q);

 always @ (posedge clk, posedge reset)
   if (reset) q <= 0;
   else q <= d;
endmodule

module buff(input[7:0] a, input s, output reg [7:0] y);
  always @(*)
    if(s == 1) y = a;	
endmodule

module adder(input [15:0] a, b, output [15:0] y);
assign y = a + b;
endmodule

module alu (a, b, sel, out, zero);
    input [7:0] a,b;
    input [2:0] sel; 
    output reg [7:0] out;
    output reg zero;
  
  initial
  begin
  out = 0;
  zero = 1'b0;
  end
    always @ (*) 
    begin 
        case(sel) 
		      3'b000:  //pass through
	begin
		out = a; 
		if (out == 0) zero = 1;  
		else zero = 0; 
          end
			 
            3'b001:  //add
	begin
		out = a+b;  
		if (out == 0)
		 zero = 1;  
		else
		zero = 0;
          end     
			 
            3'b010:  //sub
	begin
		out = a-b;  
		if (out == 0) zero = 1;  
		else zero = 0;
          end 
			 
            3'b011:  //clear ac
	begin
		out = 0; 
		zero = 1;
          end
			 
			   3'b100:  //and
	begin
		out = a & b; 
		if (out == 0)
		 zero = 1;  
		else
		zero = 0;
          end
	     
		     3'b101:  //or
	begin
		out = a | b; 
		if (out == 0) zero = 1;  
		else zero = 0; 
          end
			 
			  3'b110:  //xor
	begin
		out = a ^ b; 
		if (out == 0) zero = 1;  
		else zero = 0; 
          end		 
			 
			  3'b111:  //not
	begin
		out = ~a; 
		if (out == 0) zero = 1;  
		else zero = 0; 
          end
        endcase
    end
endmodule
