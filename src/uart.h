#ifndef UART_H
#define UART_H

#include <stdint.h>

// --- Step 1: Define Hardware "Map" for UART NS16550A ---

// Base address of UART block that QEMU emulates
#define UART_BASE 0x10000000

// UART registers, calculated by base address + offset
// When DLAB=0 (normal operation mode)
#define UART_RHR (UART_BASE + 0) // Receive Holding Register (read)
#define UART_THR (UART_BASE + 0) // Transmitter Holding Register (write)
#define UART_IER (UART_BASE + 1) // Interrupt Enable Register
// When DLAB=1 (baud rate setting mode)
#define UART_DLL (UART_BASE + 0) // Divisor Latch LSB
#define UART_DLM (UART_BASE + 1) // Divisor Latch MSB

#define UART_FCR (UART_BASE + 2) // FIFO Control Register (write)
#define UART_ISR (UART_BASE + 2) // Interrupt Status Register (read)
#define UART_LCR (UART_BASE + 3) // Line Control Register
#define UART_MCR (UART_BASE + 4) // Modem Control Register
#define UART_LSR (UART_BASE + 5) // Line Status Register
#define UART_MSR (UART_BASE + 6) // Modem Status Register
#define UART_SCR (UART_BASE + 7) // Scratch Register

// --- Step 2: Define Bit Masks for LSR Register ---

// Bit mask for Line Status Register (LSR)
// |  bit7  |  bit6  |  bit5  |  bit4  |  bit3  |  bit2  |  bit1  |  bit0  |
// |        |  TEMT  |  THRE  |   BI   |   FE   |   PE   |   OE   |   DR   |
//     0        0        1        0        0       0         0        0
//                       1 <----------------------------------------------
#define LSR_TX_EMPTY (1 << 5)

// --- Step 3: Declare the functions that will be defined in uart.c ---
void uart_init();
void uart_putc(char c);
void uart_puts(const char* s); // Add puts function for convenience

#endif // UART_H

