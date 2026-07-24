# LLM4ChipDesign — Generative AI for Chip Design

Coursework and homework assignments for the **MS Project: Generative AI based Chip Design**, NYU Tandon School of Engineering (Spring).

This repository tracks my weekly assignments and Colab exercises, each building toward the final MS project on LLM-driven automation across the chip design stack.

## Course Info

- **Course:** MS Project (1.5 or 3 Credits) — Generative AI based Chip Design
- **Developed by:** Prof. Ramesh Karri, Prof. Siddharth Garg (NYU); Prof. Jeyavijayan (JV) Rajendran (TAMU); Prof. Ozgur Sinanoglu (NYU-AD); Prof. Kanad Basu (RPI)
- **Instructor:** Prof. Ramesh Karri
- **Co-Instructor:** Dr. Weihua Xiao
- **Schedule:** Saturdays, 11:00 AM–1:00 PM (Zoom)
- **Course Repository:** [github.com/FCHXWH823/LLM4ChipDesign](https://github.com/FCHXWH823/LLM4ChipDesign)

## About the Course

This course explores how Large Language Models (LLMs) are transforming computer chip design — from converting software code into hardware descriptions, to generating circuits from natural language, to automatically creating hardware validation tests.

**Featured Topics:**

| Module | Focus |
|---|---|
| **LLM4Verilog** | Automatic generation of Verilog using LLMs |
| **LLM4Validation** | Automatic generation of SystemVerilog assertions & testbenches using LLMs |
| **LLM4Security** | Automatic detection of hardware security vulnerabilities using LLMs |
| **LLM4HLS** | Automatic High-Level Synthesis (C-to-HDL) using LLMs |
| **LLM4Analog** | Automatic generation of analog circuit netlists from schematics |

Each module introduces core concepts and theory, followed by hands-on problem-solving using GenAI-based tools, with weekly homework/Colab notebooks feeding into a final course project.

## Repository Structure

Assignments in this repo correspond to the weekly course schedule below. Each folder/notebook maps to a specific module's homework or Colab exercise.

## Weekly Outline

| Week | Module | Activity |
|---|---|---|
| 1 | AutoChip: Generate Functional Verilog | Intro to LLM-based Verilog Generation |
| 2 | Colab: Hands-on AutoChip | |
| 3 | LLM-aided Testbench Generation | LLM-aided Testing Methodologies |
| 4 | Colab: FSM Testbench Generation | |
| 5 | VeriThoughts: Verilog Code Gen using Reasoning and Formal Verification | Formal Verification in Hardware Design & Integration into LLM-aided Verilog Generation |
| 6 | Colab: Use VeriThoughts to Generate Verilog | |
| 7 | GenAI-based Hierarchical Verilog | Hierarchical Design Lab |
| 8 | Colab: Hierarchical Verilog | Project Proposal |
| 9 | GenAI-aided Verilog for Prefix Adders | Design Space Exploration — Prefix Adders |
| 10 | Colab: PrefixLLM to Generate Adder Circuit | |
| 11 | Natural Language → SystemVerilog Assertion | Translate Natural Language to SystemVerilog Assertions |
| 12 | Colab: NL2SVA Tools | Project Presentation |
| 13 | Bridge Software-to-Hardware Design Gap | High-Level Synthesis with LLMs |
| 14 | Colab: C → HLS Translation | Final Project Submission |
| 15 | GenAI-aided Hardware Security | IP Piracy |
| 16 | Colab: LLM for IP Piracy | |
| 15 | Masala-CHAI: Large-Scale SPICE Netlist Dataset for Analog Circuits | GenAI to Generate Analog Circuits from Schematics |
| 16 | Colab: Masala-CHAI to Generate SPICE Netlists | |

*(Note: weeks 15–16 appear twice in the original syllabus, covering both the hardware security and analog circuit modules.)*

## Getting Started

- All Colab notebooks are designed to run directly in-browser with no local installation required.
- Course-wide tutorials, papers, and resources live in the [course repo's `colab-scripts` folder](https://github.com/FCHXWH823/LLM4ChipDesign).
- Homework in this repo builds progressively — earlier weeks (Verilog generation, testbenches) establish the foundation for later, more advanced modules (hierarchical design, HLS, security, analog).

## Advisors

- Prof. Ramesh Karri, NYU Tandon
- Dr. Weihua Xiao, NYU Tandon

## Related

This coursework directly supports my MS project, **LLM4ChipDesign**, which explores LLM-driven automation across Verilog/SystemVerilog RTL generation, testbench/assertion synthesis, hardware security vulnerability detection, and C-to-HLS translation.
