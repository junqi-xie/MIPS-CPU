# MIPS-CPU

This repository contains the lab projects for ICE2603 (2021 Spring). This project aims to implement a pipelined MIPS CPU on an FPGA board.

Note: the sequential CPU is available at branch `seq`.

## Environment Setup

* This repository was developed with Quartus Prime 20.1.1.
* The circuits implemented were simulated with ModelSim, and tested on Intel (Altera) DE1-SoC Board.
* The compiled program file `computer.sof` can be loaded and executed directly on the board.

## Specifications

### Instructions

The instructions implemented are listed below.

| Instruction | Format | `opcode` / `funct` |
| -- | -- | -- |
| Add | `add $rd, $rs, $rt` | `0` / `20` |
| Add Unsigned | `addu $rd, $rs, $rt` | `0` / `21` |
| Subtract | `sub $rd, $rs, $rt` | `0` / `22` |
| Subtract Unsigned | `subu $rd, $rs, $rt` | `0` / `23` |
| And | `and $rd, $rs, $rt` | `0` / `24` |
| Or | `or $rd, $rs, $rt` | `0` / `25` |
| Xor | `xor $rd, $rs, $rt` | `0` / `26` |
| Nor | `nor $rd, $rs, $rt` | `0` / `27` |
| Set Less Than | `slt $rd, $rs, $rt` | `0` / `2a` |
| Set Less Than Unsigned | `sltu $rd, $rs, $rt` | `0` / `2b` |
| Jump Register | `jr $rs` | `0` / `08` |
| Shift Left Logical | `sll $rd, $rt, shamt` | `0` / `00` |
| Shift Right Logical | `srl $rd, $rt, shamt` | `0` / `02` |
| Shift Right Arithmetic | `sra $rd, $rt, shamt` | `0` / `03` |
| Add Immediate | `addi $rt, $rs, immediate` | `8` |
| Add Immediate Unsigned | `addiu $rt, $rs, immediate` | `9` |
| Set Less Than Immediate | `slti $rt, $rs, immediate` | `a` |
| Set Less Than Immediate Unsigned | `sltiu $rt, $rs, immediate` | `b` |
| And Immediate | `andi $rt, $rs, immediate` | `c` |
| Or Immediate | `ori $rt, $rs, immediate` | `d` |
| Xor Immediate | `xori $rt, $rs, immediate` | `e` |
| Load Upper Immediate | `lui $rt, immediate` | `f` |
| Load Word | `lw $rt, offset($rs)` | `23` |
| Store Word | `sw $rt, offset($rs)` | `2b` |
| Branch on Equal | `beq $rs, $rt, label` | `4` |
| Branch on Not Equal | `bne $rs, $rt, label` | `5` |
| Jump | `j label` | `2` |
| Jump and Link | `jal label` | `3` |

### I/O Ports

The I/O ports and their "addresses" are listed below.

| I/O | Position | Address |
| -- | -- | -- |
| Clock | `CLOCK_50` |  |
| Reset | `KEY0` |  |
| Overflow | `LEDR0` |  |
| Input 1 | `SW{9-5}` | `0xa0` |
| Input 2 | `SW{4-0}` | `0xa4` |
| Output 1 | `HEX{5-4}` | `0xb0` |
| Output 2 | `HEX{3-2}` | `0xb4` |
| Output 3 | `HEX{1-0}` | `0xb8` |

### Example Program

The example program for this project is adapted from *Computer Systems: A Programmer's Perspective: Architecture Lab*. The assembly program is rewritten using MIPS instructions.

The C source is in `ncopy.c`. The corresponsing MIPS source is in `ncopy.s`.

## License

* My codes are provided under GNU General Public License v3.0. See `LICENSE` for more information.
