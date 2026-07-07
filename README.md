🚀 RV32I Multi-Cycle Verilog Processor

📌 Project Overview

This project is a fully functional,  32-bit RISC-V Processor implementing the RV32I Base Integer Instruction Set. It is designed using a Multi-Cycle Finite State Machine (FSM) architecture rather than a single-cycle datapath, making it highly resource-efficient and realistic to how actual hardware schedules execution.

The processor is built with modularity in mind, tested with raw machine code (including factorial and arithmetic shift edge-cases)

⚙️ How It Works (The Execution Flow)
The processor is governed by a central FSM Controller.v which dictates the flow of data through the datapath over multiple clock cycles. The states are:

1.FETCH: The FSM commands the Instruction Fetch Unit to pull the 32-bit instruction from instruction memory using the Program Counter (PC).

2.DECODE: The Instruction Decode Unit acts as a wire-splitter, routing rs1, rs2, and rd addresses and mapping the immediate values based on the instruction type.

3.EXECUTE: The Execution Unit (containing the ALU) performs mathematical, logical, and shift operations (sll, srl, sra). Branch targets are calculated here.

4.MEMORY: Handles reading from or writing to Data Memory (lw, sw). 

5.WRITEBACK: A top-level multiplexer controlled by the FSM routes the final data (from the ALU, Memory, or PC+1) back into the Register File.

📜 Supported Instruction Set (RV32I)
The processor supports the 6 core RISC-V instruction formats.

Implemented Instructions & Opcodes (RV32I Base)


[1] R-Type Instructions (Register Math & Logic)
Format: Funct7(7) | Rs2(5) | Rs1(5) | Funct3(3) | Rd(5) | Opcode(7)
Base Opcode: 0110011

=======================================================

* ADD  -> Funct3: 000 | Funct7: 0000000 | rd = rs1 + rs2
* SUB  -> Funct3: 000 | Funct7: 0100000 | rd = rs1 - rs2
* SLL  -> Funct3: 001 | Funct7: 0000000 | rd = rs1 << rs2 (Logical Shift)
* SLT  -> Funct3: 010 | Funct7: 0000000 | rd = (rs1 < rs2) ? 1 : 0 (Signed)
* XOR  -> Funct3: 100 | Funct7: 0000000 | rd = rs1 ^ rs2
* SRL  -> Funct3: 101 | Funct7: 0000000 | rd = rs1 >> rs2 (Logical Shift)
* SRA  -> Funct3: 101 | Funct7: 0100000 | rd = rs1 >>> rs2 (Arithmetic Shift)
* OR   -> Funct3: 110 | Funct7: 0000000 | rd = rs1 | rs2
* AND  -> Funct3: 111 | Funct7: 0000000 | rd = rs1 & rs2

=======================================================

[2] I-Type Instructions (Immediate Math & Logic)
Format: Imm[11:0] | Rs1(5) | Funct3(3) | Rd(5) | Opcode(7)
Base Opcode: 0010011

=======================================================

* ADDI  -> Funct3: 000 | rd = rs1 + imm
* SLTI  -> Funct3: 010 | rd = (rs1 < imm) ? 1 : 0 (Signed)
* XORI  -> Funct3: 100 | rd = rs1 ^ imm
* ORI   -> Funct3: 110 | rd = rs1 | imm
* ANDI  -> Funct3: 111 | rd = rs1 & imm
* SLLI  -> Funct3: 001 | Funct7: 0000000 | Shift Left Logical Imm
* SRLI  -> Funct3: 101 | Funct7: 0000000 | Shift Right Logical Imm

=======================================================

[3] I-Type Instructions (Memory Loads)
Format: Imm[11:0] | Rs1(5) | Funct3(3) | Rd(5) | Opcode(7)
Base Opcode: 0000011

=======================================================

* LB  -> Funct3: 000 | Load Byte (Sign-Extended)
* LH  -> Funct3: 001 | Load Halfword (Sign-Extended)
* LW  -> Funct3: 010 | Load Word
* LBU -> Funct3: 100 | Load Byte (Zero-Extended)
* LHU -> Funct3: 101 | Load Halfword (Zero-Extended)

=======================================================

[4] S-Type Instructions (Memory Stores)
Format: Imm[11:5] | Rs2(5) | Rs1(5) | Funct3(3) | Imm[4:0] | Opcode(7)
Base Opcode: 0100011

=======================================================

* SB -> Funct3: 000 | Store Byte
* SH -> Funct3: 001 | Store Halfword
* SW -> Funct3: 010 | Store Word

=======================================================

[5] B-Type Instructions (Branches)
Format: Imm[11:5] | Rs2(5) | Rs1(5) | Funct3(3) | Imm[4:0] | Opcode(7)
Base Opcode: 1100011

=======================================================

* BEQ  -> Funct3: 000 | Branch if rs1 == rs2
* BNE  -> Funct3: 001 | Branch if rs1 != rs2
* BLT  -> Funct3: 100 | Branch if rs1 < rs2 (Signed)
* BGE  -> Funct3: 101 | Branch if rs1 >= rs2 (Signed)

=======================================================

[6] U-Type & J-Type (Jumps and Upper Immediates)

=======================================================

* LUI   -> Type: U | Opcode: 0110111 | Load Upper Immediate
* AUIPC -> Type: U | Opcode: 0010111 | Add Upper Immediate to PC
* JAL   -> Type: J | Opcode: 1101111 | Jump and Link
* JALR  -> Type: I | Opcode: 1100111 | Funct3: 000 | Jump and Link Register

** Hardware Modules & Components

The processor is  modular to reflect standard VLSI design practices. Below is the breakdown of the Verilog files and their specific responsibilities:

RISC_V.v (Top-Level Wrapper): The main file that instantiates all other modules and wires them together. It contains the top-level multiplexer for Writeback routing.

Controller.v (The FSM Brain): Generates all control signals (Write Enables, Memory Read/Write, ALU Select Lines). It dictates which state the processor is currently in and skips unnecessary states (like skipping Memory/Writeback during a Branch).

IFU.v (Instruction Fetch Unit): Manages the Program Counter (PC). It calculates PC + 4 natively and handles overriding the PC when the Controller signals a Jump or taken Branch.

IM.v (Instruction Memory): A 32-bit wide logical memory block containing the assembled machine code.[1KiB]

IDU.v (Instruction Decode Unit): Purely combinational logic that slices the 32-bit Instruction Register (IR) into standard RISC-V fields (rs1, rs2, rd, opcode, etc.). It also houses the ImmGen which correctly pieces together and immediate values.

REG_bank.v / registers.v (Register File): Contains thirty-two 32-bit flip-flop registers. Includes combinational asynchronous reads, synchronous writes, and a hardwired 0 at index x0.

IEX.v (Instruction Execute Unit): The execution wrapper. It receives data from the Register File and immediate values, routing them appropriately to the ALU. It also houses the dedicated adder for calculating relative branch targets.

ALU.v (Arithmetic Logic Unit): The mathematical core. Utilizes a 4-bit select line to perform all required RV32I computations. .

Data_Memory.v / DM.v (Data RAM): Byte-addressable read/write memory. It utilizes ternary operators and bit-slicing to output proper word, halfword, and byte lengths, applying zeros or sign-bits depending on the specific load instruction.

tb.v (Testbench): Contains bare-metal machine code arrays injected into Instruction Memory to verify mathematical loops (e.g., Factorial calculation).


simulation tool used is icarus verilog & GTK wave 

     
