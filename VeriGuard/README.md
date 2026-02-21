# FIFO Synthesis with Yosys

This directory contains Yosys synthesis scripts for the VeriGuard-verified FIFO design.

## Files
- `synth_simple.ys` - Basic synthesis script (recommended)
- `synth_fifo.ys` - Advanced synthesis with standard cell mapping
- Output files will be generated in this directory

## Quick Start

### Run Basic Synthesis
```bash
cd verification-gap-analyzer/synth
yosys synth_simple.ys
```

### Run Advanced Synthesis (if standard cell library available)
```bash
cd verification-gap-analyzer/synth
yosys synth_fifo.ys
```

## Output Files

After synthesis, you'll get:
- `synth_simple_fifo.v` - Synthesized Verilog netlist
- `synth_simple_fifo.json` - JSON representation for analysis
- `simple_fifo_synth.dot` - Graphical representation (DOT format)

## View Results

### Statistics
The synthesis script prints detailed statistics including:
- Number of cells used
- Cell types (flip-flops, logic gates, etc.)
- Estimated area

### Visualize Design
Convert DOT file to PNG (requires Graphviz):
```bash
dot -Tpng simple_fifo_synth.dot -o simple_fifo_synth.png
```

Or view DOT file directly:
```bash
xdot simple_fifo_synth.dot
```

## Synthesis Flow

The script performs these steps:
1. **Read Design** - Load SystemVerilog source
2. **Elaborate** - Set top module and check hierarchy
3. **High-Level Synthesis**:
   - Process conversion (always blocks → gates)
   - FSM extraction
   - Memory inference
   - Optimizations
4. **Technology Mapping** - Map to logic gates
5. **Cleanup** - Remove unused logic
6. **Output** - Generate netlist and reports

## What Was Synthesized

The VeriGuard-verified FIFO with these features:
- ✅ Write-when-full protection
- ✅ Read-when-empty protection
- ✅ Simultaneous read+write support
- ✅ Count integrity [0..4]
- ✅ Data integrity verification

## Next Steps

1. Review synthesis statistics
2. Check for timing/area optimization opportunities
3. Run post-synthesis simulation
4. Proceed to place & route (if targeting FPGA/ASIC)
