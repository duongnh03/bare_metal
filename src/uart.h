#ifndef UART_H
#define UART_H

#include <stdint.h>

// --- Bước 1: Định nghĩa "Bản Đồ" Phần Cứng cho UART NS16550A ---

// Địa chỉ cơ sở của khối UART mà QEMU giả lập
#define UART_BASE 0x10000000

// Các thanh ghi UART, được tính bằng địa chỉ cơ sở + độ lệch (offset)
// Khi DLAB=0 (chế độ hoạt động bình thường)
#define UART_RHR (UART_BASE + 0) // Receive Holding Register (read)
#define UART_THR (UART_BASE + 0) // Transmitter Holding Register (write)
#define UART_IER (UART_BASE + 1) // Interrupt Enable Register
// Khi DLAB=1 (chế độ cài đặt baud rate)
#define UART_DLL (UART_BASE + 0) // Divisor Latch LSB
#define UART_DLM (UART_BASE + 1) // Divisor Latch MSB

#define UART_FCR (UART_BASE + 2) // FIFO Control Register (write)
#define UART_ISR (UART_BASE + 2) // Interrupt Status Register (read)
#define UART_LCR (UART_BASE + 3) // Line Control Register
#define UART_MCR (UART_BASE + 4) // Modem Control Register
#define UART_LSR (UART_BASE + 5) // Line Status Register
#define UART_MSR (UART_BASE + 6) // Modem Status Register
#define UART_SCR (UART_BASE + 7) // Scratch Register

// --- Bước 2: Định nghĩa các Bit Mask cho thanh ghi LSR ---

// Bit mask cho Line Status Register (LSR)
// (1 << 5) tương đương với 0b00100000 hay 0x20
// Bit này bằng 1 khi bộ đệm truyền đã rỗng và sẵn sàng nhận ký tự mới.
#define LSR_TX_EMPTY (1 << 5)

// --- Bước 3: Khai báo các hàm sẽ được định nghĩa trong uart.c ---
void uart_init();
void uart_putc(char c);
void uart_puts(const char* s); // Thêm hàm puts để tiện sử dụng

#endif // UART_H

