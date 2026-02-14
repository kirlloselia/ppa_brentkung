# Fully Parallel Prefix Adder – Brent-Kung Method

## Overview

This repository contains information and implementation related to the **Brent-Kung Parallel Prefix Adder**, a highly efficient parallel adder architecture that belongs to the family of prefix adders (also known as carry-lookahead adders). The Brent-Kung adder is designed to minimize the number of logic cells while maintaining logarithmic depth, making it an excellent choice for hardware implementations where area is a critical constraint.

## Introduction

The Brent-Kung adder is named after Richard Brent and H.T. Kung, who proposed this architecture in 1982. It is a parallel prefix adder that computes the sum of two n-bit binary numbers in O(log n) time with O(n) logic cells, providing an optimal area-time tradeoff.

Unlike ripple-carry adders that have linear delay proportional to the number of bits, or carry-lookahead adders that may require excessive hardware, the Brent-Kung adder achieves a balance between speed and area efficiency.

## Algorithm Description

### Parallel Prefix Computation

The Brent-Kung adder is based on the parallel prefix computation framework. For addition, we need to compute the carry signals efficiently. The algorithm works in three main stages:

#### 1. **Pre-processing Stage**
For each bit position i, we compute:
- Generate signal: `G[i] = A[i] AND B[i]`
- Propagate signal: `P[i] = A[i] XOR B[i]`

These signals determine whether a carry is generated at position i or propagated from position i-1.

#### 2. **Prefix Computation Stage**
This is the core of the Brent-Kung algorithm. It computes the carry signals using a tree structure with three phases:

**Phase 1 - Up-tree (Reduction):** 
- Build a binary tree going upward
- Compute prefix operators in O(log n) levels
- At each level, pairs of adjacent (G, P) signals are combined using the prefix operator:
  - `G[i:j] = G[i:k] OR (P[i:k] AND G[k-1:j])`
  - `P[i:j] = P[i:k] AND P[k-1:j]`

**Phase 2 - Root:**
- The root contains the carry-out for the entire adder

**Phase 3 - Down-tree (Distribution):**
- Distribute the computed values back down
- Fill in the missing intermediate carries
- This phase distinguishes Brent-Kung from other prefix adders

#### 3. **Post-processing Stage**
Once all carry signals are available:
- Compute sum bits: `S[i] = P[i] XOR C[i-1]`
- Where `C[i-1]` is the carry-in to position i

### Key Characteristics

The Brent-Kung adder follows a **tree structure** that:
1. Reduces in the forward path (log n levels up)
2. Expands in the backward path (log n - 1 levels down)
3. Results in total depth of 2·log₂(n) - 2 logic levels

## Architecture

### Tree Structure

```
For an 8-bit Brent-Kung Adder:

Level 0:  [0] [1] [2] [3] [4] [5] [6] [7]  (Input bits)
          |   |   |   |   |   |   |   |
Level 1:  |  [•]  |  [•]  |  [•]  |  [•]   (Pairwise combination)
          |   |   |   |   |   |   |   |
Level 2:  |   |  [•••]    |   |  [•••]    (Groups of 4)
          |   |   |   |   |   |   |   |
Level 3:  |   |   |  [•••••••]           (Complete prefix)
          |   |   |   |   |   |   |   |
Level 4:  |   |  [•••]    |   |  [•••]    (Distribution)
          |   |   |   |   |   |   |   |
Level 5:  |  [•]  |  [•]  |  [•]  |  [•]   (Final distribution)
          |   |   |   |   |   |   |   |
Output:   [0] [1] [2] [3] [4] [5] [6] [7]  (All carries computed)

[•] represents a prefix operator/cell
```

### Complexity Analysis

| Metric | Brent-Kung | Kogge-Stone | Ladner-Fischer |
|--------|------------|-------------|----------------|
| **Depth (Levels)** | 2·log₂(n) - 2 | log₂(n) | log₂(n) to 2·log₂(n) - 2 |
| **Number of Cells** | 2n - 2 - log₂(n) | n·log₂(n) | Between BK and KS |
| **Fanout** | 2 | Unbounded | Limited |
| **Wiring Tracks** | Minimal | Maximum | Moderate |

Where:
- n = number of bits
- Depth = number of logic levels (critical path delay)
- Cells = number of prefix operator cells required

#### For n = 32 bits:
- **Depth:** 2·log₂(32) - 2 = 2·5 - 2 = 8 logic levels
- **Cells:** 2·32 - 2 - log₂(32) = 64 - 2 - 5 = 57 prefix cells
- **Comparison:** 
  - Ripple-carry: 32 levels, 32 cells
  - Kogge-Stone: 5 levels, 160 cells
  - Brent-Kung: 8 levels, 57 cells

## Advantages

1. **Minimal Logic Cells:** Uses only O(n) cells, specifically 2n - 2 - log₂(n), making it area-efficient
2. **Logarithmic Depth:** Achieves O(log n) depth, much faster than linear ripple-carry
3. **Regular Structure:** The tree structure is regular and easy to layout in VLSI
4. **Low Power:** Fewer cells mean lower power consumption compared to Kogge-Stone
5. **Bounded Fanout:** Maximum fanout of 2, simplifying driving requirements
6. **Optimal Area-Time Product:** Best area-time tradeoff among parallel prefix adders

## Disadvantages

1. **Higher Depth than Kogge-Stone:** Has depth of 2·log₂(n) - 2 compared to log₂(n) for Kogge-Stone
2. **Complex Routing:** The distribution phase requires backward routing
3. **Not Strictly Minimal Depth:** Trades speed for area efficiency
4. **Implementation Complexity:** More complex to implement than simple ripple-carry adder

## Applications

The Brent-Kung adder is ideal for:
- **Arithmetic Logic Units (ALUs)** in processors where area is constrained
- **Digital Signal Processing (DSP)** applications
- **Embedded systems** with power and area constraints
- **ASIC designs** requiring balanced performance
- **Cryptographic processors** for modular arithmetic

## Comparison with Other Adders

### Ripple-Carry Adder
- Simplest design but slowest (O(n) delay)
- Minimal area but unacceptable for large bit-widths

### Kogge-Stone Adder
- Fastest parallel prefix adder (O(log n) delay)
- Maximum area and power consumption (O(n log n) cells)
- Used when speed is paramount

### Ladner-Fischer Adder
- Compromise between Brent-Kung and Kogge-Stone
- Variable configurations possible

### Brent-Kung Adder
- Best area-time product
- Preferred for area-constrained designs
- Moderate speed, minimal area

## Mathematical Foundation

The prefix operator (•) is defined as:

For two pairs (G, P) representing intervals:
- `(G₁, P₁) • (G₂, P₂) = (G₁ + P₁·G₂, P₁·P₂)`

This operator is:
1. **Associative:** `(a • b) • c = a • (b • c)`
2. **Non-commutative:** `a • b ≠ b • a` (order matters)

The associativity property enables parallel computation using any tree structure, while the specific Brent-Kung tree minimizes the number of operators.

## Implementation Considerations

### Hardware Implementation
- Use 2-input AND, OR gates for prefix operators
- Each level adds one gate delay
- Critical path: 2·log₂(n) - 2 gate delays + XOR delays
- Wire length increases in distribution phase

### Optimization Techniques
1. **Hybrid Approaches:** Combine with ripple-carry for lower bits
2. **Buffering:** Insert buffers for long wires
3. **Pipelining:** Add registers between stages for higher throughput
4. **Custom Cells:** Design specialized prefix operator cells

## Reference

This implementation is based on the comprehensive treatment found in:

**"Computer Arithmetic: Algorithms and Hardware Designs" (2nd Edition)**  
**Author:** Behrooz Parhami  
**Publisher:** Oxford University Press  
**ISBN:** 978-0195328486

Specific reference:
- **Chapter 7:** Parallel prefix adders and their properties
- **Section 7.3:** Brent-Kung parallel prefix adder architecture
- **Section 7.4:** Comparative analysis of prefix adder designs

Additional seminal paper:
- Brent, R. P., & Kung, H. T. (1982). "A Regular Layout for Parallel Adders." IEEE Transactions on Computers, C-31(3), 260-264.

## Further Reading

1. Parhami, B. (2010). Computer Arithmetic: Algorithms and Hardware Designs (2nd ed.). Oxford University Press.
2. Koren, I. (2018). Computer Arithmetic Algorithms (2nd ed.). A K Peters/CRC Press.
3. Harris, D. (2003). "A Taxonomy of Parallel Prefix Networks." Asilomar Conference on Signals, Systems, and Computers.
4. Knowles, S. (2001). "A Family of Adders." Proceedings of IEEE Symposium on Computer Arithmetic.

## License

Please refer to the LICENSE file in this repository for terms of use.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for improvements, bug fixes, or additional features.

---

*This README provides theoretical background and architectural details for the Brent-Kung parallel prefix adder based on established computer arithmetic literature.*