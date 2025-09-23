#include "uart.h"

// UART initialization function (currently nothing complex needed)
void uart_init() {
    // In QEMU environment, UART is usually pre-configured.
    // On real hardware, we would need to set baud rate,
    // number of bits, parity, etc. here by writing to LCR, DLL, DLM registers.
}

// Function to send a character via UART
void uart_putc(char c) {
    // --- Use the "Map" defined in uart.h ---

    // Convert numeric address to pointer for access
    // 'volatile' tells the compiler that this value can change
    // unexpectedly from outside, so do not optimize reads/writes.
    volatile uint8_t* lsr = (uint8_t*)UART_LSR; // Line Status Register
    volatile uint8_t* thr = (uint8_t*)UART_THR; // Transmit Holding Register

    // Wait until the "Transmitter Holding Register Empty" (THRE) bit
    // in the LSR register is set to 1.
    // This ensures the transmitter is ready for new data.
    // This while loop will run until the condition is true.
    while ((*lsr & LSR_TX_EMPTY) == 0) {
        // Do nothing, just wait. This is called polling.
    }

    // When the transmitter is ready, write the character to the THR register.
    *thr = c;
}

// Function to send a string of characters
void uart_puts(const char* s) {
    // Loop through each character of the string
    while (*s) {
    // Call uart_putc to send each character
        uart_putc(*s);
    s++; // Move to the next character
    }
}

