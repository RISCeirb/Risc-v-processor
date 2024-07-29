# RISC-V Project

## Introduction

This project explores the RISC-V instruction set, an open-source architecture designed to be simple, extensible, and modular. RISC-V is used in embedded systems and supercomputers.

## Introduction to Different Processors

The aim of this repository is to provide simple versions of RISC-V processors and to test them using ModelSim and [Rars](https://github.com/TheThirdOne/rars) _RISC-V Assembler and Runtime Simulator_.

Three types of processors are available: Monocycle, pipeline, and pipeline out-of-order.

### Monocycle Processor

A slow processor that executes one instruction per cycle.

### Pipeline Processor

A 5-stage pipeline with the following stages:

- **IF (Instruction Fetch):** The program counter provides the address of the new instruction.
- **ID (Instruction Decode):** The instruction is sent to the control unit for decoding for the ALU.
- **EX (Execute):** The ALU calculates the bit for jumps and branches, and a unit calculates the new PC.
- **MEM (Memory Access):** Load or store data from the memory.
- **WB (Write Back):** Write data into the destination register.

### Pipeline with Branch predictor

Uses a cache to predict if the branch is taken or not.

- **Direct-mapped memory:** 10-bit index, 20-bit tag, and two bits for branch prediction.

USE THE INDEX AND THE TAG OF THE PC

| PC     | TAG_PC| INDEX_PC| Useless bit (address in byte) |
|:-------|:---:|:-----------:|:----------:|
| PC     | 31-12 |  11-2   | Useless bit (address in byte) |

History table : 

|VALID |INDEX| TAG | Target PC | 2 bits Prediction |
|:-------|:---:|:-----------:|:----------:|:----------:|
|VALID |0| TAG | Target PC | 2 bits Prediction |
|VALID |1| TAG | Target PC | 2 bits Prediction |
|VALID |2| TAG | Target PC | 2 bits Prediction |
|VALID |...| TAG | Target PC | 2 bits Prediction |
|VALID | 511 |TAG | Target PC | 2 bits Prediction |


## FSM of the 2 bit branch prediction : 

![Schematic of the 2 bit predictor](https://github.com/RISCeirb/Risc-v-processor/blob/main/Picture/2%20bit%20predictor.png)

## Overview of the RISC-V Instruction Set

RISC-V is a reduced instruction set computer (RISC) processor architecture offering flexibility and efficiency for modern processors. It is open source, encouraging collaboration without the constraints of proprietary licenses.

## Different type of instruction 

Les formats d'instructions RISC-V sont :

1. **R-Type** : Pour les opérations arithmétiques et logiques.
2. **I-Type** : Pour les opérations avec des valeurs immédiates et le chargement.
3. **S-Type** : Pour les instructions de stockage.
4. **B-Type** : Pour les instructions de branchement.
5. **U-Type** : Pour les grandes valeurs immédiates.
6. **J-Type** : Pour les instructions de saut.

![Schematic of the 2 bit predictor](https://github.com/RISCeirb/Risc-v-processor/blob/main/Picture/2%20bit%20predictor.png)


## Getting Started with Rars

To test our processor, we will use ModelSim and Rars.

An example source code is available on the Rars page, and a bubble sort implemented in RISC-V is provided to test our different processors.

## References

- [RISC-V Specification v2.2](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf)
- *Computer Organization and Design MIPS Edition: The Hardware/Software Interface* by David A. Patterson and John L. Hennessy
- [ModelSim Installation Tutorial](https://www.youtube.com/watch?v=Ubcm996KKhU)
- [Rars and assembly in Risc v](https://github.com/darnuria/esgi-riscv)

## Issue that can be recurent

- RARS will transform the assembly code into two file that need to be added in the same repository that the VHDL file of the processor you use for the simulation.
- Centos 7 isn't compatible with RARS

