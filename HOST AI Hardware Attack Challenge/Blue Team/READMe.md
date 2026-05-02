# Blue Team Hardware Trojan Detection README

## Overview

This repository contains our Blue Team submission for the hardware Trojan detection phase. The goal of this phase was to analyze RTL designs that may have been modified with hardware Trojans and identify any suspicious or malicious logic using generative AI.

The provided designs included numbered project copies based on open-source RTL designs such as:

- secworks AES Core
- FreeCores Ethernet MAC
- openhwgroup cv32e40p RISC-V IP

Each project could contain between 0 and 3 Trojans. Our task was to identify Trojan-infected files, report the exact line numbers containing Trojan logic, and submit each detected Trojan through the required submission form.

## AI-Based Detection Method

All Trojan detection was performed using generative AI. We used ChatGPT through the web interface as the primary AI system for analyzing the RTL files. The AI was given the Verilog/SystemVerilog files for each project and was prompted to inspect the design for suspicious Trojan-like behavior.

The prompt used for analysis was generally structured as follows:

> You have to detect any Trojans inserted in these RTL codes. Some of these may or may not have Trojans inserted. Correctly identify where the Trojans were inserted and state which line of the code has the Trojan, if there is one.

The AI was instructed to:

1. Inspect each uploaded RTL file independently.
2. Identify suspicious logic that deviates from expected module behavior.
3. Classify the suspicious behavior as a possible hardware Trojan.
4. Report the exact file name and line number or line range.
5. Avoid reporting uncertain issues unless there was concrete evidence in the RTL.
6. Explain the trigger condition and payload behavior when a Trojan was found.

## Interaction Method

The interaction with the AI was done through the ChatGPT website UI. RTL files were uploaded directly into the chat session, and the AI reviewed the code contents to identify possible Trojan logic.

For each design, the AI was asked to return a structured result including:

- Whether a Trojan was found
- The affected file name
- The suspicious line number or line range
- The suspicious code or behavior
- The reason the logic was considered Trojan-like
- Any files where no concrete Trojan was found

An example AI analysis identified a Trojan in `aes.v`, where a hidden debug address exposed part of the AES key through the normal memory-mapped read interface. The AI flagged `ADDR_DEBUG = 8'h2f` and the corresponding read behavior returning `key_reg[0]`, classifying it as an information leakage Trojan.

## Model Used

The primary model used for analysis was ChatGPT.

The model was used to reason about the RTL structure, identify suspicious control or data paths, and explain whether the detected behavior matched known Trojan categories such as:

- Information leakage
- Denial of service
- Triggered functionality changes
- Hidden debug/backdoor access
- Unexpected state modification
- Rare-condition payload activation

## Supporting Framework

No golden-reference diffing tool was used. We did not compare the modified RTL against a known-good copy of the design.

The supporting workflow consisted of:

1. Uploading the RTL files for a numbered project to the AI system.
2. Asking the AI to inspect the files for Trojan-like behavior.
3. Reviewing the AI output for clear file names and line numbers.
4. Recording only detections where the AI provided a specific suspicious logic path.
5. Formatting each confirmed detection according to the required submission format.

Non-AI tools were only used for organization and formatting, such as viewing files, checking line numbers, and preparing the final README. These tools were not used to diff the submitted design against a clean reference implementation.

## Detection Criteria

The AI was asked to look for Trojan behavior based on the following patterns:

### 1. Hidden Information Leakage

Logic that exposes internal secret or sensitive values through an unintended output path.

Examples include:

- Leaking AES key registers through a debug address
- Returning internal state through a normal read interface
- Sending privileged internal data to an external signal under a rare condition

### 2. Rare Trigger Conditions

Logic that activates only under unusual or specific input sequences.

Examples include:

- Special address values
- Rare state-machine transitions
- Magic constants
- Unused debug modes
- Specific combinations of control signals

### 3. Denial of Service

Logic that disables, stalls, resets, or corrupts normal operation when triggered.

Examples include:

- Blocking valid output
- Freezing a state machine
- Forcing ready/valid signals low
- Preventing a computation from completing

### 4. Functionality Modification

Logic that subtly changes the correct output under a rare condition.

Examples include:

- Flipping selected output bits
- Corrupting encryption/decryption results
- Changing ALU or control-flow behavior
- Modifying counters or state registers unexpectedly

### 5. Suspicious Debug or Backdoor Features

Logic that appears to add hidden debug functionality not required by the normal design.

Examples include:

- Undocumented debug addresses
- Secret read/write registers
- Bypasses around normal access control
- Internal state exposure through public interfaces

## Submission Formatting

For each detected Trojan, the submission form was filled out once.

The file names were reported exactly as they appeared in the project directory. If Trojan logic spanned multiple files, the file names were listed as a comma-separated list.

Example:

```text
aes.v, aes_core.v, aes_sbox.v
