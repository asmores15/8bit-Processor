module testbench();
reg clk;
reg reset;
wire [7:0] writedata; 
wire [15:0] dataadr;
wire memwrite;
// instantiate device to be tested
top dut (clk, reset, writedata, memwrite, dataadr);
// initialize test
initial
begin
reset <= 1; # 22; reset <= 0;
end
// generate clock to sequence tests
always
begin
clk <= 1;
 # 5; 
 clk <= 0;
 # 5; // clock duration
end
// check results
always @ (negedge clk)
begin
  if (memwrite)
  begin
    $display("Address: 0x%0h  Data written: %0b", dataadr, writedata);
	 if (dataadr == 16'h001C & writedata == 8'b10111001)
	  $display("Success!");
	 else
	  $display("Incorrect address or data.");
  end
end
endmodule
