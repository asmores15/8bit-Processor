How it works:
An 8-bit microprocessor that takes in instructions that are 8 bits long and uses the parts of the instruction to execute an operation. The design is based off of criteria given by the professor of the course (Digital System Architecture and Design), so the instruction set architecture (ISA) is custom. 
The microprocessor is capable of decoding 256 possible instructions because each instruction is 8 bits. Currently, it is using 16 instructions but has space for 240 more if desired. This would of course mean adding more components to the design, but the possibility is there.
After the controller receives the opcode, it determines which state is to be set and sends the proper signals to each component according to the state. There are 12 states with room for 3 more. 
Once the data has been processed and the instruction is complete, the next instruction is fetched and the cycle repeats again.
The design was tested using a memfile containing assembly code. I don't remember what the exact output was that determined success, but I do remember that it worked and provided the desired output.
Regrettably, I did not document my code very well when I was working on this project. So, I'm not able to explain exactly how the processor works in more detail. However, I am still proud that I managed to make a processor on my own, albeit a small one. At some point I'd like to redesign it now that I know more about computer architecture! Microprocessors are the coolest thing about computers, in my opinion. They're just amazing!!

Main Components:
- Cache memory (8 x 64 bits). Holds instructions and data.
- Instruction register. Passses the instruction part of the instruction to the Control Unit. Has three inputs and one output. The address input has a two input mux. The inputs are the program counter value and the data from the MDA register. The other two inputs of the memory are the output from the ALU and write enable. The output is the data from memory.
- Memory Data Address (MDA) register. Holds the upper part of the instruction (the address) to pass to the address mux of the memory.
- Control Unit. Takes in opcode from the instruction and outputs the programmed signals to different components of the datapath.
- Accumulator register. Has a three input multiplexer placed before the input. These three inputs are from the R register, data from memory, or data outputted from the ALU.
- R register. Another register for holding data.
- ALU. Performs addition and subtraction, as well as logical operations such as AND, OR, NOT, and XOR. Also has a pass-through option.
- Program Counter (PC) register. This keeps track of which instruction should go next. It has a three input multiplexer placed before the register's input. The three inputs are the current value, the current value + 1, and the address from the MDA register. There is one output.

States (b = binary):
- fetch = 4'b0000;
- decode = 4'b0001;
- getah (get higher bits of address) = 4'b0010;
- getal (get lower bits of address) = 4'b0011;
- loaddata = 4'b0100;
- storedata = 4'b0101;
- jumpinstr = 4'b0110;
- alu = 4'b0111;
- r_to_ac = 4'b1000;
- ac_to_r = 4'b1001;
- ahfetch (fetch higher bits of address) = 4'b1010;
- pcinc (increment PC counter by 1) = 4'b1011;

Opcodes (h = hexadecimal):
- NOP = 8'h00;
- LDAC (load data to accumulator) = 8'h01;
- STAC (store data from accumulator) = 8'h02;
- MVAC (move data to accumulator) = 8'h03;
- MOVR (move data to R)= 8'h04;
- JUMP = 8'h05;
- JMPZ (jump if zero) = 8'h06;
- JPNZ (jump if not zero) = 8'h07;
- ADD = 8'h08;
- SUB = 8'h09;
- INAC (increment accumulator by 1) = 8'h0A;
- CLAC (clear accumulator by 1) = 8'h0B;
- AND = 8'h0C;
- OR = 8'h0D;
XOR = 8'h0E;
NOT = 8'h0F;
