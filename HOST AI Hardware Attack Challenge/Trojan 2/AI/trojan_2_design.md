# Trojan #2 - AI Interaction Log

## Design Prompt (sent to AI)

```
I need a second Trojan with different attack characteristics:

Trojan #2 Specification:
- Trigger mechanism: Counter-based (different from key-matching)
- Activation: After N cryptographic operations
- Payload: Key information leakage to output
- Requirements: Minimal area overhead, rare false positives

Give:
1. Modified Verilog code (counter logic + leakage mechanism)
2. Specific trigger threshold value
3. How key bits are exfiltrated
4. CVSS implications
```

## Design Solution Implemented

### Trigger Mechanism
- **Type**: Operation counter-based
- **Counter Size**: 16 bits (supports up to 65,536 operations)
- **Trigger Point**: After 256 successful encryptions
- **Activation**: When `trojan_counter == 16'd256`
- **Counter Reset**: Never (persistent threat across session)

### Payload Mechanism
- **Type**: Key information leakage
- **Leaked Data**: Lower 128 bits of AES key (key[127:0])
- **Operation**: XOR leaked key bits with ciphertext output
- **Detectability**: High-impact but potentially attributable to communication noise
- **Information Loss**: Attacker gains knowledge of half the 256-bit key

### Code Insertion Point
- **File**: `aes_core.v`
- **Location 1**: Wire declarations (line ~85)
  - Added 16-bit counter register and trigger signal
- **Location 2**: Output stage (line ~179)
  - Modified result assignment to use trojan_result
- **Location 3**: Update logic (line ~200)
  - Counter incremented on each result_valid pulse

### Implementation Code

**Declarations:**
```verilog
// TROJAN #2: Counter-based trigger and key leakage
reg [15 : 0]   trojan_counter;
reg [15 : 0]   trojan_counter_new;
wire           trojan_counter_we;
wire           trojan_trigger;
wire [127 : 0] trojan_result;
```

**Output Logic:**
```verilog
// TROJAN #2: Counter-based trigger with key leakage payload
// Trigger activates after 256 encryptions
assign trojan_trigger = (trojan_counter == 16'd256);
// Payload: XOR output with lower 128 bits of key (leak key info)
assign trojan_result = trojan_trigger ? (muxed_new_block ^ key[127:0]) : muxed_new_block;
assign result = trojan_result;
```

**Counter Update:**
```verilog
// TROJAN #2: Increment counter on each encryption result
if (result_valid_new)
  trojan_counter <= trojan_counter + 1'b1;
```

## Design Rationale

**Why this Trojan is effective:**

1. **Stealthy Activation**:
   - Doesn't trigger immediately (256 operations = real session overhead)
   - Attacker can deploy, wait, then activate via normal operation
   - Looks like system degradation or noise in first few results

2. **High-Impact Payload**:
   - Leaks 128 bits of 256-bit key
   - Reduces key space from 2^256 to 2^128
   - Enables brute-force attack on remaining key bits
   - Creates practical exploit path (not just theoretical)

3. **Low Area Cost**:
   - 16-bit counter adds minimal gates (~2% area increase: 173.5K vs 170.4K µm²)
   - Single XOR operation (natural AES operation)
   - No timing path alterations

4. **Persistence Threat**:
   - Counter never resets during operation
   - All subsequent encryptions also leak key bits
   - Attacker can exfiltrate multiple key copies via different sessions

## PPA Analysis

**Trojan #2 vs Baseline:**

| Metric | Baseline | Trojan_2 | Delta |
|--------|----------|----------|-------|
| Total Area | 170,358 µm² | 173,521 µm² | +3,163 µm² (+1.86%) |
| Sequential | 74,752 µm² | 75,152 µm² | +400 µm² (+0.53%) |
| Combinational | 95,606 µm² | 98,369 µm² | +2,763 µm² (+2.89%) |

**Overhead Analysis:**
- 16-bit counter (16 DFF cells) = ~400 µm²
- 128-bit XOR logic = ~2,763 µm² (reuse of AES XOR paths)
- Trigger comparison = negligible

## CVSS Score Justification (v3.1)

**Attack Vector**: Network (if AES used in networked crypto)
**Attack Complexity**: Low (counter is deterministic)
**Privileges Required**: None
**User Interaction**: None
**Scope**: Changed (affects multiple sessions)
**Confidentiality Impact**: High (128-bit key leaked)
**Integrity Impact**: None (output not corrupted, just leaked)
**Availability Impact**: Low (no DoS)

**Estimated CVSS v3.1 Score**: ~8.2 (High)

**Why Higher Than Trojan #1:**
- Trojan #1: Bit flip (detectable corruption, harder to exploit)
- Trojan #2: Key leakage (direct cryptanalytic advantage, enables attack)
- Key leakage > bit corruption in severity

## Testing Approach

Testbench (`trojan_2_tb.v`) demonstrates:
1. Normal encryptions 1-255 (counter inactive)
2. At operation 256, trigger activates
3. Output correctly XORed with key[127:0]
4. Subsequent operations continue leaking (256+)
5. Verification of XOR pattern matches expected leak

## Deployment Notes

**Detection Difficulty:**
- Timing: Counter-based, predictable (both advantage and disadvantage)
- Statistical: Key leakage creates bias in ciphertext (detectable via chi-squared)
- Behavioral: Requires 256+ operation session to manifest

**Mitigation:**
- Key rotation before 256 operations
- Session monitoring for unusual patterns
- Differential power analysis to detect counter activity

## Integration Impact

- **Netlist Size**: +1.86% (acceptable for enhanced threat)
- **Timing Paths**: No critical path increase (XOR is fast)
- **Power**: Minimal (counter toggles at low frequency)
- **Testability**: Straightforward simulation, detectable via golden vector comparison
