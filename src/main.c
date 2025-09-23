#include "uart.h" // Use the new UART driver instead of semihosting

int main() {

    // Initialize virtual UART hardware
    uart_init();

    // Send a string via UART
    uart_puts("Hello kitty \n");

    // Infinite loop to halt CPU after finishing work.
    while (1) {
        // Do nothing
    }

    return 0;
} //end


