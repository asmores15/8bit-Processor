module controller(input clk, reset, zflag, 
                  input [7:0] opcode, 
						output buffIR, buffAH, buffAL, buffR, srcbmux, adrmux, we,
			         output [1:0] pcmux, acmux, 
						output [2:0] aluop);
  maindec md(clk, reset, zflag, opcode, buffAL, buffR, buffIR, buffAH, srcbmux, adrmux, we, pcmux, acmux, aluop);
endmodule

module maindec(input clk, reset, zflag, 
               input [7:0] opcode, 
					output buffAL, buffR, buffIR, buffAH, srcbmux, adrmux, we,
			      output [1:0] pcmux, acmux,
					output [2:0] aluop);
  reg [13:0] controls;
  reg [3:0] state, nextstate;
  assign {buffAL, buffAH, buffIR, acmux, buffR, srcbmux, aluop, pcmux, adrmux, we} = controls;

  parameter fetch = 4'b0000;
  parameter decode = 4'b0001;
  parameter getah = 4'b0010;
  parameter getal = 4'b0011;
  parameter loaddata = 4'b0100;
  parameter storedata = 4'b0101;
  parameter jumpinstr = 4'b0110;
  parameter alu = 4'b0111;
  parameter r_to_ac = 4'b1000;
  parameter ac_to_r = 4'b1001;
  parameter ahfetch = 4'b1010;
  parameter pcinc = 4'b1011;
  
  
  parameter NOP = 8'h00;
  parameter LDAC = 8'h01;
  parameter STAC = 8'h02;
  parameter MVAC = 8'h03;
  parameter MOVR = 8'h04;
  parameter JUMP = 8'h05;
  parameter JMPZ = 8'h06;
  parameter JPNZ = 8'h07;
  parameter ADD = 8'h08;
  parameter SUB = 8'h09;
  parameter INAC = 8'h0A;
  parameter CLAC = 8'h0B;
  parameter AND = 8'h0C;
  parameter OR = 8'h0D;
  parameter XOR = 8'h0E;
  parameter NOT = 8'h0F;
  
  always @(posedge clk, posedge reset)
    if (reset)  state <= fetch;
	 else        state <= nextstate;
  
  always @(*)
  begin  
    case(state)
	   fetch: nextstate <= decode;
		decode: case(opcode)
		          NOP: nextstate <= pcinc;
					 LDAC: nextstate <= ahfetch;
					 STAC: nextstate <= ahfetch;
					 MVAC: nextstate <= ac_to_r;
					 MOVR: nextstate <= r_to_ac;
					 JUMP: nextstate <= ahfetch;
					 JMPZ: if (zflag)  nextstate <= ahfetch;
					       else        nextstate <= pcinc;
					 JPNZ: if (~zflag) nextstate <= ahfetch;
					       else        nextstate <= pcinc;
					 default: nextstate <= alu;
				 endcase
		 getah: nextstate <= getal;
		 getal: if (opcode == STAC)      nextstate <= storedata;
		        else if (opcode == LDAC) nextstate <= loaddata;
				  else                     nextstate <= jumpinstr;
		 jumpinstr: nextstate <= fetch;
		 storedata: nextstate <= fetch;
		 loaddata: nextstate <= fetch;
		 ac_to_r: nextstate <= fetch;
		 r_to_ac: nextstate <= fetch;
		 alu: nextstate <= fetch;
		 ahfetch: nextstate <= getah;
		 pcinc: nextstate <= fetch;
	 endcase
  end
	 
	 
  always @(*)
  begin
    case(state)
	   fetch: controls <= 14'b00100000000000;
		decode: controls <= 14'b00000000000000;
		getah: controls <= 14'b00000000000100;
		getal: controls <= 14'b10000000000000;
		storedata: controls <= 14'b00000000000111;
		loaddata: controls <=  14'b00001000000110;
		ac_to_r: controls <= 14'b00000100000100;
		r_to_ac: controls <= 14'b00010000000100;
		jumpinstr: controls <= 14'b00000000001010;
		ahfetch: controls <= 14'b01000000000100;
		pcinc: controls <= 14'b00000000000100;
		alu:
		begin
		  case(opcode)
		    ADD: controls <= 14'b00000000010100;
			 SUB: controls <= 14'b00000000100100;
			 INAC: controls <= 14'b00000010010100;
			 CLAC: controls <= 14'b00000000110100;
			 AND: controls <= 14'b00000001000100;
			 OR: controls <= 14'b00000001010100;
			 XOR: controls <= 14'b00000001100100;
			 NOT: controls <= 14'b00000001110100;
		  endcase
		end
    endcase
  end
  
  
  
endmodule
