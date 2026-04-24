# LLM-Based Verilog Adder Generation and Verification Package

Selected adders: RCA8 and CLA8, using the professor-provided golden files.

## Folder contents
- `golden/`: professor repo files: RCA4, RCA8, CLA4, CLA8
- `generated/`: LLM-style regenerated RCA8 and CLA8 designs
- `testbenches/`: internal-signal-checking testbenches
- `scripts/`: Yosys synthesis, equivalence, optimization, and plotting scripts
- `report/`: draft final report
- `logs/`: place simulation and synthesis outputs here

## Run simulations
```bash
iverilog -o logs/rca8_sim generated/RCA8_llm_generated.v testbenches/RCA8_tb.v
cd logs && vvp rca8_sim > RCA8_simulation_output.txt && cd ..

iverilog -o logs/cla8_sim generated/CLA8_llm_generated.v testbenches/CLA8_tb.v
cd logs && vvp cla8_sim > CLA8_simulation_output.txt && cd ..
```

## Run Yosys synthesis
```bash
cd scripts
python run_yosys.py ../generated/RCA8_llm_generated.v RCA8
python run_yosys.py ../generated/CLA8_llm_generated.v CLA8
```

## Run Yosys equivalence
```bash
cd scripts
yosys -s equiv_check_rca8.ys
yosys -s equiv_check_cla8.ys
```

## Run optimization loop
```bash
cd scripts
export OPENAI_API_KEY=YOUR_KEY_HERE
python optimize_adder.py --baseline ../golden/RCA8.v --mode area --max_iter 10
python optimize_adder.py --baseline ../golden/RCA8.v --mode delay --max_iter 10
python optimize_adder.py --baseline ../golden/RCA8.v --mode balanced --max_iter 10
```
