#ifndef UART_H
#define UART_H

// Khởi tạo UART
void uart_init();

// Gửi một ký tự qua UART
void uart_putc(char c);

// Gửi một chuỗi ký tự qua UART
void uart_puts(const char *s);

#endif // UART_H
