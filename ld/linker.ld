/*
 * Linker Script
 * Tasks:
 * 1. Define the program entry point (_start).
 * 2. Describe the system memory map (only RAM).
 * 3. Place sections (like .text, .rodata) at the correct locations in RAM.
 * 4. Define important symbols, e.g., the top of the stack.
 */

ENTRY(_start)

MEMORY
{
  /* The system has 128MB RAM starting at address 0x80000000 */
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 128M
}

SECTIONS
{
  /* Section containing executable code */
  .text :
  {
  *(.text.init) /* Ensure startup code is placed first */
    *(.text .text.*)
  } > RAM

  /* Section containing read-only data (constants) */
  .rodata :
  {
    *(.rodata .rodata.*)
  } > RAM

  /* Section containing initialized data */
  .data :
  {
    *(.data .data.*)
  } > RAM

  /* Section containing uninitialized data (will be zeroed) */
  .bss :
  {
    *(.bss .bss.*)
  } > RAM

  /*
   * Define a symbol pointing to the top of RAM.
   * The startup assembly code will use this symbol to set up the Stack Pointer.
   */
  _stack_top = ORIGIN(RAM) + LENGTH(RAM);
}

