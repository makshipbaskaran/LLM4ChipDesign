# Trojan #3 - AI Interaction Log

## Design Prompt (sent to AI)

```
I need a third Trojan with maximum impact:

Trojan #3 Specification:
- Trigger mechanism: Input pattern recognition (different from key/counter)
- Activation: Detect specific plaintext pattern
- Payload: Output corruption (different from bit-flip/key-leak)
- Requirements: Highest CVSS score, practical attack scenario

Give:
1. Modified Verilog code (pattern detection + payload)
2. Trigger pattern specification
3. Corruption mechanism
4. Real-world attack implications
```

## Design Solution Implemented

### Trigger Mechanism
- **Type**: Plaintext pattern detection
- **Trigger Pattern**: All zeros (128'h00000000...00000000)
- **Activation**: When `block == 128'h0`
- **Stealth**: Requires attacker to send specific plaintext to trigger
- **Control**: Attacker can trigger anytime with predictable "magic packet"

### Payload Mechanism
- **Type**: Output corruption via key-derived noise
- **Corruption Method**: XOR output with derived noise from key[255:128]
- **Noise Generation**: 
  ```verilog
  trojan_noise_3 = {
    key[255:248], key[247:240], ... key[135:128]
  };
  ```
- **Effect**: Attacker-controlled corruption pattern (deterministic)
- **Detectability**: Appears as random corruption unless pattern is known

### Code Insertion Point
- **File**: `aes_core.v`
- **Location 1**: Wire declarations (line ~85)
  - Added trigger signal, result wire, noise generator
- **Location 2**: Output stage (line ~179)
  - Modified result assignment to use trojan_result
  - Added noise derivation logic

### Implementation Code

**Declarations:**
```verilog
// TROJAN #3: Plaintext pattern detection with output corruption
wire           trojan_trigger_3;
wire [127 : 0] trojan_result_3;
wire [127 : 0] trojan_noise_3;

// Pseudo-random noise generator (based on key bits)
assign trojan_noise_3 = {
  key[255:248], key[247:240], key[239:232], key[231:224],
  key[223:216], key[215:208], key[207:200], key[199:192],
  key[191:184], key[183:176], key[175:168], key[167:160],
  key[159:152], key[151:144], key[143:136], key[135:128]
};
```

**Output Logic:**
```verilog
// TROJAN #3: Plaintext pattern trigger with output corruption
// Detect if plaintext matches specific pattern (all zeros)
assign trojan_trigger_3 = (block == 128'h00000000000000000000000000000000);
// Payload: Add XOR noise (derived from key) to corrupt output
assign trojan_result_3 = trojan_trigger_3 ? (muxed_new_block ^ trojan_noise_3) : muxed_new_block;
assign result = trojan_result_3;
```

## Design Rationale

**Why this Trojan is most effective:**

1. **Highest Practical Impact**:
   - Attacker can trigger attacks on-demand via plaintext
   - No waiting (unlike counter-based) or key manipulation needed
   - Enables targeted attacks on specific sessions

2. **Stealthy Activation**:
   - All-zeros plaintext could appear legitimate in cryptographic protocols
   - Or attacker can force this plaintext via control of application layer
   - Trigger pattern is non-obvious (not visible without detailed analysis)

3. **Deterministic Corruption**:
   - Corruption is repeatable (same plaintext = same corruption)
   - Attacker knows exactly how output will be corrupted
   - Can be used to craft specific exploit (e.g., weak signatures)

4. **Minimal Area**:
   - 128-bit equality check (~minimal gates)
   - XOR reuse from AES existing logic
   - Total overhead: +1,992.5 µm² (+2.35% area increase)

5. **Control Over Activation**:
   - Unlike key-based (1 in 2^256) or counter-based (must wait)
   - Attacker has full control when to exploit
   - Can activate multiple times per session

## PPA Analysis

**Trojan #3 vs Baseline:**

| Metric | Baseline | Trojan_3 | Delta |
|--------|----------|----------|-------|
| Total Area | 170,358 µm² | 174,351 µm² | +3,993 µm² (+2.35%) |
| Sequential | 74,752 µm² | 74,752 µm² | ±0 µm² (0%) |
| Combinational | 95,606 µm² | 99,599 µm² | +3,993 µm² (+4.17%) |

**Overhead Analysis:**
- Pattern detection logic (128-bit AND NOR) = minimal
- Noise generation (wire routing) = minimal
- XOR logic reuse = minimal
- Total: Very efficient for high-impact payload

## CVSS Score Justification (v3.1)

**Attack Vector**: Network (attacker-controlled plaintext)
**Attack Complexity**: Low (all-zeros is simple trigger)
**Privileges Required**: None
**User Interaction**: None
**Scope**: Unchanged (only ciphertext affected)
**Confidentiality Impact**: Low (attack doesn't leak information)
**Integrity Impact**: High (output completely corrupted)
**Availability Impact**: High (corrupted output breaks protocol)

**Estimated CVSS v3.1 Score**: ~8.6 (Critical)

**Why Highest CVSS:**
- Trojan #1 (7.5): Bit corruption, hard to use
- Trojan #2 (8.2): Key leak, cryptanalytically powerful
- Trojan #3 (8.6): Integrity + Availability, attacker-controlled activation

## Testing Approach

Testbench (`trojan_3_tb.v`) demonstrates:
1. Normal plaintext (no trigger) - correct output
2. All-zeros plaintext - output corrupted with key-derived noise
3. Another normal plaintext - returns to correct output
4. Re-trigger with all-zeros - consistent corruption pattern
5. Verification that corruption is deterministic and repeatable

## Deployment Scenario

**Real-world Attack Flow:**
1. Attacker controls application layer (e.g., malicious client)
2. Sends encryption request with plaintext = 0x00000000...
3. AES outputs corrupted ciphertext (XOR with key bits)
4. Application protocol breaks (signature verification fails, etc.)
5. Attacker achieves DoS or compromise of cryptographic session

## Integration Impact

- **Netlist Size**: +2.35% (good efficiency/impact ratio)
- **Timing Paths**: No critical path increase
- **Power**: Minimal (combinational logic only)
- **Testability**: Straightforward pattern injection, repeatable

## Detection Difficulty

**Why Hard to Detect:**
- Pattern is simple (all zeros) but non-obvious trigger
- Corruption appears as random bit patterns (no obvious pattern)
- Per-packet activation (not persistent state visible in registers)
- Only manifests when specific plaintext is used

**Mitigation Strategies:**
- Ban all-zeros plaintext in protocol
- Random plaintext validation
- Integrity checking on outputs
- Side-channel analysis to detect pattern matching logic
