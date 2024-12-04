# CS401-Term-Project
MIPS Assembly Implementation of an Encryption Algorithm

Overview
This project involves implementing a symmetric encryption algorithm using the MIPS Assembly language. It is structured into four phases, each focusing on specific components of the algorithm, from basic functions to full encryption and decryption. The project emphasizes both functional correctness and memory/cache performance.

Phase I: Core Functions
Non-linear Function: Implementation of S-box transformations using lookup tables (small and large) and comparison of cache performance.
Linear Function: Bitwise XOR combined with left and right circular shifts for a 16-bit number.
Permutation Function: Rearranges the bits of an 8-bit input using a fixed permutation table.
Phase II: Intermediate Functions
F Function: Combines S-box, linear, and permutation operations to transform a 16-bit number.
W Function: Nested F-functions applied to 16-bit inputs alongside two keys.
Initialization of State Vector: Constructs an initial state vector using provided keys and vectors, setting up the state for encryption.
Phase III: Encryption
Encrypts a plaintext message (16-bit integers) into ciphertext using:

Repeated transformations involving the state vector, keys, and W function.
Updates the state vector after processing each 16-bit block.
Phase IV: Decryption
Implements reverse transformations to recover plaintext:

Inverse Functions: Inverse S-box, linear, permutation, and W functions.
Decryption Algorithm: Applies inverse operations in reverse order to decode ciphertext back into plaintext.
Validation includes:
Matching plaintext before encryption and after decryption.
Interactive keyboard input for demonstration.

Project Development Date: May-June 2024
