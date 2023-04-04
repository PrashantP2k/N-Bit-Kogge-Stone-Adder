# N-Bit-Kogge-Stone-Adder

Kogge-Stone adder is considered to be the fastest state-of-the-art adder structure that has been developed so far. It has the least delay as compared to any other adder. This adder is a part of a class of adders known as Carry Prefix Adders (CPAs). Other famous adders like the Brent-Kung adder or the Han-Carlson adder (both being CPA adders) sacrifice a little bit of speed for lesser area and power consumption.

This project contains the Verilog implementation of N-Bit Kogge-Stone adder.

**Note**: N should be a power of 2.

Simulation can be done on edaplayground.com. Link to its public playground is [here](https://www.edaplayground.com/x/M488).

The results have been compiled with N = 64.

Simulation was done using Icarus Verilog version 12.0 (devel) (s20150603-1539-g2693dd32b).

RTL - GDSII flow was done with the help of [Zero ASIC](https://www.zeroasic.com/)'s Silicon Compiler using the skywater130 PDK.
