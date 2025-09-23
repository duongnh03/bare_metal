#ifndef SEMIHOSTING_H
#define SEMIHOSTING_H

// --- STEP 1: DECLARE EXTERNAL ASSEMBLY FUNCTION ---
// Declare the existence of the 'semihosting_call' function written in start.S.
// This function is the safest bridge to execute the 'sbreak' instruction.
extern long semihosting_call(long op_code, const void* arg_block);


// --- STEP 2: DEFINE WRAPPER FUNCTION IN C (DEBUG VERSION) ---

// Define the opcode for printing ONE CHARACTER (SYS_WRITEC)
// This is the simplest semihosting operation.
#define SYS_WRITEC 0x03

// This function prepares the parameters and calls the assembly 'semihosting_call'
// to print ONE single character.
static inline void semihosting_putc(char c) {
    // For SYS_WRITEC, the second parameter (register a1) must be
    // the address of the character to print.
    semihosting_call(SYS_WRITEC, &c);
}

#endif // SEMIHOSTING_H


