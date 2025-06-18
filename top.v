module top(input clk, reset,
           output [7:0] writedata,
           output we, 
			  output [15:0] address);
wire [7:0] readdata;
			  
smm smm(clk, reset, readdata, we, address, writedata);
memory mem(clk, we, address, writedata, readdata);
endmodule

module smm(input clk, reset,
           input [7:0] readdata,
           output we, 
			  output [15:0] address,
			  output [7:0] writedata);

wire buffR, buffIR, buffAH, mdamux, buffAL, adrmux, srcbmux;
wire [1:0] pcmux, acmux;
wire [2:0] aluop;
wire [15:0] addr;
wire [7:0] wdata, instr;
wire zero;

datapath dp(clk, reset, we, buffIR, buffAH, buffAL, buffR, srcbmux, adrmux, acmux, pcmux, aluop, readdata, addr, wdata, instr, zero);
controller cu(clk, reset, zero, instr, buffIR, buffAH, buffAL, buffR, srcbmux, adrmux, we, pcmux, acmux, aluop);

assign writedata = wdata;
assign address = addr;
endmodule

module memory(input clk, we, input [15:0] addr, input [7:0] wdata, output [7:0] rdata);
reg [7:0] RAM[63:0];
initial
begin
$readmemh ("memfile.dat",RAM);
end

always @ (posedge clk)
begin
  if (we)
    RAM[addr[5:0]] <= wdata;
end
assign rdata = RAM[addr[5:0]];
endmodule

