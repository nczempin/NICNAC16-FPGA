# DUNC16 Instruction Set

This document summarizes the 16‑bit instruction format used by the NICNAC16 CPU and lists the opcodes implemented in `control_unit.v`.

## Instruction Format

Each instruction is 16 bits wide. The upper four bits `[15:12]` select the opcode. The remaining bits carry an address or immediate value depending on the instruction.

```
15            12 11                                0
+---------------+----------------------------------+
|    opcode     | address / immediate              |
+---------------+----------------------------------+
```

## Opcodes

| Opcode | Mnemonic | Description |
|-------:|----------|-------------|
| `0x0` | `NOP` | No operation |
| `0x1` | `JMP` | Jump to the address in the lower 12 bits |
| `0x2` | `BL`  | Branch with link (call subroutine) |
| `0x3` | `RET` | Return from subroutine |
| `0x4` | `LDA` | Load accumulator from memory |
| `0x5` | `STA` | Store accumulator to memory |
| `0x6` | `ADD` | Add memory value to accumulator |
| `0x7` | `BAZ` | Branch if accumulator zero (`AZ` flag set) |
| `0x8` | `BAN` | Branch if accumulator negative (`AN` flag set) |
| `0xF` | `DIO` | Device input/output |

The opcodes correspond to assignments in `src/control_unit.v:150-165`.

## DIO Instruction

`DIO` performs device I/O. Bit 0 of the instruction selects the direction: `0` for output and `1` for input. Bits `[9:5]` become the `DEVCTRL` field and bits `[4:0]` form `DEVADDRESS` as seen in `control_unit.v`:

```
assign IO = ir_out[0];
assign DEVADDRESS = md_out[4:0];
assign DEVCTRL = md_out[9:5];
```

During execution `DIO` loads or stores data through the shared bus using these fields.
