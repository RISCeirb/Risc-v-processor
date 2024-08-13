# RISC-V Project

To clone the project:
`git clone https://github.com/RISCeirb/Risc-v-processor.git`

## Introduction

This project explores the RISC-V instruction set, an open-source architecture designed to be simple, extensible, and modular. The processeur implemented is an adapted implementation of the paterson processeur for RISC-V  in VHDL.

## Overview of Different Processors with the RV32I Base Instruction Set, version 2.2

This repository provides simple implementations of various RISC-V processors and tests them using ModelSim and [Rars](https://github.com/TheThirdOne/rars) _RISC-V Assembler and Runtime Simulator_.

LAST VERSION :
- RV32IM

The available processors have the RV32I Base Instruction Set: (WITHOUT CSR AND FENCE INSTRUCTION)
- Monocycle
- Pipeline
- Pipeline with Branch Predictor

### Monocycle Processor

A basic processor that executes one instruction per cycle.

### Pipeline Processor

A 5-stage pipeline processor with the following stages:

- **IF (Instruction Fetch)**: The program counter provides the address of the new instruction.
- **ID (Instruction Decode)**: The instruction is sent to the control unit for decoding for the ALU.
- **EX (Execute)**: The ALU performs calculations for jumps and branches, and a unit calculates the new PC.
- **MEM (Memory Access)**: Load or store data from memory.
- **WB (Write Back)**: Write data into the destination register.

### Pipeline with Branch Predictor

This processor uses a cache to predict whether a branch will be taken or not. (See the references for more explication)

- **Direct-mapped memory**: 10-bit index, 20-bit tag, and two bits for branch prediction.

| PC       | TAG_PC | INDEX_PC | Useless bit (address in byte) |
|:---------|:------:|:--------:|:-----------------------------:|
| PC       | 31-12  |  11-2    | Useless bit (address in byte) |

**History table:**

| VALID | INDEX | TAG | Target PC | 2 bits Prediction |
|:------|:-----:|:---:|:---------:|:-----------------:|
| VALID | 0     | TAG | Target PC | 2 bits Prediction |
| VALID | 1     | TAG | Target PC | 2 bits Prediction |
| VALID | 2     | TAG | Target PC | 2 bits Prediction |
| ...   | ...   | ... | ...       | ...               |
| VALID | 511   | TAG | Target PC | 2 bits Prediction |

## FSM of the 2-bit Branch Prediction

![Schematic of the 2-bit predictor](https://github.com/RISCeirb/Risc-v-processor/blob/main/Picture/2%20bit%20predictor.png)

## Overview of the RISC-V Instruction Set

RISC-V is a reduced instruction set computer (RISC) architecture that offers flexibility and efficiency for modern processors. Being open-source, it encourages collaboration and innovation without the constraints of proprietary licenses.

### Instruction Formats

The RISC-V instruction formats are:

1. **R-Type**: For arithmetic and logical operations.
2. **I-Type**: For operations with immediate values and loading data into registers.
3. **S-Type**: For store instructions.
4. **B-Type**: For branch instructions.
5. **U-Type**: For large immediate values.
6. **J-Type**: For jump instructions.

![Instruction format](https://github.com/RISCeirb/Risc-v-processor/blob/main/Picture/Instruction%20type.png)


## Processor Testing

### Getting Started with Rars

To test our processors, we use ModelSim and Rars. An example source code is available on the Rars page, and a bubble sort implementation in RISC-V is provided to test the processors.

![Rars](https://github.com/RISCeirb/Risc-v-processor/blob/main/Picture/RARS%20image.png)

You can write your own assembly code with Rars and test it on the processors.

#### Steps to Generate Required Files

1. Write your assembly code in Rars.
2. **Run > Assembly**: Run the assembly code to view the instruction, data memory, and register file.
3. **File > Dump to File > .data**: Create the txt file for data memory. (You will probably have to change the writing format to make this file works)
4. **File > Dump to File > .text**: Create the txt file for instruction memory.

You can find an example of this two file in the file with the vhdl code.

### Getting Started with modelsim

You can look in the reference the tutoriel for the modelsim installation.

- Create a new project
- Add all the VHDL file of one of the processeur and also add the txt file to implement in the instruction and data memory.
- Compile all the file ( you will need to compile more than one time )
- Run simulation > Add wave >  ( you can set the time to 10 us and make the data in hexadecimal in the simulation property)
- Rerun and all the signal will be added

### Use of RISC-V cross complier to test c code 

You will need to install the [Risc-v cross complier](https://github.com/riscv-collab/riscv-gnu-toolchain), the final objective will be to test the processor with some signal processing application available on the code c section.

Here the instruction to compile the assembly code with the risc_v isa version rv32i. `-march=64` enable to chose the extention of the compilier and `-mabi=ilp32` give access to rv32 because the compilier is set on rv64.
- `riscv64-unknown-linux-gnu-gcc -march=rv32i -mabi=ilp32 -S -o test_asm.s test_asm.c`
- Gray-filter for BMP picture
- 

## “M” Standard Extension for Integer Multiplication and Division, Version 2.0

M-extension enable to do a multiplication and division between two register, the div_mul_unit can be add as a second alu and a new flag need to be added to stall the pipeline during the time that the calculation is running because it's take along time.
Two version of this unit have been added, the test-bench will arrive later. 



## “A” Standard Extension for Atomic Instructions, Version 2.0

To be completed .. (futur VHDL File will be added)

## Image processing application on risc-v processor

To be completed .. 

## Future of the project

- Note that the CSR and FENCE instructiion are not implemented in this processeur even if present in the controle path.
- Possibility to add extention to the risc-v proccessor
- Use of different algorithme to test the processor (section code c in construction) (image processing)
- Addition of bootloader to implement the processor on fpga


## References

- [Documentation RISC-V](https://github.com/suryakantamangaraj/AwesomeRISC-VResources?tab=readme-ov-file#cores)
- [RISC-V Specification v2.2](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)
- [*Computer Organization and Design MIPS Edition: The Hardware/Software Interface* by David A. Patterson and John L. Hennessy ](https://theswissbay.ch/pdf/Books/Computer%20science/Computer%20Organization%20and%20Design-%20The%20HW_SW%20Inteface%205th%20edition%20-%20David%20A.%20Patterson%20%26%20John%20L.%20Hennessy.pdf)
- [Cache Documentation 1](https://cseweb.ucsd.edu/classes/su07/cse141/cache-handout.pdf)
- [Cache Documentation 2](https://courses.cs.duke.edu/spring09/cps104/lectures/2up-lecture17.pdf)
- [ModelSim Installation Tutorial](https://www.youtube.com/watch?v=Ubcm996KKhU)
- [Rars and Assembly in RISC-V](https://github.com/darnuria/esgi-riscv)
- [Risc-v cross complier](https://github.com/riscv-collab/riscv-gnu-toolchain)
- [BMP-Processing](https://stackoverflow.com/questions/54173733/convert-rgb-to-grayscale-in-bare-c)
- [M-extension explication](https://domipheus.com/blog/designing-a-risc-v-cpu-in-vhdl-part-21-multi-cycle-execute-for-multiply-and-divide/)
- [Division Algorithm](https://en.wikipedia.org/wiki/Division_algorithm)
- [A-extension explication](https://www.digikey.fr/fr/blog/how-the-risc-v-atomic-extension-gives-you-superior-bit-manipulation-capabilities)
- Use of CHAT GPT for some parts of TEST BENCH and README writing

## Common Issues

- Ensure that the assembly code generated by Rars (.data and .text files) is placed in the same directory as the VHDL file of the processor you are using for simulation.
- Note that CentOS 7 is not compatible with Rars.
