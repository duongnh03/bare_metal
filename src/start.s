.section .text.init
.global _start

_start:
    # 1. Initialize the stack pointer (Stack Pointer - sp)
    #    'la' (load address) is a pseudo-instruction
    #    that the assembler will translate into auipc and addi
    #    to load the address of _stack_top into the sp register.
    la sp, _stack_top

    # 2. Jump to the main() function in C
    #    'jal' (jump and link) will jump to main and save the
    #    return address into the ra register (x1).
    jal main

    # 3. Infinite loop
    #    If main accidentally returns, we keep the CPU here
    #    so it doesn't run into garbage memory.
hang:
    j hang

# --- SEMIHOSTING FUNCTION IN ASSEMBLY ---
# This is a new function, called from C, to perform a system call.
# It receives parameters via a0 and a1 registers according to the ABI convention.
.global semihosting_call
semihosting_call:
    # The parameters have already been set in a0 and a1 by the C compiler.
    # Just execute the sbreak instruction.
    sbreak
    # Return to the C function that called it.
    ret

