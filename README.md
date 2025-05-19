NICNAC16
========
[![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)

Learning FPGAs, starting with a 16-bit CPU design

See [instruction_set.md](docs/instruction_set.md) for details on the instruction set.

![main cpu schematics](dunc16%20main_unit%20schematics%20.png)

![simulation, with NOP, LDA, ADD and JMP x working](pictures/dunc16sim003.png)

## Setup

Install the required build tools (g++, make, cppcheck and iverilog) using the provided script:

```sh
./setup.sh
```


## Build and Test

Run the default Makefile target to lint the HDL sources, execute the Memory testbench and create build artifacts:

```sh
make
```
