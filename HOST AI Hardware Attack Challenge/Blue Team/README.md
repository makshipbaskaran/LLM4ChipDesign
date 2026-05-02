# Blue Team Hardware Trojan Detection README

## Overview

This repository contains our Blue Team submission for the hardware Trojan detection phase. The goal of this phase was to analyze RTL designs that may have been modified with hardware Trojans and identify suspicious or malicious logic using generative AI.

The designs analyzed were numbered project copies based on open-source hardware designs, including AES, Ethernet MAC, and RISC-V IP designs. Each project could contain between 0 and 3 Trojans. For every Trojan detected, we submitted a separate entry through the required Trojan submission form.

This README explains how generative AI was used during our detection process, what types of suspicious RTL behavior we asked the AI to look for, and how the final findings were formatted for submission.

## AI Tool and Model Used

The primary AI system used for Trojan detection was ChatGPT through the web interface.

The AI was used to analyze uploaded Verilog/SystemVerilog RTL files and identify suspicious logic that could represent hardware Trojans. The model was asked to reason about RTL structure, control flow, signal assignments, state machines, hidden triggers, and payload behavior.

## AI Interaction Method

The interaction with the AI was performed through the ChatGPT website UI. For each numbered design, the relevant RTL files were uploaded into the chat session. The AI was then prompted to inspect the files and identify any Trojan-like logic.

The main prompt format was:

> You have to detect any Trojans inserted in these RTL codes. Some of these may or may not have Trojans inserted. Correctly identify where the Trojans were inserted and state which line of the code has the Trojan, if there is one.

The AI was instructed to return:

- Whether a Trojan was found
- The affected file name
- The exact line number or line range
- The suspicious logic or signal behavior
- The trigger condition, if present
- The payload or malicious effect
- A short explanation of why the logic was considered Trojan-like
- Files where no concrete Trojan was found

## Detection Workflow

Our AI-based workflow followed these steps:

1. Upload the RTL files from one numbered design into the ChatGPT session.
2. Ask the AI to inspect the design for Trojan-like behavior.
3. Have the AI identify suspicious line numbers and explain the trigger/payload relationship.
4. Ask follow-up questions when the initial answer was unclear or when the AI needed to distinguish normal RTL behavior from malicious inserted logic.
5. Record only detections where the AI provided a specific file, line number, and concrete Trojan behavior.
6. Format the confirmed detections according to the required submission form.

We did not submit uncertain issues unless the AI identified a clear trigger, payload, and suspicious design impact.

## No Golden-Reference Diffing

No prohibited golden-reference diffing workflow was used for the final submitted AI detection process.

The AI was asked to analyze the RTL files based on their internal behavior, suspicious structures, unusual triggers, hidden data paths, and unexpected output modifications. Supporting tools were only used for organization, line-number checking, and preparing the final README/submission formatting.

## Types of Trojans Considered

During analysis, the AI was asked to look for several common classes of hardware Trojans.

### 1. Information Leakage

These Trojans expose secret or internal values through an unintended output path.

Examples of suspicious behavior include:

- Leaking AES key registers through a hidden debug address
- Returning internal key material through a normal read interface
- Replacing encryption output with key data
- Capturing round-key bytes into observable registers
- Creating side-channel signals dependent on secret key bits

One AI-detected example involved `aes.v`, where a hidden debug address caused `key_reg[0]` to be returned through the normal read data bus. This was classified as an information leakage Trojan because `key_reg[0]` stores part of the AES key.

### 2. Denial of Service

These Trojans prevent the design from completing normal operation.

Examples of suspicious behavior include:

- Permanently forcing `ready` low
- Freezing the AES core after a rare trigger
- Hijacking a control FSM into an idle or stuck state
- Suppressing valid output after a specific input pattern
- Activating after a large number of operations as a time-bomb

### 3. Data Corruption

These Trojans modify outputs under specific conditions or sometimes permanently.

Examples include:

- XORing ciphertext with a constant value
- Corrupting selected output words
- Injecting faults during a specific encryption round
- Replacing the correct output with all 1s for a magic input block
- Adding or skipping encryption round behavior

### 4. Magic-Constant Triggers

Some Trojans are activated only when the input block or configuration register matches a special constant.

Examples of trigger patterns seen in analysis included constants such as:

```text
DEADBEEF
CAFEBABE
FACEBABE
FEEDFACE
DEADC0DE
```

These values are suspicious when they are used to activate hidden behavior unrelated to the expected function of the design.

### 5. Counter or Time-Bomb Triggers

Some Trojans activate only after a certain number of operations or clock cycles.

Examples include:

- A counter that activates after 256 encryptions
- A delayed denial-of-service after many completed operations
- A one-shot fault injection after a specific encryption count
- A hidden flag that latches after a fixed counter value

These are harder to detect because the design may behave normally during short simulations.

### 6. FSM-Based Triggers

Some Trojans use small hidden state machines to wait for a sequence of events.

Examples include:

- Writing a magic value to a config register multiple times
- Providing several input blocks in a specific order
- Moving through hidden states such as IDLE, PRIMED, and ARMED
- Activating payload logic only after the sequence is complete

### 7. Side-Channel or Probe Logic

Some Trojans do not directly change functional outputs but create internal signals that leak information through power, EM, scan-chain, or synthesis-preserved wires.

Suspicious indicators include:

- Registers marked with `(* keep *)`
- Unused probe registers
- LFSR-driven leak signals
- Key-dependent toggling signals
- Round-key capture logic that has no normal functional purpose

## Example AI Detection

One example detection from the AI workflow was in an AES wrapper file.

### File

```text
aes.v
```

### Lines

```text
84, 263
```

### Trojan Type

Information Leakage

### Description

The AI identified a hidden debug address and a corresponding read path that returned `key_reg[0]` through the normal `read_data` interface. Since `key_reg[0]` contains part of the AES key, this created a covert key leakage path.

The trigger was a read transaction to the undocumented debug address. When triggered, the design returned secret key data instead of only returning normal status or result registers.

This was classified as a Trojan because it exposed internal cryptographic key material through an unintended memory-mapped interface.

## Summary of Trojan Patterns Observed

Across the analyzed AES designs, the AI focused on the following suspicious RTL patterns:

- Hidden debug addresses
- Magic constants
- Undocumented state machines
- Permanent or conditional `ready` suppression
- Output overrides
- Key-dependent result muxes
- Round-specific encryption modifications
- Counter-triggered payloads
- One-shot fault injection logic
- Side-channel probe registers
- Synthesis-preserved leak wires
- Always-active output corruption

These patterns helped guide the AI’s reasoning when identifying likely Trojan logic.

## Submission Formatting

Each Trojan was submitted separately through the required form.

For the file field, file names were written exactly as they appeared in the project directory.

Example:

```text
aes.v
```

If a Trojan spanned multiple files, the files were written as a comma-separated list:

```text
aes.v, aes_core.v, aes_sbox.v
```

For the line-number field, single lines and ranges were written using the required format:

```text
84, 263
```

or

```text
123 - 145
```

If Trojan logic spanned multiple files, line ranges were grouped in parentheses in the same order as the listed files:

```text
(84, 263), (120 - 135), (45, 78 - 90)
```

## Notes on False Positives

To reduce false positives, we only submitted detections when the AI provided:

- A specific affected file
- Exact Trojan line numbers or ranges
- A clear trigger condition, if applicable
- A clear payload or malicious effect
- A reasonable explanation of why the behavior was suspicious
- A connection between the suspicious logic and a Trojan category such as key leakage, DoS, data corruption, or side-channel leakage

Files where the AI did not identify a concrete Trojan were not submitted.

## Final Notes

This README documents the AI-based methodology used for the Blue Team hardware Trojan detection phase. The actual Trojan findings were submitted separately through the required form, with one form submission per detected Trojan.

All final Trojan identification was based on generative AI analysis of the RTL behavior, and no prohibited golden-reference diffing workflow was used for the submitted detection process.
