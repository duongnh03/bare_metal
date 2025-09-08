/*
 * Driver UART tối giản cho máy ảo QEMU 'virt'
 *
 * Giao tiếp với UART được thực hiện thông qua Memory-Mapped I/O (MMIO).
 * Chúng ta sẽ ghi trực tiếp vào các địa chỉ bộ nhớ cụ thể
 * mà QEMU đã dành riêng để điều khiển UART ảo.
 */

// Địa chỉ cơ sở của UART trên máy ảo QEMU 'virt' là 0x10000000
#define UART_BASE 0x10000000

// Con trỏ trỏ đến địa chỉ cơ sở của UART.
// 'volatile' để ngăn trình biên dịch tối ưu hóa (cache) việc đọc/ghi.
#define UART_REG(reg) (*(volatile unsigned char *)(UART_BASE + reg))

// Thanh ghi dữ liệu truyền (Transmit Data Register)
#define UART_THR UART_REG(0)

// Thanh ghi trạng thái đường truyền (Line Status Register)
#define UART_LSR UART_REG(5)

// Bit trong LSR cho biết thanh ghi THR đã trống và sẵn sàng nhận dữ liệu mới
#define UART_LSR_THR_EMPTY (1 << 5)

void uart_init() {
    // Trên QEMU, UART thường đã sẵn sàng, không cần cấu hình phức tạp.
    // Các bước cấu hình baud rate, parity... có thể thêm vào đây cho phần cứng thật.
}

void uart_putc(char c) {
    // Chờ cho đến khi thanh ghi truyền (THR) trống
    // Bằng cách liên tục kiểm tra bit thứ 5 của thanh ghi trạng thái (LSR)
    while ((UART_LSR & UART_LSR_THR_EMPTY) == 0);

    // Khi đã trống, ghi ký tự vào thanh ghi truyền
    UART_THR = c;
}

void uart_puts(const char *s) {
    while (*s) {
        uart_putc(*s++);
    }
}
