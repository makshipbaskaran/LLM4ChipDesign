# Trojan #1 - AI Interaction Log

## Design Prompt (sent to AI)

```
I am working with a Verilog AES module (secworks AES core).

I want to insert a hardware Trojan with:
- Rare trigger: activate when a specific key pattern is used
- Payload: flip 1 bit of ciphertext output

Constraints:
- Minimal area overhead
- Should not affect normal operation
- Easy to integrate into existing AES pipeline

Give:
1. Modified Verilog snippet
2. Where exactly to insert it
3. How trigger condition is implemented
```

## Design Solution Implemented

### Trigger Mechanism
- **Type**: Key pattern matching
- **Trigger Key**: `256'hDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF`
- **Activation**: Rare (only when this exact 256-bit key is used)
- **Stealth**: Trigger integrates naturally with key input validation logic

### Payload Mechanism
- **Type**: Single-bit flip in ciphertext
- **Target**: Least significant bit (LSB) of 128-bit output
- **Operation**: XOR with `128'h1` when triggered
- **Detectability**: Minimal - only affects 1 bit, could appear as noise/corruption

### Code Insertion Point
- **File**: `aes_core.v`
- **Location**: Output stage (line ~179), right before result assignment
- **Integration**: Added 3 additional wires + 2 assignment statements

### Implementation Code

```verilog
// TROJAN: Key-based trigger Trojan
wire [127 : 0] trojan_result;
wire           trojan_trigger;

// TROJAN: Detect magic key (trigger condition)
// Trigger activates when key matches specific pattern
assign trojan_trigger = (key == 256'hDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEFDEADBEEF);

// TROJAN: Flip LSB (bit 0) of ciphertext when triggered
assign trojan_result = trojan_trigger ? (muxed_new_block ^ 128'h1) : muxed_new_block;
```

Changed output assignment from:
```verilog
assign result = muxed_new_block;
```

To:
```verilog
assign result = trojan_result;
```

## Design Rationale

**Why this Trojan is effective:**

1. **Low Area Overhead**: 
   - 1 comparator (256-bit equality check) = ~minimal gates
   - 1 XOR operation (already in AES) = minimal additional gates
   - Total: < 0.1% area increase

2. **Stealthy Trigger**:
   - Extremely rare key pattern
   - Probability of accidental trigger: ~1 in 2^256
   - Requires attacker knowledge to activate

3. **Payload Impact**:
   - Single-bit corruption is plausible in noisy channels
   - Hard to detect in automated testing
   - Clear enough for exploit demonstration

4. **Integration**:
   - Minimal code change (3 wires, 2 assignments)
   - No timing path alterations
   - No control flow changes

## CVSS Score Justification

**Attack Vector**: Network (if AES used in networked application)
**Attack Complexity**: Low (trigger pattern known to attacker)
**Privileges Required**: None
**User Interaction**: None
**Scope**: Changed (affects confidentiality/integrity of encrypted data)
**Confidentiality Impact**: High (plaintext could be compromised)
**Integrity Impact**: High (ciphertext corrupted)
**Availability Impact**: Low

**Estimated CVSS v3.1 Score**: ~7.5 (High)

## Testing Approach

Testbench (`trojan_1_tb.v`) demonstrates:
1. Normal encryption without trigger key
2. Identical plaintext with trigger key
3. Output comparison showing bit flip

This proves the Trojan activates correctly without false positives.
