Regrettably, I did not document my code very well when I completed this project two years ago. So, I'm not able to explain exactly how the processor works on a detailed level. However, I am still proud that I managed to make a processor on my own, albeit a small one.
The design is based off of criteria given by the professor of the course. The course was Digital System Architecture and Design.

These are the main components of the design:
1. Cache memory (8 x 64 bits). Holds instructions and data.
2. Instruction register. Passses the instruction part of the instruction to the Control Unit. Has three inputs and one output. The address input has a two input mux. The inputs are the program counter value and the data from the MDA register. The other two inputs of the memory are the output from the ALU and write enable. The output is the data from memory.
4. Memory Data Address register. Holds the upper part of the instruction (the address) to pass to the address mux of the memory.
5. Control Unit.
6. Accumulator register. Has a three input mux placed before the input. These three inputs are from the R register, data from memory, or data outputted from the ALU.
7. R register.
8. ALU. Performs addition and subtraction, as well as logical operations such as AND, OR, NOT, and XOR. Also has a pass-through option.
9. Program Counter register. This keeps track of which instruction should go next. It has a three input mux placed before the register's input. The three inputs are the current value, the current value + 1, and the address from the MDA register. There is one output.

The memfile contains instructions that are used to test the processor. Although I do not remember what exactly those instructions were, I do know that the processor was able to complete all instructions correctly.
