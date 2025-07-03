(Updating in Progress)
How it works:
1. Takes in a 16 bit address and optionally 8 bits of data.
2. If WE (write enable) is enabled, the data is written to memory. If not, the data from that is stored at the address in memory is outputted.

That's the simplest way of looking at it, but here's some more detail:
1. The 16 bit address is inputted.
2. The lower half of the address is given to the buffer buffadrL and the upper half is given to the buffer buffadrH.
3. The upper half of the address is then passed to adrH, a register, and the lower half is passed to MDA, another register.
4. 
5. 
